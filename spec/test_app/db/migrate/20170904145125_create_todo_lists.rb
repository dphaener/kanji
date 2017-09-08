ROM::SQL.migration do
  change do
    create_table :todo_lists do
      primary_key :id
      column :title, String, null: false
      column :description, String
      foreign_key :user_id, :users
    end
  end
end
