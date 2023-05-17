class Api::V0::Markets::VendorsController < ApplicationController
  before_action :find_market, only: [:index]

  def index
    render json: VendorSerializer.new(Vendor.all)
  end

  private

  def find_market
    @market = Market.find(params[:market_id])
  end
end
