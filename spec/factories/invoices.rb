FactoryBot.define do
  factory :invoice do 
    customer
    merchant
    status { Faker::randomElement(['packaged', 'returned', 'shipped']) }
    merchant
  end
end