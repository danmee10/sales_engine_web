require './lib/sales_engine_web/models/merchant'

module SalesEngineWeb
  describe Merchant do
    describe '.create' do
      it 'creates a merchant' do
        merchant = Merchant.create(:id => 12, :name => "Jumpstart Lab")
        expect( merchant.id ).to eq 12
        expect( merchant.name ).to eq "Jumpstart Lab"
      end
    end

    describe '.find' do
      it "finds a merchant" do
        target = Merchant.create(:id => 12, :name => "Jumpstart Lab")
        found  = Merchant.find(12)
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end
    end

    describe '.find_by_name' do
      it "finds a merchant by name" do
        target = Merchant.create(:id => 12, :name => "Jumpstart Lab")
        found  = Merchant.find_by_name("Jumpstart Lab")
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end

      it "finds by name, case insensitive" do
        target = Merchant.create(:id => 12, :name => "Jumpstart Lab")
        found  = Merchant.find_by_name("jumpstart lab")
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end
    end

    describe ".random" do
      it "returns a merchant" do
        Merchant.create(:id => 12, :name => "Jumpstart Lab")
        expect( Merchant.random ).to be_kind_of(Merchant)
      end
    end
  end
end
