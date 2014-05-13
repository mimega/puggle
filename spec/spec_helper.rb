require 'rspec'
require 'puggle'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

Puggle.configure do |config|
  config.config_files = ["spec/fixtures/app.yml"]
end
