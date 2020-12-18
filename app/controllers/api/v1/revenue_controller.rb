class Api::V1::RevenueController < ApplicationController
  def index
    render json: RevenueSerializer.new(Merchant.all_revenue(params[:date]))
  end
end
