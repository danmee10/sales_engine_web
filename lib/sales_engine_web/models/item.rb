require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class Item
    attr_reader :id, :name, :merchant_id

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
      @merchant_id = params[:merchant_id]
    end

    def self.create(params)
      Item.new(params).save
    end

    def save
      @id = Item.add(self)
      self
    end

    def self.add(item)
      items.insert(item.to_hash)
    end

    def to_hash
      { :id => id, :name => name, :merchant_id => merchant_id}
    end

    def to_json(*args)
      {:id => id, :name => name, :merchant_id => merchant_id}.to_json
    end

    def self.items
      Database.items
    end

    def self.find(id)
      result = items.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.find_by_name(name)
      result = items.limit(1).where(Sequel.ilike(:name, "%#{name}%")).first
      new(result) if result
    end

    def self.find_all_by_name(name)
      results = items.where(Sequel.ilike(:name, "%#{name}%"))
      if results
        results.collect do |result|
          Item.new(result)
        end
      end
    end

    def self.random
      result = items.to_a.sample
      new(result) if result
    end

    def find_invoice_items
      results = Database.invoice_items.where(:item_id => id)
      if results
        results.collect do |result|
          InvoiceItem.new(result)
        end
      end
    end

    def find_merchant
      merchant = Database.merchants.where(:id => merchant_id)
      if merchant
        merchant.collect do |merch|
          Merchant.new(merch)
        end
      end
    end
  end
end
