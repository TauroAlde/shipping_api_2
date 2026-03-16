class ShipmentsController < ApplicationController
  def create
    service = SkydropxService.new

    shipment = service.create_shipment(shipment_params)

    if shipment.is_a?(Hash) && shipment[:error]
      render json: shipment, status: :unprocessable_entity
      return
    end

    render json: shipment.data
  end

  def show
    service = SkydropxService.new

    shipment = service.get_shipment(params[:id])

    if shipment.is_a?(Hash) && shipment[:error]
      render json: shipment, status: :unprocessable_entity
      return
    end

    render json: shipment.data
  end

  private

  def shipment_params
    params.require(:shipment).permit(
      :rate_id,
      :printing_format,
      address_from: [
        :street1,
        :name,
        :company,
        :phone,
        :email,
        :reference
      ],
      address_to: [
        :street1,
        :name,
        :company,
        :phone,
        :email,
        :reference
      ],
      packages: [
        :package_number,
        :package_protected,
        :declared_value,
        :declared_amount,
        :consignment_note,
        :package_type,
        products: [
          :product_id,
          :name,
          :description_en,
          :quantity,
          :price,
          :sku,
          :hs_code,
          :hs_code_description,
          :product_type_code,
          :product_type_name,
          :country_code
        ]
      ]
    )
  end
end
