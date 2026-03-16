require "net/http"
require "uri"
require "json"

class SkydropxService
  BASE_URL = ENV["SKYDROPX_BASE_URL"]

  def initialize(auth_service: SkydropxAuthService.new)
    @token = auth_service.get_token[:access_token]
  end

  def create_quotation(quotation)
    payload = quotation.respond_to?(:to_h) ? quotation.to_h : quotation

    response = post("/quotations", payload)
    return response if response[:error]

    QuotationResult.new(response)
  end

  def get_quotation(quotation_id)
    response = get("/quotations/#{quotation_id}")
    return response if response[:error]

    QuotationResult.new(response)
  end

  private

  def post(path, body)
    request(:post, path, body)
  end

  def get(path)
    request(:get, path)
  end

  def request(method, path, body = nil)
    uri = URI("#{BASE_URL}/api/v1#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = case method
              when :post then Net::HTTP::Post.new(uri)
              when :get  then Net::HTTP::Get.new(uri)
              end

    request["Authorization"] = "Bearer #{@token}"
    request["Content-Type"] = "application/json"
    request.body = body.to_json if body
binding.pry
    response = http.request(request)
    parse_response(response)
  end

  def parse_response(response)
    case response.code.to_i
    when 200, 201
      JSON.parse(response.body, symbolize_names: true)
    else
      { error: "Skydropx API returned #{response.code}" }
    end
  end
end
