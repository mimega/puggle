module Puggle
  describe Config do
    describe ".load_configuration!" do
      it "creates methods on the config module specified in YAML files" do
        Puggle::Config.load_configuration!("test")
        expect(Puggle::Config.i_must_be_here).to eq("this is the value in test")

        Puggle::Config.load_configuration!("production")
        expect(Puggle::Config.i_must_be_here).to eq("this is the value in production")
      end
    end
  end
end
