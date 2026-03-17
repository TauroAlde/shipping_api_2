class ProcessSkydropxWebhookJob < ApplicationJob
  queue_as :default

  def perform(payload)
    external_id = payload.dig(:data, :id)

    shipment_id = payload.dig(:data, :attributes, :id)
    status      = payload.dig(:data, :attributes, :tracking_status)
    carrier     = payload.dig(:data, :attributes, :carrier)&.downcase

    shipment = Shipment.find_by(skydropx_id: shipment_id)
    return unless shipment

    ShipmentEvent.create!(
      external_id: external_id,
      shipment: shipment,
      status: status,
      carrier: carrier || shipment.carrier,
      metadata: payload
    )

    shipment.update_status!(status)

  rescue ActiveRecord::RecordNotUnique
    Rails.logger.info("Duplicate webhook ignored: #{external_id}")
  end
end
