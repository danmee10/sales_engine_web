require 'spec_helper'

describe "/customers/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  before(:each) do
    customer1 && customer2
  end

  let(:customer1){ SalesEngineWeb::Customer.create(:first_name => "Borris", :last_name => "Gates") }
  let(:customer2){ SalesEngineWeb::Customer.create(:first_name => "Welton", :last_name => "Fisk") }
  let(:customer3){ SalesEngineWeb::Customer.create(:first_name => "Welton", :last_name => "Atronaut") }
  let(:invoice1){ SalesEngineWeb::Invoice.create(:customer_id => 1) }
  let(:invoice2){ SalesEngineWeb::Invoice.create(:customer_id => 1) }
  let(:transaction1){ SalesEngineWeb::Transaction.create(:invoice_id => 1) }
  let(:transaction2){ SalesEngineWeb::Transaction.create(:invoice_id => 2) }

  describe "find" do
    it "finds a customer by id" do
      get "/customers/find?id=2"
      output = JSON.parse(last_response.body)
      expect( output['first_name'] ).to eq "Welton"
      expect( output['last_name'] ).to eq "Fisk"
    end
  end

  describe "find all by" do
    it "returns all customers with the given name" do
      customer3
      get "/customers/find_all?first_name=welton"
      output = JSON.parse(last_response.body)
      expect( output.length ).to eq 2
      expect( output[0]['first_name'] ).to eq 'Welton'
      expect( output[1]['first_name'] ).to eq 'Welton'
    end
  end

  describe "random" do
    it "returns a random customer" do
      get '/customers/random'
      output = JSON.parse(last_response.body)
      expect( [ customer1.id, customer2.id ] ).to include( output['id'] )
    end
  end

  describe "invoices" do
    it "returns all associated invoices" do
      invoice1 && invoice2
      get "/customers/1/invoices"
      output = JSON.parse(last_response.body)
      expect( output.length ).to eq 2
      expect( output[0]['customer_id'] ).to eq 1
      expect( output[1]['customer_id'] ).to eq 1
    end
  end

  describe "transactions" do
    it "returns a collection of associated transactions" do
      transaction1 && transaction2
      invoice1 && invoice2
      get "/customers/1/transactions"
      output = JSON.parse(last_response.body)
      expect( output.length ).to eq 2
      expect( output[0][0]['id'] ).to eq 1
      expect( output[1][0]['id'] ).to eq 2
    end
  end
#######business intel
  describe "favorite merchant" do
    it "returns the merchant with whom the customer has conducted the most successful transactions"
  end
end

