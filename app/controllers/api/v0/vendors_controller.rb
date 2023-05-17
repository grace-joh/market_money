class Api::V0::VendorsController < ApplicationController
  before_action :find_vendor, only: [:show]

  def show
    render json: VendorSerializer.new(@vendor)
  end

  private

  def find_vendor
    @vendor = Vendor.find(params[:id])
  end
end
