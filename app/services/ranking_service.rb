class RankingService
  def initialize(quotation_results)
    @results = quotation_results
  end

  def call
    @results.map do |result|
      score = calculate_score(result)

      {
        carrier: result.carrier,
        price: result.price,
        days: result.days,
        score: score
      }
    end.sort_by { |r| r[:score] }
  end

  private

  def calculate_score(result)
    price_weight = 0.5
    time_weight  = 0.3
    reliability_weight = 0.2

    reliability = carrier_reliability(result.carrier)

    (result.price * price_weight) +
    (result.days * time_weight) +
    ((1 - reliability) * 100 * reliability_weight)
  end

  def carrier_reliability(carrier)
    stat = ShipmentStat.find_by(carrier: carrier)

    return 0.9 unless stat # default

    stat.success_rate
  end
end
