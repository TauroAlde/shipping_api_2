class SkydropxService

  BASE_URL = ENV["SKYDROPX_BASE_URL"]

  def initialize
    auth = SkydropxAuthService.new.get_token
    @token = auth["access_token"]
  end

  def create_quotation(data)
    uri = URI("#{BASE_URL}/api/v1/quotations")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@token}"
    request["Content-Type"] = "application/json"

    request.body = data.to_json

    response = http.request(request)

    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      Rails.logger.error("Skydropx API error: #{response.code} - #{response.body}")
      { error: "Skydropx API returned #{response.code}" }
    end
  end
end

