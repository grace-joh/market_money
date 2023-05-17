class Api::V0::MarketVendorsController < ApplicationController
  def create
    market_vendor = MarketVendor.new(market_vendor_params)
    begin
      market_vendor.save!
      render_success_response
    rescue ActiveRecord::RecordInvalid => error
      handle_error_response(error, market_vendor_params)
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end

  def render_success_response
    render json: { "message": 'Successfully added vendor to market' }, status: 201
  end

  def handle_error_response(error, params)
    if params.empty?
      render_invalid_response(error)
    elsif MarketVendor.find_by(params)
      render_association_exists_response(error)
    else
      render_not_found_response(error)
    end
  end

  def render_association_exists_response(error)
    render json: ErrorSerializer.serialize(error), status: 422
  end
end
