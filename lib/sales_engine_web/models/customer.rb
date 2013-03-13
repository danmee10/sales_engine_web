require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class Customer
    attr_reader :id, :first_name, :last_name

    def initialize(params)
      @id         = params[:id]
      @first_name = params[:first_name]
      @last_name  = params[:last_name]
    end

    def self.create(params)
      Customer.new(params).save
    end

    def save
      @id = Customer.add(self)
      self
    end

    def self.add(customer)
      customers.insert(customer.to_hash)
    end

    def to_hash
      { :id => id, :first_name => first_name, :last_name => last_name}
    end

    def to_json(*args)
        {:id => id, :first_name => first_name, :last_name => last_name}.to_json
    end

    def self.customers
      Database.customers
    end

    def self.find(id)
      result = customers.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_all_by_first_name(name)
      results = customers.where(Sequel.ilike(:first_name, "%#{name}%"))
      if results
        results.collect do |result|
          Customer.new(result)
        end
      end
    end

    def self.random
      result = customers.to_a.sample
      new(result) if result
    end

    def find_invoices
      results = Database.invoices.where(:customer_id => id)
      if results
        results.collect do |result|
          Invoice.new(result)
        end
      end
    end

    def find_transactions
      results = Database.transactions.where(:customer_id => id)
      if results
        results.collect do |result|
          Transaction.new(result)
        end
      end
    end
  end
end
