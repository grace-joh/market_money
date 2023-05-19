class Api::V0::MarketVendorsController < ApplicationController
  def create
    MarketVendor.create!(market_vendor_params)
    render_success_response
  rescue ActiveRecord::RecordInvalid => error
    handle_error_response(error, market_vendor_params)
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_vendor_params)
    if !market_vendor.nil?
      market_vendor.destroy
    else
      render_no_market_vendor_response(market_vendor_params)
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

  def render_no_market_vendor_response(params)
    message = "No MarketVendor with market_id=#{params[:market_id]} AND vendor_id=#{params[:vendor_id]} exists"
    render json: ErrorSerializer.serialize(message), status: 404
  end
end
