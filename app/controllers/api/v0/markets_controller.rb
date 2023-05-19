class Api::V0::MarketsController < ApplicationController
  before_action :find_market, only: [:show]

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(@market)
  end

  def search
    if (params[:state].nil? && params[:city].present?) || search_params.empty?
      render_invalid_search_response
    else
      render json: MarketSerializer.new(Market.search_all(search_params))
    end
  end

  private

  def find_market
    @market = Market.find(params[:id])
  end

  def search_params
    params.permit(:state, :city, :name)
  end

  def render_invalid_search_response
    message = "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
    render json: ErrorSerializer.serialize(message), status: 422
  end
end
