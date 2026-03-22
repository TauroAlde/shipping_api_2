class QuotationsController < ApplicationController
  def create
    service = SkydropxService.new
    res = service.create_quotation(quotation_params)

    if res.is_a?(Hash) && res[:error]
      return render json: { error: res[:error] }, status: :unprocessable_entity
    end

    quotation_id = res.data[:id] || res.data["id"]

    unless quotation_id
      return render json: { error: "Invalid quotation response" }, status: :unprocessable_entity
    end

    raw = service.get_quotation(quotation_id)

    if raw.is_a?(Hash) && raw[:error]
      return render json: { error: raw[:error] }, status: :unprocessable_entity
    end

    parsed = SkydropxQuotationResult.new(raw.data)

    quotation = Quotation.create!(
      requested_carriers: quotation_params[:requested_carriers] || []
    )

    results = parsed.formatted_rates.map do |rate|
      QuotationResult.create!(
        quotation: quotation,
        carrier: rate[:carrier],
        service: rate[:service],
        price: rate[:price],
        days: rate[:days],
        currency: rate[:currency],
        raw_response: rate[:raw]
      )
    end

    ranked = RankingService.new(results).call

    render json: {
      recommended: ranked.first,
      options: ranked
    }
  end

  private

  def quotation_params
    params.require(:quotation).permit(
      address_from: [
        :country_code,
        :postal_code,
        :area_level1,
        :area_level2,
        :area_level3
      ],
      address_to: [
        :country_code,
        :postal_code,
        :area_level1,
        :area_level2,
        :area_level3
      ],
      parcels: [
        :length,
        :width,
        :height,
        :weight,
        :package_protected,
        :declared_value,
        :declared_amount
      ],
      requested_carriers: []
    )
  end
end
