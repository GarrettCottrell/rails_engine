class Api::V1::Merchants::SearchController < ApplicationController
  def show
    render json: Merchant.find_single_merchant(search_params)
  end

  def search_params
    params.permit(:name, :created_at)
  end
end
