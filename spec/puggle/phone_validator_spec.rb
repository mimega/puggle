require 'spec_helper'

describe Puggle::PhoneValidator do
  let(:model) {
    Class.new do
      include ActiveModel::Model
      attr_accessor :phone
      attr_accessor :country_code

      validates :phone, :'puggle/phone' => true

      def self.name
        "PhoneModel"
      end
    end
  }
  let(:phone) { "invalid" }
  let(:country_code) { "invalid" }
  let(:errors) {
    instance = model.new(country_code: country_code, phone: phone)
    instance.valid?
    instance.errors
  }

  context "given a model without country_code" do
    let(:model) {
      Class.new do
        include ActiveModel::Model
        attr_accessor :phone

        validates :phone, :'puggle/phone' => true
      end
    }
    it "raises" do
      expect {
        model.new.valid?
      }.to raise_exception(/Wrong use: Phone validator/)
    end
  end

  context "with no country code given" do
    let(:country_code) { nil }

    it "gives a cant be blank error" do
      expect(errors[:country_code]).to eq(["can't be blank when using phone validator"])
    end
  end

  context "with a country thats not supported" do
    let(:country_code) { "US" }

    it "gives a error" do
      expect(errors[:phone]).to eq(["country code 'US' is not supported"])
    end
  end

  context "with a nil number" do
    let(:phone) { nil }

    it "skips validation" do
      expect(errors[:phone]).to be_empty
    end
  end

  context "with valid swedish number" do
    let(:country_code) { "SE" }
    let(:phone) { "46735010101" }
    it "returns no errors" do
      expect(errors).to be_empty
    end
  end

  context "with valid finnish number" do
    let(:country_code) { "FI" }
    let(:phone) { "358401010101" }
    it "returns no errors" do
      expect(errors).to be_empty
    end
  end

  context "with valid german number" do
    let(:country_code) { "DE" }
    let(:phone) { "4915012345678" }
    it "returns no errors" do
      expect(errors).to be_empty
    end
  end

  context "with invalid phones" do
    [
      ["FI", "35840000000000000", "is not a valid mobile length"],
      ["SE", "41735165903", "prefix is invalid"],
      ["SE", "467351659032", "is not a valid mobile length"],
      ["FI", "358301010101", "prefix is invalid"],
      ["SE", "468501010101", "prefix is invalid"],
      ["SE", "358401010101", "prefix is invalid"],
      ["FI", "46735010101", "prefix is invalid"],
    ].each do |(country_code, phone, expected_error)|
      context "in country #{country_code} with phone #{phone}" do
        let(:country_code) { country_code }
        let(:phone) { phone }

        it "returns a error" do
          expect(errors[:phone]).to eq([expected_error])
        end
      end
    end
  end
end
