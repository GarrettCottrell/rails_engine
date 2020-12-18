class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  validates_presence_of :name

  def self.find_single_merchant(params)
    if params[:name]
      where('lower(name) like ?', "%#{params[:name]}%".downcase)[0]
    elsif params[:created_at]
      date = Date.parse(params[:created_at])
      Merchant.where(created_at: date.beginning_of_day..date.end_of_day)[0]
    elsif params[:updated_at]
      date = Date.parse(params[:updated_at])
      Merchant.where(updated_at: date.beginning_of_day..date.end_of_day)[0]
    end
  end

  def self.find_multiple_merchants(params)
    if params[:name]
      where('lower(name) like ?', "%#{params[:name]}%".downcase)
    elsif params[:created_at]
      date = Date.parse(params[:created_at])
      Merchant.where(created_at: date.beginning_of_day..date.end_of_day)
    elsif params[:updated_at]
      date = Date.parse(params[:updated_at])
      Merchant.where(updated_at: date.beginning_of_day..date.end_of_day)
    end
  end

  def self.find_highest_revenue(limit_params)
    Merchant.select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue').joins(invoices: [:invoice_items, :transactions]).where('transactions.result = ?', 'success').where('invoices.status = ?', 'shipped').group("id").order("revenue DESC").limit(limit_params)
  end

  def self.most_items(limit_params)
    Merchant.select('merchants.*, SUM(invoice_items.quantity) AS items_sold').joins(invoices: [:invoice_items, :transactions]).where('transactions.result = ?', 'success').where('invoices.status = ?', 'shipped').group("id").order("items_sold DESC").limit(limit_params)
  end

  def self.single_revenue(id_params)
    Merchant.joins(invoices: [:invoice_items, :transactions]).where('transactions.result = ?', 'success').where('invoices.status = ?', 'shipped').where('merchants.id = ?', id_params).sum('(invoice_items.quantity * invoice_items.unit_price)')
  end
end
