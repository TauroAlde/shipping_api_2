class WebhooksController < ApplicationController
  skip_before_action :authorize_request

  def skydropx
    request_id = request.request_id
    raw_body = request.raw_post

    LoggerService.log(
      event: "webhook_received",
      data: { request_id: request_id }
    )

    unless valid_signature?(raw_body)
      LoggerService.error(
        event: "webhook_invalid_signature",
        error: "Invalid signature",
        data: { request_id: request_id }
      )
      return head :unauthorized
    end

    payload = JSON.parse(raw_body, symbolize_names: true)

    LoggerService.log(
      event: "webhook_payload_parsed",
      data: {
        request_id: request_id,
        tracking: payload.dig(:data, :attributes, :tracking_number),
        status: payload.dig(:data, :attributes, :tracking_status)
      }
    )

    ProcessSkydropxWebhookJob.perform_later(payload)

    head :ok

  rescue JSON::ParserError => e
    LoggerService.error(
      event: "webhook_invalid_json",
      error: e.message,
      data: {
        request_id: request_id,
        raw_body: raw_body&.slice(0, 500)
      }
    )
    head :bad_request

  rescue => e
    LoggerService.error(
      event: "webhook_failed",
      error: e.message,
      data: {
        request_id: request_id,
        backtrace: e.backtrace&.first(5)
      }
    )
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
