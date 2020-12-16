require 'rails_helper'

describe 'Merchants API' do 
  it 'sends a list of all merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
  end

  it 'can create a new merchant' do 
    merchant_params = {
      name: 'Garrett'
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant: merchant_params)
    created_merchant = Merchant.last 

    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])
  end

  it 'can update a merchant record' do
    id = create(:merchant).id
    previous_name = Merchant.last.name 
    merchant_params = { name: 'GarrettNew'}
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate({merchant: merchant_params})
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq('GarrettNew')
  end

  it 'can destroy a merchant' do 
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)
    delete "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful 
    expect(Merchant.count).to eq(0)
    expect { Merchant.find(merchant.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe 'relationship' do
    it 'can find merchant items' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      create(:item, merchant_id: merchant_1.id)
      create(:item, merchant_id: merchant_2.id)
      create(:item, merchant_id: merchant_1.id)

      get "/api/v1/merchants/#{merchant_2.id}/items"
      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant_items[0]).to have_key(:name)
      expect(merchant_items[0][:name]).to be_a(String)
      expect(merchant_items[0]).to have_key(:description)
      expect(merchant_items[0][:description]).to be_a(String)
      expect(merchant_items[0]).to have_key(:unit_price)
      expect(merchant_items[0][:unit_price]).to be_a(Float)
    end
  end
end
