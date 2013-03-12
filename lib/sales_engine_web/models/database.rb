module SalesEngineWeb
  class Database

    def self.database
      @database ||= Sequel.sqlite("./db/sales_engine_web_#{ environment }.sqlite3")
    end

    def self.destroy
      if environment == :test
        system "rm './db/sales_engine_web_test.sqlite3'"
      else
        raise "Go do it yourself!"
      end
    end

    def self.merchants
      unless tables.include?(:merchants)
        build_merchants_table
      end

      database[:merchants]
    end

    def self.tables
      @tables ||= []
    end

    def self.build_merchants_table
      database.
      tables << :merchants
    end

    def self.environment=(input)
      @environment = input
    end

    def self.environment
      @environment ||= :development
    end
  end
end