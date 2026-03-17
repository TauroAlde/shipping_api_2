class ShipmentsController < ApplicationController
  def create
    unless shipment_params[:rate_id]
      render json: { error: "rate_id is required" }, status: :unprocessable_entity
      return
    end
    
    service = SkydropxService.new

    result = service.create_shipment(shipment_params)

    if result.is_a?(Hash) && result[:error]
      render json: result, status: :unprocessable_entity
      return
    end

    data = result.data[:attributes]

    shipment = Shipment.create!(
      skydropx_id: data[:id],
      carrier: data[:carrier_name],
      workflow_status: data[:workflow_status],
      payment_status: data[:payment_status],
      total: data[:total],
      tracking_number: data[:master_tracking_number],
      metadata: result.data
    )

    render json: shipment
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

  def index
    render json: Shipment.all
  end

  def show
    shipment = Shipment.find(params[:id])
    render json: shipment
  end

  def label
    shipment = Shipment.find(params[:id])

    redirect_to shipment.label_url
  end

  def tracking
    shipment = Shipment.find(params[:id])

    render json: {
      carrier: shipment.carrier,
      tracking_number: shipment.tracking_number,
      status: shipment.tracking_status
    }
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
