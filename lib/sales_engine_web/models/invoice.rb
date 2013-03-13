require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class Invoice
    attr_reader :id, :customer_id, :merchant_id

    def initialize(params)
      @id          = params[:id]
      @customer_id = params[:customer_id]
      @merchant_id = params[:merchant_id]
    end

    def self.create(params)
      Invoice.new(params).save
    end

    def save
      @id = Invoice.add(self)
      self
    end

    def self.add(invoice)
      invoices.insert(invoice.to_hash)
    end

    def to_hash
      { :id => id, :customer_id => customer_id, :merchant_id => merchant_id}
    end

    def to_json(*args)
      {:id => id, :customer_id => customer_id, :merchant_id => merchant_id}.to_json
    end

    def self.invoices
      Database.invoices
    end

    def self.find(id)
      result = invoices.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.random
      result = invoices.to_a.sample
      new(result) if result
    end

    def find_transactions
      results = Database.transactions.where(:invoice_id => id)
      if results
        results.collect do |result|
          Transaction.new(result)
        end
      end
    end

    def find_invoice_items
      results = Database.invoice_items.where(:invoice_id => id)
      if results
        results.collect do |result|
          InvoiceItem.new(result)
        end
      end
    end

    def find_customer
      results = Database.customers.where(:id => customer_id)
      if results
        results.collect do |result|
          Customer.new(result)
        end
      end
    end

    def find_merchant
      results = Database.merchants.where(:id => merchant_id)
      if results
        results.collect do |result|
          Merchant.new(result)
        end
      end
    end
  end
end
