require 'spec_helper'

module Puggle
  describe PnoValidator do
    describe ".valid?" do
      it "works" do
        [
          ['FI', "180265-019L"],
          ['FI', "311280-999J"],
          ['SE', "19871009-4650"],
          ['SE', "20010102-3489"]
        ].each do |country_code, pno|
          expect(PnoValidator).to be_valid_format(country_code, pno)
          expect(PnoValidator).to be_valid_checksum(country_code, pno)
        end
        [
          ['FI', "423543-6424"],
          ['FI', "180265-019%"],
          ['FI', "250257.042H"],
          ['FI', "311280*999J"],
          ['SE', "19w71009-4650"],
          ['SE', "20010102<3482"],
          ['SE', "010102-3482"],
          ['SE', "\n19871009-4650\n"],
          ['SE', "200101023482"]
        ].each do |country_code, pno|
          expect(PnoValidator).to_not be_valid_format(country_code, pno)
        end
      end
    end

    describe ".valid_finnish_pno?" do
      it "validates finnish checksum" do
        ["180265-019L",
          "311280-999J"].each do |pno|
          expect(PnoValidator).to be_valid_finnish_pno(pno)
        end

        ["180265-019J",
          "311280-999S",
          "250257.042H"].each do |pno|
          expect(PnoValidator).to_not be_valid_finnish_pno(pno)
        end
      end
    end

    describe ".extract_date" do
      it "works" do
        expect(PnoValidator.extract_date('FI', "180265-019L")).to eq("1965-02-18")
        expect(PnoValidator.extract_date('FI', "311280-999J")).to eq("1980-12-31")
        expect(PnoValidator.extract_date('SE', "19871009-4650")).to eq("1987-10-09")
        expect(PnoValidator.extract_date('SE', "20010102-3482")).to eq("2001-01-02")
      end
    end
  end
end
