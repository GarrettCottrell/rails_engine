class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  validates_presence_of :status
end
