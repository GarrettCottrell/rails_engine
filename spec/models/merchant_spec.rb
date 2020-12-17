require 'rails_helper'

describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'class methods' do
    it 'find_single_merchant by name' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      params = {name: 'Ga'}
      expect(Merchant.find_single_merchant(params)).to eq(merchant)
    end

    it 'find_single_merchant by created at' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      params = { created_at: 'Thu, 17 Dec 2020 00:28:02 UTC' }
      expect(Merchant.find_single_merchant(params)).to eq(merchant)
    end

    it 'find_single_merchant by updated at' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      params = { updated_at: 'Thu, 17 Dec 2020 00:28:02 UTC' }
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
      params = {created_at: 'Thu, 17 Dec 2020 00:28:02 UTC'}
      expect(Merchant.find_multiple_merchants(params)).to eq([merchant1, merchant2, merchant3])
    end

    it 'find_multiple_merchants by updated_at search' do 
      merchant1 = Merchant.create!(name: 'GarrettMerchant1')
      merchant2 = Merchant.create(name: 'GarrettMerchant2')
      merchant3 = Merchant.create(name: 'GarrettMerchant3')
      params = {updated_at: 'Thu, 17 Dec 2020 00:28:02 UTC'}
      expect(Merchant.find_multiple_merchants(params)).to eq([merchant1, merchant2, merchant3])
    end
  end
end
