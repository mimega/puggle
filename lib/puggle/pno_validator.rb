require 'active_model'
require 'luhn'

class Puggle::PnoValidator < ActiveModel::Validator
  VALID_SWEDISH_PNO = /\A\d{8}-\d{4}\Z/
  VALID_FINNISH_PNO = /\A\d{6}[+\-A]\d{3}[0-9A-Y]\Z/

  def validate (record)
    return nil if record.errors[:country_code].present?
    return nil if record.errors[:pno].present?
    if ! self.class.valid_format?(record.country_code, record.pno)
      record.errors.add(:pno, :invalid)
    elsif ! self.class.valid_checksum?(record.country_code, record.pno)
      record.errors.add(:pno, :invalid)
    elsif ! self.class.reasonable_age?(record.country_code, record.pno)
      record.errors.add(:pno, :invalid)
    end
  end

  def self.valid?(country_code, pno)
    valid_format?(country_code, pno) &&
    valid_checksum?(country_code, pno)
  end

  def self.valid_checksum? (country_code, pno)
    case country_code
    when "SE" then valid_swedish_pno?(pno)
    when "FI" then valid_finnish_pno?(pno)
    else raise "Could not validate pno for country: #{country_code}"
    end
  end

  private

  def self.valid_format? (country_code, pno)
    case country_code
    when 'SE' then pno.match(VALID_SWEDISH_PNO).present?
    when 'FI' then pno.match(VALID_FINNISH_PNO).present?
    else raise "Could not validate pno format for country #{country_code}"
    end && valid_date?(country_code, pno)
  end

  def self.valid_date? (country_code, pno)
    date = extract_date(country_code, pno)
    if date =~ /\A(\d{4})-(\d{2})-(\d{2})\Z/
      year, month, day = $1.to_i, $2.to_i, $3.to_i
      Date.valid_date?(year, month, day)
    else
      false
    end
  end

  def self.reasonable_age? (country_code, pno, today: Date.today)
    date = Date.parse(extract_date(country_code, pno))
    date > today.prev_year(150) and date < today
  end

  def self.valid_swedish_pno? (pno)
    pno.present? && Luhn::CivicNumber.new(pno.dup).valid?
  end

  FINISH_CHECKSUM_SERIE = "0123456789ABCDEFHJKLMNPRSTUVWXY"
  def self.valid_finnish_pno? (pno)
    if pno.present? && pno.length == 11
      birth_date = pno[0..5]
      serie      = pno[7..9]

      n = (birth_date + serie).to_i % 31
      checksum = FINISH_CHECKSUM_SERIE[n]
      pno[-1] == checksum
    end
  end

  def self.extract_date (country_code, pno)
    case country_code
    when 'FI'
      cent = { '+' => '18', '-' => '19', 'A' => '20' }.fetch(pno[6])
      pno.sub(/^(\d{2})(\d{2})(\d{2}).*/, cent+'\3-\2-\1')
    when 'SE'
      pno.sub(/^(\d{4})(\d{2})(\d{2})-\d{4}$/, '\1-\2-\3')
    else raise "Count extract date from pno for country #{country_code}"
    end
  end
end
