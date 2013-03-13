require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class Merchant
    attr_reader :id, :name

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
    end

    def self.create(params)
      Merchant.new(params).save
    end

    def save
      @id = Merchant.add(self)
      self
    end

    def self.add(merchant)
      merchants.insert(merchant.to_hash)
    end

    def to_hash
      { :id => id, :name => name}
    end

    def self.find(id)
      result = merchants.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_by_name(name)
      result = merchants.limit(1).where(Sequel.ilike(:name, "%#{name}%")).first
      new(result) if result
    end

    def self.find_all_by_name(name)
      results = merchants.where(Sequel.ilike(:name, "%#{name}%"))
      if results
        results.collect do |result|
          Merchant.new(result)
        end
      end
    end

    def find_items
      results = Database.items.where(:merchant_id => id)
      if results
        results.collect do |result|
          Item.new(result)
        end
      end
    end

    def find_invoices
      results = Database.invoices.where(:merchant_id => id)
      if results
        results.collect do |result|
          Invoice.new(result)
        end
      end
    end

    def to_json(*args)
      {:id => id, :name => name}.to_json
    end

    def self.random
      result = merchants.to_a.sample
      new(result) if result
    end

    def self.merchants
      Database.merchants
    end
  end
end
