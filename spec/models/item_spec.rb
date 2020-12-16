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
    it 'find_single_item' do
      item = create(:item)
      expect(Item.find_single_item('ga')).to eq(item)
    end
  end
end
