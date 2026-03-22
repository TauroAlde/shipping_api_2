class LoggerService
  def self.log(event:, data: {})
    Rails.logger.info({
      service: "shipping_api",
      event: event,
      timestamp: Time.current,
      data: data
    }.to_json)
  end

  def self.error(event:, error:, data: {})
    Rails.logger.error({
      service: "shipping_api",
      event: event,
      error: error,
      timestamp: Time.current,
      data: data
    }.to_json)
  end
end
