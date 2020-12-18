class Api::V1::Merchants::Bi::RevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find_highest_revenue(params[:quantity]))
  end
end
