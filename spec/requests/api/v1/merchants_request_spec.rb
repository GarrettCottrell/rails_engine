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
      get "/api/v1/merchants/find?created_at='Fri, 18 Dec 2020 00:06:48 UTC +00:00"
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
      merchant1 = Merchant.create(name: 'GarrettMerchant1')
      merchant2 = Merchant.create(name: 'GarrettMerchant2')
      merchant3 = Merchant.create(name: 'GarrettMerchant3')

      get "/api/v1/merchants/find_all?updated_at='Fri, 18 Dec 2020 00:06:48 UTC +00:00"
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

      get "/api/v1/merchants/find_all?updated_at='Fri, 18 Dec 2020 00:06:48 UTC +00:00'"
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item[:data].size).to eq(3)
      search_item[:data].each do |data|
        expect(data[:attributes]).to have_key(:id)
        expect(data[:attributes]).to have_key(:name)
      end
    end
  end

  describe 'BI endpoint, merchants with most revenue' do
    it 'finds merchants with most revenue' do
      customer1 = create(:customer)
      customer2 = create(:customer)

      merchant1 = create(:merchant)
      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      invoice1 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant1.id)
      invoiceitems1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 15.00)
      transaction1 = create(:transaction, invoice_id: invoice1.id, result: 'success')
      invoice2 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant1.id)
      invoiceitems2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 15.00)
      transaction2 = create(:transaction, invoice_id: invoice2.id, result: 'success')

      merchant2 = create(:merchant)
      item3 = create(:item, merchant_id: merchant2.id)
      item4 = create(:item, merchant_id: merchant2.id)
      invoice3 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant2.id)
      invoiceitems3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id, quantity: 3, unit_price: 20.00)
      transaction3 = create(:transaction, invoice_id: invoice3.id, result: 'success')
      invoice4 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant2.id)
      invoiceitems4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id, quantity: 4, unit_price: 20.00)
      transaction4 = create(:transaction, invoice_id: invoice4.id, result: 'success')

      merchant3 = create(:merchant)
      item5 = create(:item, merchant_id: merchant3.id)
      item6 = create(:item, merchant_id: merchant3.id)
      invoice5 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant3.id)
      invoiceitems5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice5.id, quantity: 5, unit_price: 10.00)
      transaction5 = create(:transaction, invoice_id: invoice5.id, result: 'success')
      invoice6 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant3.id)
      invoiceitems6 = create(:invoice_item, item_id: item6.id, invoice_id: invoice6.id, quantity: 6, unit_price: 10.00)
      transaction6 = create(:transaction, invoice_id: invoice6.id, result: 'success')

      get '/api/v1/merchants/most_revenue?quantity=2'

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      merchant_response[:data].each do |data|
        expect(data[:attributes]).to have_key(:name)
        expect(data[:attributes]).to have_key(:id)
      end
    end

    it 'finds merchants with most revenue' do
      customer1 = create(:customer)
      customer2 = create(:customer)

      merchant1 = create(:merchant)
      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      invoice1 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant1.id)
      invoiceitems1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 15.00)
      transaction1 = create(:transaction, invoice_id: invoice1.id, result: 'success')
      invoice2 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant1.id)
      invoiceitems2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 15.00)
      transaction2 = create(:transaction, invoice_id: invoice2.id, result: 'success')

      merchant2 = create(:merchant)
      item3 = create(:item, merchant_id: merchant2.id)
      item4 = create(:item, merchant_id: merchant2.id)
      invoice3 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant2.id)
      invoiceitems3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id, quantity: 3, unit_price: 20.00)
      transaction3 = create(:transaction, invoice_id: invoice3.id, result: 'success')
      invoice4 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant2.id)
      invoiceitems4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id, quantity: 4, unit_price: 20.00)
      transaction4 = create(:transaction, invoice_id: invoice4.id, result: 'success')

      merchant3 = create(:merchant)
      item5 = create(:item, merchant_id: merchant3.id)
      item6 = create(:item, merchant_id: merchant3.id)
      invoice5 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant3.id)
      invoiceitems5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice5.id, quantity: 5, unit_price: 10.00)
      transaction5 = create(:transaction, invoice_id: invoice5.id, result: 'success')
      invoice6 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant3.id)
      invoiceitems6 = create(:invoice_item, item_id: item6.id, invoice_id: invoice6.id, quantity: 6, unit_price: 10.00)
      transaction6 = create(:transaction, invoice_id: invoice6.id, result: 'success')

      get '/api/v1/merchants/most_items?quantity=3'

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      merchant_response[:data].each do |data|
        expect(data[:attributes]).to have_key(:name)
        expect(data[:attributes]).to have_key(:id)
      end
    end

    it 'single_revenue' do
      customer1 = create(:customer)
      customer2 = create(:customer)

      merchant1 = create(:merchant)
      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      invoice1 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant1.id)
      invoiceitems1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 15.00)
      transaction1 = create(:transaction, invoice_id: invoice1.id, result: 'success')
      invoice2 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant1.id)
      invoiceitems2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 15.00)
      transaction2 = create(:transaction, invoice_id: invoice2.id, result: 'success')

      merchant2 = create(:merchant)
      item3 = create(:item, merchant_id: merchant2.id)
      item4 = create(:item, merchant_id: merchant2.id)
      invoice3 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant2.id)
      invoiceitems3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id, quantity: 3, unit_price: 20.00)
      transaction3 = create(:transaction, invoice_id: invoice3.id, result: 'success')
      invoice4 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant2.id)
      invoiceitems4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id, quantity: 4, unit_price: 20.00)
      transaction4 = create(:transaction, invoice_id: invoice4.id, result: 'success')

      merchant3 = create(:merchant)
      item5 = create(:item, merchant_id: merchant3.id)
      item6 = create(:item, merchant_id: merchant3.id)
      invoice5 = Invoice.create(status: 'shipped', customer_id: customer1.id, merchant_id: merchant3.id)
      invoiceitems5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice5.id, quantity: 5, unit_price: 10.00)
      transaction5 = create(:transaction, invoice_id: invoice5.id, result: 'success')
      invoice6 = Invoice.create(status: 'shipped', customer_id: customer2.id, merchant_id: merchant3.id)
      invoiceitems6 = create(:invoice_item, item_id: item6.id, invoice_id: invoice6.id, quantity: 6, unit_price: 10.00)
      transaction6 = create(:transaction, invoice_id: invoice6.id, result: 'success')

      get "/api/v1/merchants/#{merchant1.id}/revenue"

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant_response[:data][:attributes]).to have_key(:revenue)
    end
  end
end
