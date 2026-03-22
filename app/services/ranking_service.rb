class RankingService
  WEIGHTS = {
    price: 0.5,
    time: 0.3,
    reliability: 0.2
  }.freeze

  def initialize(results)
    @results = results
  end

  def call
    stats = preload_stats

    ranked = ActiveRecord::Base.transaction do
      @results.map do |result|
        stat = stats[result.carrier]

        reliability = carrier_reliability(stat)
        score = calculate_score(result, reliability)

        result.update!(score: score, reliability: reliability)

        build_response(result, score, reliability)
      end
    end

    ranked.sort_by { |r| r[:score] }
  end

  private

  def preload_stats
    ShipmentStat
      .where(carrier: @results.map(&:carrier))
      .index_by(&:carrier)
  end

  def calculate_score(result, reliability)
    (result.price.to_f * WEIGHTS[:price]) +
    (result.days.to_f * WEIGHTS[:time]) +
    ((1 - reliability) * 100 * WEIGHTS[:reliability])
  end

  def carrier_reliability(stat)
    return 0.9 unless stat

    total = stat.deliveries.to_i + stat.failures.to_i
    return 0.9 if total.zero?

    stat.deliveries.to_f / total
  end

  def build_response(result, score, reliability)
    {
      carrier: result.carrier,
      price: result.price,
      days: result.days,
      score: score.round(2),
      reliability: reliability.round(2)
    }
  end
end
