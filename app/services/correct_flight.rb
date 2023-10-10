# frozen_string_literal: true

class Service::CorrectFlight

  def self.correct_flight_number(flight_number)
    flight_number = flight_number.to_s
    first_part = ''
    if flight_number.size == 7
      first_part = flight_number[0...3]

      unless correct_carrier_icao_code(first_part)
        return nil
      end

    elsif flight_number.size < 7
      first_part = flight_number[0...2]


      unless correct_carrier_iata_code(first_part)
        return nil
      end

    else
      throw Exception.new "Invalid flight number"
    end

    postfix = flight_number[first_part.length...]

    first_part.concat(postfix.concat('0' * (4 - postfix.size)))
  end

  def self.correct_carrier_iata_code(code)
    if code.size != 2
      raise Exception.new 'Invalid iata code'
    end

    if code =~ /[\dA-Z]{2}/
      return true
    end

    false
  end

  def self.correct_carrier_icao_code(code)
    if code.size != 3
      raise Exception.new 'Invalid icao code'
    end

    if code =~ /[\dA-Z]{3}/
      return true
    end

    false
  end
end
