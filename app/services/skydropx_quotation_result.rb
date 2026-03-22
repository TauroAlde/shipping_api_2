class SkydropxQuotationResult
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def rates
    data[:rates] || []
  end

  def successful_rates
    rates.select { |r| r[:success] }
  end

  def formatted_rates
    successful_rates.map do |rate|
      {
        carrier: rate[:carrier]&.downcase,
        service: rate[:service],
        price: rate[:price],
        days: rate[:days],
        currency: rate[:currency],
        raw: rate
      }
    end
  end
end
