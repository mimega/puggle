require 'spec_helper'

class Scruber
  include Puggle::ScrubInputs
end

module Puggle
  describe ScrubInputs do
    let(:scruber) { Scruber.new }

    context "when input contains arrays" do
      let(:params) do
        { post:
          {
            title: "  ",
            comments:
            [
              "       ",
              " ",
              "     I am a value          ",
              {
                key: "   "
              }
            ]
          }
        }
      end

      it "scrubs all string values" do
        expected =
          { post:
            {
              title: nil,
              comments:
              [
                nil,
                nil,
                "I am a value",
              {
                key: nil
              }
              ]
            }
          }

        scruber.scrub_params(params).should eq(expected)
      end
    end

    context "when input contains hashes" do
      let(:params) do
        {
          post:
          {
            title: "",
            body: " i am a cool body    ",
            author:
            {
              name: nil,
              age: "29 "
            }
          }
        }
      end

      it "scrubs all string values" do
        expected =
          {
            post:
            {
              title: nil,
              body: "i am a cool body",
              author:
              {
                name: nil,
                age: "29"
              }
            }
          }
        scruber.scrub_params(params).should eq(expected)
      end
    end
  end
end
