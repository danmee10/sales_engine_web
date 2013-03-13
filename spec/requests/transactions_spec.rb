require 'spec_helper'

describe "/invoice_items/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  let(:invoice1){ SalesEngineWeb::Invoice.create(:customer_id => 1) }
  let(:transaction1){ SalesEngineWeb::Transaction.create(:invoice_id => 1) }

  describe "invoice" do
    it "returns the associated invoice" do
      invoice1 && transaction1
      get "/transactions/1/invoice"
      output = JSON.parse(last_response.body)
      expect( output[0]['customer_id'] ).to eq 1
    end
  end
end

