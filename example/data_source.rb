data_source 'redash-db' do
  name 'redash-db'
  type 'pg'
  options do
    host 'postgres'
    user 'postgres'
    dbname 'postgres'
  end
end
