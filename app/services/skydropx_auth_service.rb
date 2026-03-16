require "net/http"
require "json"

class SkydropxAuthService
  BASE_URL = ENV["SKYDROPX_BASE_URL"]

  def get_token
    uri = URI("#{BASE_URL}/oauth/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"

    # El JSON que mencionaste
    request.body = {
      client_id: ENV["SKYDROPX_CLIENT_ID"],
      client_secret: ENV["SKYDROPX_CLIENT_SECRET"],
      grant_type: "client_credentials",
      scope: "default orders.create"
    }.to_json

    response = http.request(request)

    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      Rails.logger.error("Token request failed: #{response.code} - #{response.body}")
      raise "Skydropx token request failed: #{response.code}"
    end
  end
end
