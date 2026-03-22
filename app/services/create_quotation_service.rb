class CreateQuotationService
  def initialize(params)
    @params = params
    @skydropx = SkydropxService.new
  end

  def call
    key = "quotation:#{cache_key}"

    cached = Rails.cache.read(key)
    return cached if cached

    result = process_quotation

    Rails.cache.write(key, result, expires_in: 30.minutes) unless result[:error]

    result
  end

  def process_quotation
    res = @skydropx.create_quotation(@params)
    return error(res[:error]) if error_response?(res)

    quotation_id = res.data[:id]
    raw = @skydropx.get_quotation(quotation_id)
    return error(raw[:error]) if error_response?(raw)

    parsed = SkydropxQuotationResult.new(raw.data)

    quotation = Quotation.create!

    results = persist_results(parsed, quotation)

    ranked = RankingService.new(results).call

    success_response(ranked)
  end

  private

  def persist_results(parsed, quotation)
    parsed.formatted_rates.map do |rate|
      QuotationResult.create!(
        quotation: quotation,
        carrier: rate[:carrier],
        service: rate[:service],
        price: rate[:price],
        days: rate[:days],
        currency: rate[:currency],
        raw_response: rate[:raw]
      )
    end
  end

  def success_response(ranked)
    {
      recommended: ranked.first,
      options: ranked
    }
  end

  def error(message)
    { error: message }
  end

  def error_response?(res)
    res.is_a?(Hash) && res[:error]
  end
end
