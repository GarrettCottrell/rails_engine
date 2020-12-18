class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices


  validates_presence_of :name,
                        :description,
                        :unit_price

  def self.find_single_item(params)
    if params[:name]
      where('lower(name) like ?', "%#{params[:name]}%".downcase)[0]
    elsif params[:description]
      where('description like ?', "%#{params[:description]}%")[0]
    #elsif params[:unit_price]
      #where('unit_price ?' "%#{params[:unit_price].to_f}%")[0]
    elsif params[:created_at]
      date = Date.parse(params[:created_at])
      Item.where(created_at: date.beginning_of_day..date.end_of_day)[0]
    elsif params[:updated_at]
      date = Date.parse(params[:updated_at])
      Item.where(updated_at: date.beginning_of_day..date.end_of_day)[0]
    end
  end

  def self.find_multiple_items(params)
    if params[:name]
      where('lower(name) like ?', "%#{params[:name]}%".downcase)
    elsif params[:description]
      where('description like ?', "%#{params[:description]}%")
    #elsif params[:unit_price]
      #where('unit_price like ?', "%#{params[:unit_price]}%")
    elsif params[:created_at]
      date = Date.parse(params[:created_at])
      Item.where(created_at: date.beginning_of_day..date.end_of_day)
    elsif params[:updated_at]
      date = Date.parse(params[:updated_at])
      Item.where(updated_at: date.beginning_of_day..date.end_of_day)
    end
  end
end
