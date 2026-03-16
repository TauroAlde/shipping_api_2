class QuotationsController < ApplicationController
  def create
    service = SkydropxService.new
    res = service.create_quotation(quotation_params)

    if res[:error]
      render json: { error: res[:error] }, status: :unprocessable_entity
      return
    end

    quotation_id = res[:id]
    final = service.get_final_quotation(quotation_id)

    if final[:error]
      render json: { error: final[:error] }, status: :unprocessable_entity
    else
      render json: final # aquí están los rates, carriers, etc.
    end
  end

  private

  def quotation_params
    params.require(:quotation).permit(
      address_from: [:country_code, :postal_code, :area_level1, :area_level2, :area_level3],
      address_to: [:country_code, :postal_code, :area_level1, :area_level2, :area_level3],
      parcels: [:length, :width, :height, :weight, :package_protected, :declared_value, :declared_amount],
      requested_carriers: []
    )
  end

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
