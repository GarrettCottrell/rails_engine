class Api::V1::Items::SearchController < ApplicationController
  def show
    render json: Item.find_single_item(search_params)
  end

  def search_params
    params.permit(:name, :created_at, :description, :unit_price, :updated_at)
  end
end
