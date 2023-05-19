class Api::V0::Markets::NearestAtmsController < ApplicationController
  def index
    market = Market.find(market_params[:market_id])
    atms = AtmFacade.new.find_nearby_atms(market.lat, market.lon)
    render json: AtmSerializer.new(atms)
  end

  private

  def market_params
    params.permit(:market_id)
  end
end
