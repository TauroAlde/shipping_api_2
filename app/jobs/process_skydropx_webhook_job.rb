class ProcessSkydropxWebhookJob < ApplicationJob
  queue_as :default

  def perform(payload)
    external_id = payload.dig(:data, :id)

    shipment_id = payload.dig(:data, :attributes, :id)
    status      = payload.dig(:data, :attributes, :tracking_status)
    carrier     = payload.dig(:data, :attributes, :carrier)&.downcase

    event = ShipmentEvent.find_or_create_by!(external_id: external_id) do |e|
      e.shipment = shipment
      e.status = status
      e.carrier = carrier || shipment.carrier
      e.metadata = payload
    end

    return if event.persisted? && event.created_at != event.updated_at

    ShipmentEvent.create!(
      external_id: external_id,
      shipment: shipment,
      status: status,
      carrier: carrier || shipment.carrier,
      metadata: payload
    )

    shipment.update_status!(status)

    update_stats(shipment, status)

  rescue ActiveRecord::RecordNotUnique
    Rails.logger.info("Duplicate webhook ignored: #{external_id}")
  end

  private

  def update_stats(shipment, status)
    stat = ShipmentStat.find_or_create_by(carrier: shipment.carrier)

    case status
    when "delivered"
      stat.increment!(:deliveries)
      update_delivery_time(stat, shipment)

    when "failed", "returned", "cancelled"
      stat.increment!(:failures)
    end
  end

  def update_delivery_time(stat, shipment)
    return unless shipment.created_at

    days = (Time.current - shipment.created_at) / 1.day

    avg =
      if stat.avg_days.nil?
        days
      else
        (stat.avg_days + days) / 2.0
      end

    stat.update!(avg_days: avg)
  end
end
