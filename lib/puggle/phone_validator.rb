require 'active_model'
require 'phony'

class Puggle::PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.respond_to?(:country_code)
      raise "Wrong use: Phone validator expects 'country_code' method"
    end
    return unless record.phone.present?
    unless record.country_code.present?
      record.errors.add(
        :country_code,
        "can't be blank when using phone validator",
      )
      return
    end
    if error = self.class.validate_phone(value, record.country_code)
      record.errors.add(attribute, error)
    end
  end

  def self.validate_phone(phone, country_code)
    if phone.nil?
      return "must be present"
    end
    case country_code
    when 'SE'
      valid_prefixes = ["4670", "4672", "4673", "4676", "4679"]
      case
      when !valid_prefixes.include?(phone[0..3])
        return "prefix is invalid"
      when phone.length != 11
        return "is not a valid mobile length"
      end
    when 'FI'
      valid_prefixes = ["3584", "3585"]
      case
      when !valid_prefixes.include?(phone[0..3])
        return "prefix is invalid"
      when phone.length > 15
        return "is not a valid mobile length"
      end
    else
      return "country code '#{country_code}' is not supported"
    end
  end
end
