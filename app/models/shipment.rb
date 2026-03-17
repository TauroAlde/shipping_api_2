class Shipment < ApplicationRecord
  validates :skydropx_id, presence: true
  validates :tracking_number, presence: true
  validates :carrier, presence: true
end
