module Puggle
  module ScrubInputs
    def scrub_params(hash)
      hash.inject({}) do |h, (key, value)|
        h.merge(
          key => case value
                 when Hash then scrub_params(value)
                 when Array then scrup_array(value)
                 else
                   scrub_value(value)
                 end
        )
      end
    end

    private

    def scrup_array (array)
      array.map do |value|
        value.is_a?(Hash) ? scrub_params(value) : scrub_value_or_array(value)
      end
    end

    def scrub_value_or_array (value)
      if value.is_a?(Array)
        scrub_array(value)
      else
        scrub_value(value)
      end
    end

    def scrub_value (value)
      if value.is_a?(String)
        stripped = value.strip
        stripped.blank? ? nil : stripped
      else
        value
      end
    end
  end
end
