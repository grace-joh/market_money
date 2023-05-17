class Api::V0::VendorsController < ApplicationController
  before_action :find_vendor, only: [:show]

  def show
    render json: VendorSerializer.new(@vendor)
  end

  def create
    @vendor = Vendor.create!(vendor_params)
    render json: VendorSerializer.new(@vendor), status: :created
  end

  private

  def find_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
