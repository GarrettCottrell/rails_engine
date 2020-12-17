require 'rails_helper'

describe 'Items API' do 
  it 'sends a list of all items' do
    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(5)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)
      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
    end
  end

  it 'can get one item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"
    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(Integer)
    expect(item).to have_key(:name)
    expect(item[:name]).to be_a(String)
    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)
    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_a(Float)
  end

  it 'can create a new item' do 
    merchant_1 = create(:merchant)
    item_params = {
      name: 'GarrettItem',
      description: 'testdescription',
      unit_price: 5.6,
      merchant_id: merchant_1.id
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
  end

  it 'can update an item record' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { 
      name: 'GarrettNewItem'
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('GarrettNewItem')
  end

  it 'can destroy a merchant' do
    item = create(:item)

    expect(Item.count).to eq(1)
    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful 
    expect(Item.count).to eq(0)
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe 'relationships' do
    it 'can find the merchants for each item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchants"
      merchant_by_item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant_by_item).to have_key(:name)
      expect(merchant_by_item[:name]).to be_a(String)
    end
  end

  describe 'search API' do
    it 'can find an item with inputed name search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )

      get '/api/v1/items/find?name=Me'
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item).to have_key(:id)
      expect(search_item).to have_key(:created_at)
      expect(search_item).to have_key(:description)
      expect(search_item).to have_key(:unit_price)
      expect(search_item).to have_key(:updated_at)
    end

    it 'can find an item with inputed description search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )

      get '/api/v1/items/find?description=em'
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item).to have_key(:id)
      expect(search_item).to have_key(:created_at)
      expect(search_item).to have_key(:description)
      expect(search_item).to have_key(:unit_price)
      expect(search_item).to have_key(:updated_at)
    end

    xit 'can find an item with inputed unit_price search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )

      get '/api/v1/items/find?unit_price=4.2'
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item).to have_key(:id)
      expect(search_item).to have_key(:created_at)
      expect(search_item).to have_key(:description)
      expect(search_item).to have_key(:unit_price)
      expect(search_item).to have_key(:updated_at)
    end

    it 'can find an item with inputed created_at search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )

      get "/api/v1/items/find?created_at=#{Date.today.strftime}"
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item).to have_key(:id)
      expect(search_item).to have_key(:created_at)
      expect(search_item).to have_key(:description)
      expect(search_item).to have_key(:unit_price)
      expect(search_item).to have_key(:updated_at)
    end

    it 'can find an item with inputed updated_at search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant', description: 'Test item description', unit_price: 4.2, merchant_id: merchant.id )

      get "/api/v1/items/find?updated_at=#{Date.today.strftime}"
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item).to have_key(:id)
      expect(search_item).to have_key(:created_at)
      expect(search_item).to have_key(:description)
      expect(search_item).to have_key(:unit_price)
      expect(search_item).to have_key(:updated_at)
    end

    it 'can find multiple items with name search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant1', description: 'Test item description1', unit_price: 4.2, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant2', description: 'Test item description2', unit_price: 4.3, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant3', description: 'Test item description3', unit_price: 4.4, merchant_id: merchant.id )

      get '/api/v1/items/find_all?name=ttM'
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item.size).to eq(3)
      expect(search_item[0]).to have_key(:id)
      expect(search_item[0]).to have_key(:created_at)
      expect(search_item[0]).to have_key(:description)
      expect(search_item[0]).to have_key(:unit_price)
      expect(search_item[0]).to have_key(:updated_at)
    end

    it 'can find multiple items with description search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant1', description: 'Test item description1', unit_price: 4.2, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant2', description: 'Test item description2', unit_price: 4.3, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant3', description: 'Test item description3', unit_price: 4.4, merchant_id: merchant.id )

      get '/api/v1/items/find_all?description=item'
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item.size).to eq(3)
      expect(search_item[0]).to have_key(:id)
      expect(search_item[0]).to have_key(:created_at)
      expect(search_item[0]).to have_key(:description)
      expect(search_item[0]).to have_key(:unit_price)
      expect(search_item[0]).to have_key(:updated_at)
    end

    xit 'can find multiple items with unit_price search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant1', description: 'Test item description1', unit_price: 4.2, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant2', description: 'Test item description2', unit_price: 4.3, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant3', description: 'Test item description3', unit_price: 4.4, merchant_id: merchant.id )

      get '/api/v1/items/find_all?unit_price=4'
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item.size).to eq(3)
      expect(search_item[0]).to have_key(:id)
      expect(search_item[0]).to have_key(:created_at)
      expect(search_item[0]).to have_key(:description)
      expect(search_item[0]).to have_key(:unit_price)
      expect(search_item[0]).to have_key(:updated_at)
    end

    it 'can find multiple items with created_at search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant1', description: 'Test item description1', unit_price: 4.2, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant2', description: 'Test item description2', unit_price: 4.3, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant3', description: 'Test item description3', unit_price: 4.4, merchant_id: merchant.id )

      get "/api/v1/items/find_all?created_at=#{Date.today.strftime}"
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item.size).to eq(3)
      expect(search_item[0]).to have_key(:id)
      expect(search_item[0]).to have_key(:created_at)
      expect(search_item[0]).to have_key(:description)
      expect(search_item[0]).to have_key(:unit_price)
      expect(search_item[0]).to have_key(:updated_at)
    end

    it 'can find multiple items with updated_at search' do
      merchant = Merchant.create(name: 'GarrettMerchant')
      Item.create(name: 'GarrettMerchant1', description: 'Test item description1', unit_price: 4.2, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant2', description: 'Test item description2', unit_price: 4.3, merchant_id: merchant.id )
      Item.create(name: 'GarrettMerchant3', description: 'Test item description3', unit_price: 4.4, merchant_id: merchant.id )

      get "/api/v1/items/find_all?updated_at=#{Date.today.strftime}"
      search_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(search_item.size).to eq(3)
      expect(search_item[0]).to have_key(:id)
      expect(search_item[0]).to have_key(:created_at)
      expect(search_item[0]).to have_key(:description)
      expect(search_item[0]).to have_key(:unit_price)
      expect(search_item[0]).to have_key(:updated_at)
    end
  end
end
