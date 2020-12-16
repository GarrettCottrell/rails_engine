require 'csv'
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails_engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)
csv_text = File.read(Rails.root.join("db", "data", "items.csv"))
csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
csv.each do |row|
  i = Item.new
  i.id = row["id"]
  i.name = row["name"]
  i.description = row["description"]
  i.unit_price = (row["unit_price"].to_f / 100).round(2)
  i.merchant_id = row["merchant_id"]
  i.created_at = row["created_at"]
  i.updated_at = row["updated_at"]
  i.save
end
puts "There are now #{Item.count} rows in the items table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end