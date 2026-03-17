class Shipment < ApplicationRecord
  validates :skydropx_id, presence: true
  validates :tracking_number, presence: true
  validates :carrier, presence: true

  STATUS_ORDER = {
    "pending" => 0,
    "confirmed" => 1,
    "in_transit" => 2,
    "out_for_delivery" => 3,
    "delivered" => 4,
    "exception" => 5,
    "cancelled" => 6
  }.freeze

  FINAL_STATUSES = %w[delivered cancelled].freeze

  def should_update_status?(new_status)
    return false if final_status?
    return true if tracking_status.blank?

    STATUS_ORDER[new_status].to_i >= STATUS_ORDER[tracking_status].to_i
  end

  def update_status!(new_status)
    return unless should_update_status?(new_status)

    update!(tracking_status: new_status)
  end

  def final_status?
    FINAL_STATUSES.include?(tracking_status)
  end
end
