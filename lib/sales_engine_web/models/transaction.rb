require './lib/sales_engine_web/models/database'

module SalesEngineWeb
  class Transaction
    attr_reader :id,
                :invoice_id,
                :credit_card_number,
                :credit_card_expiration_date,
                :result,
                :created_at,
                :updated_at

    def initialize(params)
      @id                          = params[:id]
      @invoice_id                  = params[:invoice_id]
      @credit_card_number          = params[:credit_card_number]
      @credit_card_expiration_date = params[:credit_card_expiration_date]
      @result                      = params[:result]
      @created_at                  = params[:created_at]
      @updated_at                  = params[:updated_at]
    end

    def self.create(params)
      Transaction.new(params).save
    end

    def save
      @id = Transaction.add(self)
      self
    end

    def self.add(transaction)
      transactions.insert(transaction.to_hash)
    end

    def to_hash
      { :id                           => id,
        :invoice_id                   => invoice_id,
        :credit_card_number           => credit_card_number,
        :credit_card_expiration_date  => credit_card_expiration_date,
        :result                       => result,
        :created_at                   => created_at,
        :updated_at                   => updated_at}
    end

    def to_json(*args)
      { :id                           => id,
        :invoice_id                   => invoice_id,
        :credit_card_number           => credit_card_number,
        :credit_card_expiration_date  => credit_card_expiration_date,
        :result                       => result,
        :created_at                   => created_at,
        :updated_at                   => updated_at}.to_json
    end

    def self.transactions
      Database.transactions
    end

    def self.find(id)
      result = transactions.where(:id => id.to_i).limit(1).first
      new(result) if result
    end

    def self.random
      result = transactions.to_a.sample
      new(result) if result
    end

    def find_invoice
      results = Database.invoices.where(:id => invoice_id)
      if results
        results.collect do |result|
          Invoice.new(result)
        end
      end
    end
  end
end
