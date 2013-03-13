require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class InvoiceItem
    attr_reader :id, :item_id, :invoice_id, :quantity, :unit_price

    def initialize(params)
      @id         = params[:id]
      @item_id    = params[:item_id]
      @invoice_id = params[:invoice_id]
      @quantity   = params[:quantity]
      @unit_price = params[:unit_price]
    end

    def self.create(params)
      InvoiceItem.new(params).save
    end

    def save
      @id = InvoiceItem.add(self)
      self
    end

    def self.add(invoice_item)
      invoice_items.insert(invoice_item.to_hash)
    end

    def to_hash
      { :id         => id,
        :item_id    => item_id,
        :invoice_id => invoice_id,
        :quantity   => quantity,
        :unit_price => unit_price}
    end

    def to_json(*args)
       { :id         => id,
         :item_id    => item_id,
         :invoice_id => invoice_id,
         :quantity   => quantity,
         :unit_price => unit_price}.to_json
    end

    def self.invoice_items
      Database.invoice_items
    end

    def self.find(id)
      result = invoice_items.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.random
      result = invoice_items.to_a.sample
      new(result) if result
    end

    def find_invoice
      invoice = Database.invoices.where(:id => invoice_id)
      if invoice
        invoice.collect do |inv|
          Invoice.new(inv)
        end
      end
    end

    def find_item
      item = Database.items.where(:id => item_id)
      if item
        item.collect do |it|
          Item.new(it)
        end
      end
    end
  end
end
