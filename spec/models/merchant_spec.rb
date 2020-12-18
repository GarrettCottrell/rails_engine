require 'rails_helper'

describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:transactions).through :invoices }
    it { should have_many(:invoice_items).through :invoices }
  end

  describe 'class methods' do
    it 'find_single_merchant by name' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      params = {name: 'Ga'}
      expect(Merchant.find_single_merchant(params)).to eq(merchant)
    end

    it 'find_single_merchant by created at' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      params = { created_at: 'Fri, 18 Dec 2020 00:06:48 UTC +00:00' }
      expect(Merchant.find_single_merchant(params)).to eq(merchant)
    end

    it 'find_single_merchant by updated at' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      params = { updated_at: 'Fri, 18 Dec 2020 00:06:48 UTC +00:00' }
      expect(Merchant.find_single_merchant(params)).to eq(merchant)
    end

    it 'find_multiple_merchants by name search' do 
      merchant1 = Merchant.create!(name: 'GarrettMerchant1')
      merchant2 = Merchant.create(name: 'GarrettMerchant2')
      merchant3 = Merchant.create(name: 'GarrettMerchant3')
      params = {name: 'Mer'}
      expect(Merchant.find_multiple_merchants(params)).to eq([merchant1, merchant2, merchant3])
    end

    it 'find_multiple_merchants by created_at search' do 
      merchant1 = Merchant.create!(name: 'GarrettMerchant1')
      merchant2 = Merchant.create(name: 'GarrettMerchant2')
      merchant3 = Merchant.create(name: 'GarrettMerchant3')
      params = {created_at: 'Fri, 18 Dec 2020 00:06:48 UTC +00:00'}
      expect(Merchant.find_multiple_merchants(params)).to eq([merchant1, merchant2, merchant3])
    end

    it 'find_multiple_merchants by updated_at search' do 
      merchant1 = Merchant.create!(name: 'GarrettMerchant1')
      merchant2 = Merchant.create(name: 'GarrettMerchant2')
      merchant3 = Merchant.create(name: 'GarrettMerchant3')
      params = {updated_at: 'Fri, 18 Dec 2020 00:06:48 UTC +00:00'}
      expect(Merchant.find_multiple_merchants(params)).to eq([merchant1, merchant2, merchant3])
    end

    it 'find_highest_revenue_merchant' do 
      customer1 = create(:customer)
      customer2 = create(:customer)

      merchant1 = Merchant.create(name: 'TestMerchant1')
      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      invoice1 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant1.id)
      invoiceitems1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 15.00)
      transaction1 = create(:transaction, invoice_id: invoice1.id, result: 'success')
      invoice2 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant1.id)
      invoiceitems2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 15.00)
      transaction2 = create(:transaction, invoice_id: invoice2.id, result: 'success')

      merchant2 = Merchant.create(name: 'TestMerchant2')
      item3 = create(:item, merchant_id: merchant2.id)
      item4 = create(:item, merchant_id: merchant2.id)
      invoice3 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant2.id)
      invoiceitems3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id, quantity: 3, unit_price: 20.00)
      transaction3 = create(:transaction, invoice_id: invoice3.id, result: 'success')
      invoice4 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant2.id)
      invoiceitems4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id, quantity: 4, unit_price: 20.00)
      transaction4 = create(:transaction, invoice_id: invoice4.id, result: 'success')

      merchant3 = Merchant.create(name: 'TestMerchant3')
      item5 = create(:item, merchant_id: merchant3.id)
      item6 = create(:item, merchant_id: merchant3.id)
      invoice5 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant3.id)
      invoiceitems5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice5.id, quantity: 5, unit_price: 10.00)
      transaction5 = create(:transaction, invoice_id: invoice5.id, result: 'success')
      invoice6 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant3.id)
      invoiceitems6 = create(:invoice_item, item_id: item6.id, invoice_id: invoice6.id, quantity: 6, unit_price: 10.00)
      transaction6 = create(:transaction, invoice_id: invoice6.id, result: 'success')

      expect(Merchant.find_highest_revenue(2).length).to eq(2)
      expect(Merchant.find_highest_revenue(2)).to eq([merchant2, merchant3])
    end

    it 'most_items' do 
      customer1 = create(:customer)
      customer2 = create(:customer)

      merchant1 = Merchant.create(name: 'TestMerchant1')
      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      invoice1 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant1.id)
      invoiceitems1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 15.00)
      transaction1 = create(:transaction, invoice_id: invoice1.id, result: 'success')
      invoice2 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant1.id)
      invoiceitems2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 15.00)
      transaction2 = create(:transaction, invoice_id: invoice2.id, result: 'success')

      merchant2 = Merchant.create(name: 'TestMerchant2')
      item3 = create(:item, merchant_id: merchant2.id)
      item4 = create(:item, merchant_id: merchant2.id)
      invoice3 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant2.id)
      invoiceitems3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id, quantity: 3, unit_price: 20.00)
      transaction3 = create(:transaction, invoice_id: invoice3.id, result: 'success')
      invoice4 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant2.id)
      invoiceitems4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id, quantity: 4, unit_price: 20.00)
      transaction4 = create(:transaction, invoice_id: invoice4.id, result: 'success')

      merchant3 = Merchant.create(name: 'TestMerchant3')
      item5 = create(:item, merchant_id: merchant3.id)
      item6 = create(:item, merchant_id: merchant3.id)
      invoice5 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant3.id)
      invoiceitems5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice5.id, quantity: 5, unit_price: 10.00)
      transaction5 = create(:transaction, invoice_id: invoice5.id, result: 'success')
      invoice6 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant3.id)
      invoiceitems6 = create(:invoice_item, item_id: item6.id, invoice_id: invoice6.id, quantity: 6, unit_price: 10.00)
      transaction6 = create(:transaction, invoice_id: invoice6.id, result: 'success')

      expect(Merchant.most_items(2).length).to eq(2)
      expect(Merchant.most_items(2)).to eq([merchant3, merchant2])
    end

    it 'single_revenue' do 
      customer1 = create(:customer)
      customer2 = create(:customer)

      merchant1 = Merchant.create(name: 'TestMerchant1')
      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      invoice1 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant1.id)
      invoiceitems1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 15.00)
      transaction1 = create(:transaction, invoice_id: invoice1.id, result: 'success')
      invoice2 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant1.id)
      invoiceitems2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 15.00)
      transaction2 = create(:transaction, invoice_id: invoice2.id, result: 'success')

      merchant2 = Merchant.create(name: 'TestMerchant2')
      item3 = create(:item, merchant_id: merchant2.id)
      item4 = create(:item, merchant_id: merchant2.id)
      invoice3 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant2.id)
      invoiceitems3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id, quantity: 3, unit_price: 20.00)
      transaction3 = create(:transaction, invoice_id: invoice3.id, result: 'success')
      invoice4 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant2.id)
      invoiceitems4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id, quantity: 4, unit_price: 20.00)
      transaction4 = create(:transaction, invoice_id: invoice4.id, result: 'success')

      merchant3 = Merchant.create(name: 'TestMerchant3')
      item5 = create(:item, merchant_id: merchant3.id)
      item6 = create(:item, merchant_id: merchant3.id)
      invoice5 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant3.id)
      invoiceitems5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice5.id, quantity: 5, unit_price: 10.00)
      transaction5 = create(:transaction, invoice_id: invoice5.id, result: 'success')
      invoice6 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant3.id)
      invoiceitems6 = create(:invoice_item, item_id: item6.id, invoice_id: invoice6.id, quantity: 6, unit_price: 10.00)
      transaction6 = create(:transaction, invoice_id: invoice6.id, result: 'success')

      expect(Merchant.single_revenue(merchant2.id)).to eq(140.0)
    end
  end
end
