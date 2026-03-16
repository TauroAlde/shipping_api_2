class QuotationsController < ApplicationController
  def create
    service = SkydropxService.new
    res = service.create_quotation(quotation_params)

    # si hubo error en el servicio
    if res.is_a?(Hash) && res[:error]
      render json: { error: res[:error] }, status: :unprocessable_entity
      return
    end

    quotation_id = res.data[:id]
    quotation = service.get_quotation(quotation_id)

    if quotation.is_a?(Hash) && quotation[:error]
      render json: { error: quotation[:error] }, status: :unprocessable_entity
    else
      puts quotation.successful_rates
      render json: quotation.successful_rates
    end
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
