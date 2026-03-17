class WebhooksController < ApplicationController
  skip_before_action :authorize_request

  def skydropx
    raw_body = request.raw_post

    unless valid_signature?(raw_body)
      Rails.logger.warn("Invalid Skydropx webhook signature")
      return head :unauthorized
    end

    payload = JSON.parse(raw_body, symbolize_names: true)

    ProcessSkydropxWebhookJob.perform_later(payload)

    head :ok

  rescue JSON::ParserError => e
    Rails.logger.error("Invalid webhook payload: #{e.message}")
    head :bad_request

  rescue => e
    Rails.logger.error("Webhook error: #{e.message}")
    head :internal_server_error
  end

  private

  def valid_signature?(raw_body)
    signature = request.headers['X-Skydropx-Signature']
    secret = ENV['SKYDROPX_WEBHOOK_SECRET']

    return false if signature.blank? || secret.blank?

    expected_signature = OpenSSL::HMAC.hexdigest(
      'SHA256',
      secret,
      raw_body
    )

    ActiveSupport::SecurityUtils.secure_compare(expected_signature, signature)
  end
end
