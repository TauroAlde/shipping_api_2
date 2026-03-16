class ProcessSkydropxWebhookJob < ApplicationJob
  queue_as :default

  def perform(payload)
    shipment = Shipment.find_by(skydropx_id: payload[:shipment_id])

    return unless shipment

    shipment.update(
      tracking_status: payload[:tracking_status],
      workflow_status: payload[:workflow_status],
      metadata: payload
    )
  end
end
