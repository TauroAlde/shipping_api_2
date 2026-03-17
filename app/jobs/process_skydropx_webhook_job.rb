class ProcessSkydropxWebhookJob < ApplicationJob
  queue_as :default

  def perform(payload)
    shipment_id = payload.dig(:data, :attributes, :id)
    status = payload.dig(:data, :attributes, :tracking_status)

    shipment = Shipment.find_by(skydropx_id: shipment_id)
    return unless shipment

    shipment.update(tracking_status: status)

    ShipmentEvent.create!(
      shipment: shipment,
      status: status,
      metadata: payload
    )
  end
end
