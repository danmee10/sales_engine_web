require 'spec_helper'

describe "/invoices/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    invoice1 && invoice2
  end

  let(:invoice1){ SalesEngineWeb::Invoice.create(:customer_id => 1, :merchant_id => 1) }
  let(:invoice2){ SalesEngineWeb::Invoice.create(:customer_id => 6) }
  let(:transaction1){ SalesEngineWeb::Transaction.create(:invoice_id => 1) }
  let(:transaction2){ SalesEngineWeb::Transaction.create(:invoice_id => 1) }
  let(:invoice_item1){ SalesEngineWeb::InvoiceItem.create(:item_id => 1, :quantity => 2, :invoice_id => 1) }
  let(:invoice_item2){ SalesEngineWeb::InvoiceItem.create(:item_id => 2, :quantity => 9, :invoice_id => 1) }
  let(:item1){ SalesEngineWeb::Item.create(:name => "fun", :merchant_id => 8) }
  let(:item2){ SalesEngineWeb::Item.create(:name => "stuff", :merchant_id => 3) }
  let(:customer1){ SalesEngineWeb::Customer.create(:first_name => "Thomas", :last_name => "Nobleman") }
  let(:merchant1){ SalesEngineWeb::Merchant.create(:name => "Ghartuk") }

  describe "find by" do
    it "finds an invoice by id" do
      get "/invoices/find?id=2"
      output = JSON.parse(last_response.body)
      expect( output['customer_id'] ).to eq 6
      expect( output['id'] ).to eq 2
    end
  end

  describe "random" do
    it "returns a random invoice" do
      get '/invoices/random'
      output = JSON.parse(last_response.body)
      expect( [ invoice1.id, invoice2.id ] ).to include( output['id'] )
    end
  end

  describe "transactions" do
    it "returns a collection of associated transactions" do
      transaction1 && transaction2
      get "/invoices/1/transactions"
      output = JSON.parse(last_response.body)
      expect( output.length ).to eq 2
      expect( output[0]['invoice_id'] ).to eq 1
      expect( output[1]['invoice_id'] ).to eq 1
    end
  end

  describe "invoice items" do
    it "returns a collection of associated invoice items" do
      invoice_item1 && invoice_item2
      get "/invoices/1/invoice_items"
      output = JSON.parse(last_response.body)
      expect( output.length ).to eq 2
      expect( output[0]['invoice_id'] ).to eq 1
      expect( output[1]['invoice_id'] ).to eq 1
    end
  end

  describe "item" do
    it "returns associated items" do
      item1 && item2
      invoice_item1 && invoice_item2
      get '/invoices/1/items'
      output = JSON.parse(last_response.body)
      expect( output[0][0]['name'] ).to eq "fun"
      expect( output[1][0]['name'] ).to eq "stuff"
    end
  end

  describe "customer" do
    it "returns the associated customer" do
      customer1
      get '/invoices/1/customer'
      output = JSON.parse(last_response.body)
      expect( output[0]['id'] ).to eq 1
      expect( output[0]['first_name'] ).to eq "Thomas"
    end
  end

  describe "merchant" do
    it "returns the associated merchant" do
      merchant1
      get '/invoices/1/merchant'
      output = JSON.parse(last_response.body)
      expect( output[0]['id'] ).to eq 1
      expect( output[0]['name'] ).to eq "Ghartuk"
    end
  end
end
