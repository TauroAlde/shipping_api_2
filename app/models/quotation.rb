# app/models/quotation.rb
class Quotation
  attr_accessor :address_from, :address_to, :parcels, :requested_carriers

  def initialize(address_from:, address_to:, parcels:, requested_carriers:)
    @address_from = address_from
    @address_to = address_to
    @parcels = parcels
    @requested_carriers = requested_carriers
  end

  def to_h
    {
      address_from: address_from,
      address_to: address_to,
      parcels: parcels,
      requested_carriers: requested_carriers
    }
  end
end
