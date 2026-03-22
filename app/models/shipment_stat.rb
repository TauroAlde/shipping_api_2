class ShipmentStat < ApplicationRecord
  def success_rate
    return 1.0 if deliveries.to_i + failures.to_i == 0

    deliveries.to_f / (deliveries + failures)
  end
end
