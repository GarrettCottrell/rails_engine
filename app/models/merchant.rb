class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  validates_presence_of :name

  def self.find_single_merchant(params)
    if params[:name]
      where('name like ?', "%#{params[:name]}%")[0]
    elsif params[:created_at]
      date = Date.parse(params[:created_at])
      Merchant.where(created_at: date.beginning_of_day..date.end_of_day)[0]
    end
  end
end
