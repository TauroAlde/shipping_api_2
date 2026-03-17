class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def skydropx
    payload = JSON.parse(request.body.read, symbolize_names: true)

    ProcessSkydropxWebhookJob.perform_later(payload)

    head :ok
  rescue JSON::ParserError => e
    Rails.logger.error("Invalid webhook payload: #{e.message}")
    head :bad_request
  end
end
