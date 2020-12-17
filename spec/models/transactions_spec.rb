require 'rails_helper'

describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of :result }
  end

  describe 'relationships' do
    it { should belong_to :invoice }
  end
end
