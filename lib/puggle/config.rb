require 'yaml'

module Puggle
  module Config
    def self.load_configuration! (env)
      config = Puggle.config_files.reduce({}) do |res, config_file|
        file = YAML.load_file(config_file)
        res.deep_merge(file.fetch("common", {})).
          deep_merge(file.fetch(env))
      end

      set!(config)
    end

    def self.set! (config)
      config.each do |key, value|
        define_method(key) { value }
        module_function(key)
      end
    end
  end
end
