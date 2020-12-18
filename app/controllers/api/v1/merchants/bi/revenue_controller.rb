class Api::V1::Merchants::Bi::RevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find_highest_revenue(params[:quantity]))
  end

  def show
    render json: RevenueSerializer.revenue(Merchant.single_revenue(params[:id]))
  end
end
