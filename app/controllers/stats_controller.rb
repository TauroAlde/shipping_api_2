class StatsController < ApplicationController
  def carriers
    stats = ShipmentStat.all

    render json: stats.map { |stat| build_response(stat) }
  end

  private

  def build_response(stat)
    total = stat.deliveries.to_i + stat.failures.to_i

    success_rate =
      if total.zero?
        0
      else
        (stat.deliveries.to_f / total).round(2)
      end

    {
      carrier: stat.carrier,
      success_rate: success_rate,
      avg_days: stat.avg_days&.round(2),
      total_shipments: total,
      deliveries: stat.deliveries,
      failures: stat.failures
    }
  end
end
