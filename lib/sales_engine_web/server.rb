module SalesEngineWeb
  class Server < Sinatra::Base
    get '/merchants/find' do
      status 200
      if params[:id]
        merchant = Merchant.find(params[:id])
      else
        merchant = Merchant.find_by_name(params[:name])
      end
      body merchant.to_json
    end

    get '/merchants/find_all' do
      body Merchant.find_all_by_name(params[:name]).to_json
    end

    get '/merchants/random' do
      Merchant.random.to_json
    end

    get "/merchants/:id/items" do
      merchant = Merchant.find(params[:id])
      items = merchant.find_items
      body items.to_json
    end

    get "/merchants/:id/invoices" do
      merchant = Merchant.find(params[:id])
      invoices = merchant.find_invoices
      body invoices.to_json
    end

    get '/items/find' do
      status 200
      if params[:id]
        item = Item.find(params[:id])
      else
        item = Item.find_by_name(params[:name])
      end
      body item.to_json
    end

    get '/items/find_all' do
      body Item.find_all_by_name(params[:name]).to_json
    end

    get '/items/random' do
      Item.random.to_json
    end

    get "/items/:id/invoice_items" do
      item = Item.find(params[:id])
      invoice_items = item.find_invoice_items
      body invoice_items.to_json
    end

    get "/items/:id/merchant" do
      item = Item.find(params[:id])
      merch = item.find_merchant
      body merch.to_json
    end

    get '/invoice_items/find' do
      invoice_item = InvoiceItem.find(params[:id])
      body invoice_item.to_json
    end

    get '/invoice_items/random' do
      InvoiceItem.random.to_json
    end

    get "/invoice_items/:id/invoice" do
      invoice_item = InvoiceItem.find(params[:id])
      invoice = invoice_item.find_invoice
      body invoice.to_json
    end

    get "/invoice_items/:id/item" do
      invoice_item = InvoiceItem.find(params[:id])
      item = invoice_item.find_item
      body item.to_json
    end

    get '/customers/find' do
      status 200
      if params[:id]
        customer = Customer.find(params[:id])
      else
        customer = Customer.find_by_name(params[:first_name])
      end
      body customer.to_json
    end

    get '/customers/find_all' do
      body Customer.find_all_by_first_name(params[:first_name]).to_json
    end

    get '/customers/random' do
      Customer.random.to_json
    end

    get "/customers/:id/invoices" do
      customer = Customer.find(params[:id])
      invoices = customer.find_invoices
      body invoices.to_json
    end

    get "/customers/:id/transactions" do
      customer = Customer.find(params[:id])
      invoices = customer.find_invoices
      transactions = invoices.collect do |invoice|
        each_tran = invoice.find_transactions
        each_tran.collect do |each|
          each
        end
      end
      body transactions.to_json
    end

    get "/invoices/find" do
      invoice = Invoice.find(params[:id])
      body invoice.to_json
    end

    get '/invoices/random' do
      Invoice.random.to_json
    end

    get "/invoices/:id/transactions" do
      invoice = Invoice.find(params[:id])
      transactions = invoice.find_transactions
      body transactions.to_json
    end

    get "/invoices/:id/invoice_items" do
      invoice = Invoice.find(params[:id])
      invoice_items = invoice.find_invoice_items
      body invoice_items.to_json
    end

    get "/invoices/:id/items" do
      invoice = Invoice.find(params[:id])
      invoice_items = invoice.find_invoice_items
      items = invoice_items.collect do |invoice_item|
        each_i = invoice_item.find_item
        each_i.collect do |each|
          each
        end
      end
      body items.to_json
    end

    get "/invoices/:id/customer" do
      invoice = Invoice.find(params[:id])
      customer = invoice.find_customer
      body customer.to_json
    end

    get "/invoices/:id/merchant" do
      invoice = Invoice.find(params[:id])
      merchant = invoice.find_merchant
      body merchant.to_json
    end

    get "/transactions/:id/invoice" do
      transaction = Transaction.find(params[:id])
      invoice = transaction.find_invoice
      body invoice.to_json
    end
  end
end
