require 'active_model'

class Puggle::PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.respond_to?(:country_code)
      raise "Wrong use: Phone validator expects 'country_code' method"
    end
    unless record.country_code.present?
      record.errors.add(
        :country_code,
        "can't be blank when using phone validator",
      )
      return
    end
    errors = self.class.validate_phone(value, record.country_code)
    errors.each { |error|
      record.errors.add(attribute, error)
    }
  end

  def self.valid_phone? (value, country_code)
    validate_phone(value, country_code).empty?
  end

  def self.validate_phone(phone, country_code)
    errors = []
    phone_prefix = {
      'SE' => '46',
      'FI' => '358',
    }.fetch(country_code) {
      raise "Unknown country code '#{country_code}'"
    }
    unless Phony.plausible?(phone, cc: phone_prefix)
      errors << "is not in international format"
      return errors
    end

    errors << "is not normalized" unless Phony.normalize(phone) == phone

    unless phone.start_with?(phone_prefix)
      errors << "does not start with country phone prefix"
    end
    errors
  end
end
