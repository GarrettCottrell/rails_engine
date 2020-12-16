require 'rails_helper'

describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
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
      params = {unit_price: 4}
      expect(Item.find_single_item(params)).to eq(item)
    end

    it 'find_single_item by created_at' do
      merchant = create(:merchant)
      item = Item.create!(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )
      params = {created_at: Date.today.strftime }
      expect(Item.find_single_item(params)).to eq(item)
    end

    it 'find_single_item by updated_at' do
      merchant = create(:merchant)
      item = Item.create!(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )
      params = {updated_at: Date.today.strftime }
      expect(Item.find_single_item(params)).to eq(item)
    end
  end
end
