require 'spec_helper'

describe "/invoice_items/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    invoice_item1 && invoice_item2
  end

  let(:invoice_item1){ SalesEngineWeb::InvoiceItem.create(:item_id => 1, :quantity => 2, :invoice_id => 1) }
  let(:invoice_item2){ SalesEngineWeb::InvoiceItem.create(:item_id => 3, :quantity => 9) }
  let(:invoice1){ SalesEngineWeb::Invoice.create(:merchant_id => 6) }
  let(:item1){ SalesEngineWeb::Item.create(:name => "fun", :merchant_id => 6) }

  describe "find by" do
    it "returns the invoice item with the given id" do
      get '/invoice_items/find?id=1'
      output = JSON.parse(last_response.body)
      expect( output['id'] ).to eq 1
      expect( output['quantity'] ).to eq 2
    end
  end

  describe "random" do
    it "returns a random instance of an invoice item" do
      get '/invoice_items/random'
      output = JSON.parse(last_response.body)
      expect( [ invoice_item1.id, invoice_item2.id ] ).to include( output['id'] )
    end
  end

  describe "invoice" do
    it "returns the associated invoice" do
      invoice1
      get '/invoice_items/1/invoice'
      output = JSON.parse(last_response.body)
      expect( output[0]['id'] ).to eq 1
      expect( output[0]['merchant_id'] ).to eq 6
    end
  end

  describe "item" do
    it "returns the associated item" do
      item1
      get '/invoice_items/1/item'
      output = JSON.parse(last_response.body)
      expect( output[0]['id'] ).to eq 1
      expect( output[0]['name'] ).to eq "fun"
    end
  end
end
