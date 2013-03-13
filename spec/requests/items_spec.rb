require 'spec_helper'

describe "/items/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    item1 && item2
  end

  let(:item1){ SalesEngineWeb::Item.create(:name => "fun", :merchant_id => 6) }
  let(:item2){ SalesEngineWeb::Item.create(:name => "stuff", :merchant_id => 1) }
  let(:item3){ SalesEngineWeb::Item.create(:name => "stuff", :merchant_id => 2) }
  let(:invoice_item1){ SalesEngineWeb::InvoiceItem.create(:item_id => 1, :quantity => 2) }
  let(:invoice_item2){ SalesEngineWeb::InvoiceItem.create(:item_id => 1, :quantity => 9) }
  let(:merchant1){ SalesEngineWeb::Merchant.create(:name => "chris") }
  let(:merchant2){ SalesEngineWeb::Merchant.create(:name => "farley") }

  describe "find" do
    it "finds an item by name" do
      get "/items/find?name=stuff"
      output = JSON.parse(last_response.body)
      expect( output['merchant_id'] ).to eq 1
      expect( output['name'] ).to eq "stuff"
    end

    it "finds an item by id" do
      get "/items/find?id=1"
      output = JSON.parse(last_response.body)
      expect( output['merchant_id'] ).to eq 6
      expect( output['name'] ).to eq "fun"
    end
  end

  describe "find_all" do
    it "finds all items by a given name" do
      item3
      get "/items/find_all?name=stuff"
      output = JSON.parse(last_response.body)
      expect( output.length ).to eq 2
      expect( output[0]['id'] ).to eq 2
      expect( output[1]['id'] ).to eq 3
    end
  end

  describe "random" do
    it "returns a random item" do
      get '/items/random'
      output = JSON.parse(last_response.body)
      expect( [ item1.id, item2.id ] ).to include( output['id'] )
    end
  end

  describe "invoice items" do
    it "returns a collection of associated invoice items" do
      invoice_item1 && invoice_item2
      get "/items/1/invoice_items"
      output = JSON.parse(last_response.body)
      expect( output.length ).to eq 2
      expect( output[0]['id'] ).to eq 1
      expect( output[1]['id'] ).to eq 2
    end
  end

  describe "merchant" do
    it "returns the merchant associated with the item" do
      merchant1 && merchant2
      get "/items/2/merchant"
      output = JSON.parse(last_response.body)
      expect( output[0]['id'] ).to eq 1
      expect( output[0]['name'] ).to eq 'chris'
    end
  end

  describe "most_revenue" do
    context "with a quantity=3 parameter" do
      it "returns the top 3 merchants by total revenue"
    end
  end

  describe "most_items" do
    it "returns the top 'x' items ranked by total number sold"
  end

  describe "best_day" do
    it "returns the invoice date with the most sales for the given item"
  end
end
