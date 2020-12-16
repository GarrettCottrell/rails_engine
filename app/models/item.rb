class Item < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name,
                        :description,
                        :unit_price

  def self.find_single_item(search_term)
    where('name').includes(search_term)
  end
end
