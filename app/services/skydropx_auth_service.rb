# app/services/skydropx_auth_service.rb
require "net/http"
require "uri"
require "json"

class SkydropxAuthService
  BASE_URL = ENV["SKYDROPX_BASE_URL"]

  def get_token
    uri = URI("#{BASE_URL}/api/v1/oauth/token")
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = {
      client_id: ENV["SKYDROPX_CLIENT_ID"],
      client_secret: ENV["SKYDROPX_CLIENT_SECRET"],
      grant_type: "client_credentials",
      scope: "default orders.create"
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(request)

    if response.code.to_i == 200
      JSON.parse(response.body, symbolize_names: true)
    else
      Rails.logger.error("Skydropx Auth error: #{response.code} - #{response.body}")
      { error: "Skydropx Auth failed" }
    end
  end
end
