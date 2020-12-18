require 'rails_helper'

describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through :invoice_items }
    it { should have_many(:transactions).through :invoices }
  end

  describe 'class methods' do
    it 'find_single_item by name' do
      merchant = create(:merchant)
      item = Item.create!(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )
      params = {name: 'Ga'}
      expect(Item.find_single_item(params)).to eq(item)
    end

    it 'find_single_item by description' do
      merchant = create(:merchant)
      item = Item.create!(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )
      params = {description: 'item'}
      expect(Item.find_single_item(params)).to eq(item)
    end

    xit 'find_single_item by unit_price' do
      merchant = create(:merchant)
      item = Item.create!(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )
      params = {unit_price: '4'}
      expect(Item.find_single_item(params)).to eq(item)
    end

    it 'find_single_item by created_at' do
      merchant = create(:merchant)
      item = Item.create!(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )
      params = {created_at: 'Fri, 18 Dec 2020 00:06:48 UTC +00:00' }
      expect(Item.find_single_item(params)).to eq(item)
    end

    it 'find_single_item by updated_at' do
      merchant = create(:merchant)
      item = Item.create!(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )
      params = {updated_at: 'Fri, 18 Dec 2020 00:06:48 UTC +00:00' }
      expect(Item.find_single_item(params)).to eq(item)
    end

    it 'find_all_items by name search' do
      merchant = create(:merchant)
      item1 = Item.create!(name: 'GarrettMerchant1', description: 'Test item description1', unit_price: 4.2, merchant_id: merchant.id )
      item2 = Item.create!(name: 'GarrettMerchant2', description: 'Test item description2', unit_price: 4.3, merchant_id: merchant.id )
      item3 = Item.create!(name: 'GarrettMerchant3', description: 'Test item description3', unit_price: 4.4, merchant_id: merchant.id )
      params = {name: 'ttM' }
      expect(Item.find_multiple_items(params)).to eq([item1, item2, item3])
    end
  end
end
