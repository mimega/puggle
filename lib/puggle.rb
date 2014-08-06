require "puggle/version"
require "puggle/config"
require "puggle/pno_validator"
require "puggle/scrub_inputs"
require "active_support"
require "puggle/logging_formatter"

module Puggle
  class << self
    attr_accessor :config_files

    def configure
      yield self
    end
  end

  Puggle.configure do |config|
    config.config_files = [
      'config/secrets.yml',
      'config/app.yml'
    ]
  end
end
