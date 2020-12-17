class Transaction < ApplicationRecord
  belongs_to :invoice
  validates_presence_of :result
end
