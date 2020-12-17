class Api::V1::Merchants::SearchController < ApplicationController
  def show
    render json: Merchant.find_single_merchant(search_params)
  end

  def index
    render json: Merchant.find_multiple_merchants(search_params)
  end

  def search_params
    params.permit(:name, :created_at, :updated_at)
  end
end
