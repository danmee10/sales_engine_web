require 'spec_helper'

module SalesEngineWeb
  describe Merchant do
    describe '.create' do
      it 'creates a merchant' do
        merchant = Merchant.create(:name => "Jumpstart Lab")
        expect( merchant.name ).to eq "Jumpstart Lab"
      end
    end

    describe '.find' do
      it "finds a merchant" do
        target = Merchant.create(:name => "Jumpstart Lab")
        found  = Merchant.find( target.id )
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end
    end

    describe '.find_by_name' do
      it "finds a merchant by name" do
        target = Merchant.create(:name => "Jumpstart Lab")
        found  = Merchant.find_by_name("Jumpstart Lab")
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end

      it "finds by name, case insensitive" do
        target = Merchant.create(:name => "Jumpstart Lab")
        found  = Merchant.find_by_name("jumpstart lab")
        expect( found.id ).to eq target.id
        expect( found.name ).to eq target.name
      end
    end

    describe ".random" do
      it "returns a merchant" do
        Merchant.create(:name => "Jumpstart Lab")
        expect( Merchant.random ).to be_kind_of(Merchant)
      end
    end

    it "implements to_hash"
  end
end
