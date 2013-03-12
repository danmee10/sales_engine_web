Sequel.migration do
  change do
    create_table :merchants do
      primary_key :id
      String :name
      Datetime :created_at
      Datetime :updated_at 
    end
  end
end