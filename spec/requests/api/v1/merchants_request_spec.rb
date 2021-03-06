require 'rails_helper'

describe 'Merchants API' do 
  it 'sends a list of all merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(5)
    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:id)
      expect(merchant[:attributes]).to have_key(:name)
    end
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data][:attributes]).to have_key(:id)
    expect(merchant[:data][:attributes]).to have_key(:name)
  end

  it 'can create a new merchant' do 
    merchant_params = {
      name: 'Garrett'
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant_params)
    created_merchant = Merchant.last 

    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])
  end

  it 'can update a merchant record' do
    id = create(:merchant).id
    previous_name = Merchant.last.name 
    merchant_params = { name: 'GarrettNew'}
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant_params)
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
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      create(:item, merchant_id: merchant1.id)
      create(:item, merchant_id: merchant2.id)
      create(:item, merchant_id: merchant1.id)

      get "/api/v1/merchants/#{merchant2.id}/items"
      merchant_items = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(merchant_items[:data][0][:attributes]).to have_key(:name)
      expect(merchant_items[:data][0][:attributes]).to have_key(:description)
      expect(merchant_items[:data][0][:attributes]).to have_key(:unit_price)
    end
  end

  describe 'search API' do
    it 'can find a merchant with inputed name' do
      Merchant.create(name: 'GarrettMerchant')

      get '/api/v1/merchants/find?name=Ga'
      search_merchant = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_merchant[:data][:attributes]).to have_key(:id)
      expect(search_merchant[:data][:attributes]).to have_key(:name)
    end

    it 'can find a merchant with inputed created_at search term' do
      Merchant.create(name: 'GarrettMerchant')
      get "/api/v1/merchants/find?created_at='Thu, 17 Dec 2020 00:28:02 UTC'"
      search_merchant = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_merchant[:data][:attributes]).to have_key(:id)
      expect(search_merchant[:data][:attributes]).to have_key(:name)
    end

    it 'can find multiple merchants with name search' do
      Merchant.create!(name: 'GarrettMerchant1')
      Merchant.create(name: 'GarrettMerchant2')
      Merchant.create(name: 'GarrettMerchant3')

      get '/api/v1/merchants/find_all?name=Mer'
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item[:data].size).to eq(3)
      search_item[:data].each do |data|
      expect(data[:attributes]).to have_key(:id)
      expect(data[:attributes]).to have_key(:name)
      end
    end

    it 'can find multiple merchants with updated_at search' do
      Merchant.create(name: 'GarrettMerchant1')
      Merchant.create(name: 'GarrettMerchant2')
      Merchant.create(name: 'GarrettMerchant3')

      get "/api/v1/merchants/find_all?updated_at='Thu, 17 Dec 2020 00:28:02 UTC'"
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item[:data].size).to eq(3)
      search_item[:data].each do |data|
      expect(data[:attributes]).to have_key(:id)
      expect(data[:attributes]).to have_key(:name)
      end
    end

    it 'can find multiple merchants with updated_at search' do
      Merchant.create(name: 'GarrettMerchant1')
      Merchant.create(name: 'GarrettMerchant2')
      Merchant.create(name: 'GarrettMerchant3')

      get "/api/v1/merchants/find_all?updated_at='Thu, 17 Dec 2020 00:28:02 UTC'"
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item[:data].size).to eq(3)
      search_item[:data].each do |data|
        expect(data[:attributes]).to have_key(:id)
        expect(data[:attributes]).to have_key(:name)
      end
    end
  end
end
