require 'rails_helper'

describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'class methods' do
    it 'find_single_merchant' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      expect(Merchant.find_single_merchant('Ga')).to eq(merchant)
    end
  end
end
