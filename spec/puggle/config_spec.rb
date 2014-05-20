require 'spec_helper'

module Puggle
  describe Config do
    let(:config) { Puggle::Config }

    describe ".load_configuration!" do
      it "creates methods on the config module specified in YAML files" do
        config.load_configuration!("test")
        expect(config.i_must_be_here).to eq("this is the value in test")

        config.load_configuration!("production")
        expect(config.i_must_be_here).to eq("this is the value in production")
      end

      it "merges in the common configuration from any file" do
        %w{test production}.each do |env|
          config.load_configuration!(env)
          expect(config.i_am_from_shared).to eq("a shared value")
        end
      end

      it "uses deep merges all hashes" do
        config.load_configuration!("production")
        expect(config.nested).to eq(
          "value_a" => "hello",
          "value_b" => "sup!"
        )
      end
    end
  end
end
