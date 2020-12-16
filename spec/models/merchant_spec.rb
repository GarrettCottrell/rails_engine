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
      params = { created_at: Date.today.strftime }
      expect(Merchant.find_single_merchant(params)).to eq(merchant)
    end

    it 'find_single_merchant by updated at' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      params = { updated_at: Date.today.strftime }
      expect(Merchant.find_single_merchant(params)).to eq(merchant)
    end
  end
end
