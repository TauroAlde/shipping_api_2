class QuotationsController < ApplicationController

  def create
    response = SkydropxService.new.create_quotation(quotation_params)
    render json: response
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
