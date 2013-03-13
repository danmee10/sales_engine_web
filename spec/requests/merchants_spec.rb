require 'spec_helper'

describe "/merchants/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    merchant1 && merchant2
  end

  let(:merchant1){ SalesEngineWeb::Merchant.create(:name => "Jumpstart Lab") }
  let(:merchant2){ SalesEngineWeb::Merchant.create(:name => "gSchool") }
  let(:merchant3){ SalesEngineWeb::Merchant.create(:name => "Galvanize") }
  let(:merchant4){ SalesEngineWeb::Merchant.create(:name => "gSchool") }
  let(:item1){ SalesEngineWeb::Item.create(:name => "fun", :merchant_id => 1) }
  let(:item2){ SalesEngineWeb::Item.create(:name => "stuff", :merchant_id => 1) }
  let(:invoice1){ SalesEngineWeb::Invoice.create(:merchant_id => 1) }
  let(:invoice2){ SalesEngineWeb::Invoice.create(:merchant_id => 1) }

  describe "random" do
    it "returns a random merchant" do
      get '/merchants/random'
      output = JSON.parse(last_response.body)
      expect( [ merchant1.id, merchant2.id ] ).to include( output['id'] )
    end
  end

  describe "find" do
    context "given an existing id" do
      it "finds the merchant" do
        get "/merchants/find?id=#{ merchant1.id }"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq merchant1.id
        expect( output['name'] ).to eq merchant1.name
      end

      it "finds merchant2" do
        get "/merchants/find?id=#{merchant2.id}"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq merchant2.id
        expect( output['name'] ).to eq merchant2.name
      end
    end

    context "given name='Jumpstart%20Lab'" do
      it "finds the merchant" do
        get "/merchants/find?name=Jumpstart%20Lab"
        output = JSON.parse(last_response.body)
        expect( output['id'] ).to eq merchant1.id
        expect( output['name'] ).to eq merchant1.name
      end
    end
  end

  describe "find all" do
    context "given a name" do
      it "finds all merchants with given name" do
        merchant4
        get "/merchants/find_all?name=gSchool"
        output = JSON.parse(last_response.body)
        expect( output.length ).to eq 2
        expect( output[0]['name'] ).to eq 'gSchool'
        expect( output[1]['name'] ).to eq 'gSchool'
      end
    end
  end

  describe "items" do
    it "returns all associated items" do
      item1 && item2
      get "/merchants/1/items"
      output = JSON.parse(last_response.body)
      expect( output.length ).to eq 2
      expect( output[0]['name'] ).to eq 'fun'
      expect( output[1]['name'] ).to eq 'stuff'
    end
  end

  describe "invoices" do
    it "returns all associated invoices" do
      invoice1 && invoice2
      get "/merchants/1/invoices"
      output = JSON.parse(last_response.body)
      expect( output.length ).to eq 2
      expect( output[0]['merchant_id'] ).to eq 1
      expect( output[1]['merchant_id'] ).to eq 1
    end
  end

  context "across all merchants" do
    describe "most revenue" do
      it "returns top 'x' merchants ranked by total revenue"
        # merchant3 && merchant4
        # get "/merchants/most_revenue?quantity=2"
        # output = JSON.parse(last_response.body)
    end

    describe "most items" do
      it "returns top 'x' merchants ranked by total items sold"
    end

    describe "revenue" do
      it "returns total revenue for given day across all merchants"
    end
  end

  context "for a single merchant" do
    describe "revenue" do
      it "returns total revenue for single merchant"
    end

    describe "revenur?date=x" do
      it "returns total revenur for given merchant on given invoice date"
    end

    describe "favorite customer" do
      it "returns the customer who has conducted the most successful transactions"
    end

    describe "customers_with_pending_invoices" do
      it "returns a collection of customers which have pending (unpaid) invoices"
    end
  end
end
