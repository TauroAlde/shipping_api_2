class StatsController < ApplicationController
  def carriers
    stats = ShipmentStat.all

    result = stats.map { |stat| build_response(stat) }

    render json: result.sort_by { |r| -r[:performance_score] }
  end

  private

  def build_response(stat)
    total = stat.deliveries.to_i + stat.failures.to_i

    success_rate =
      total.zero? ? 0 : stat.deliveries.to_f / total

    {
      carrier: stat.carrier,
      success_rate: success_rate.round(2),
      avg_days: stat.avg_days&.round(2),
      total_shipments: total,
      deliveries: stat.deliveries,
      failures: stat.failures,

      # 💣 NUEVO (clave para dashboard)
      performance_score: performance_score(success_rate, stat.avg_days),
      status: status_label(success_rate)
    }
  end

  def performance_score(success_rate, avg_days)
    speed = avg_days ? (1.0 / avg_days) : 0.5
    ((success_rate * 0.7) + (speed * 0.3)).round(2)
  end

  def status_label(success_rate)
    return "unknown" if success_rate.zero?

    if success_rate >= 0.95
      "excellent"
    elsif success_rate >= 0.85
      "good"
    elsif success_rate >= 0.7
      "warning"
    else
      "bad"
    end
  end
end
