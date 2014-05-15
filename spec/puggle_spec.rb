require 'spec_helper'

describe Puggle do
  describe ".config_files" do
    it "returns the config files" do
      expected = ['spec/fixtures/app.yml']
      expect(Puggle.config_files).to eq(expected)
    end
  end

  describe ".configure" do
    before do
     @old = Puggle.config_files
      Puggle.configure { |config| config.config_files << "new.yml" }
    end

    it "sets global config values" do
      expected = ['spec/fixtures/app.yml', 'new.yml']
      expect(Puggle.config_files).to eq(expected)
    end

    after do
      Puggle.configure { |config| config.config_files = @old }
    end
  end
end
