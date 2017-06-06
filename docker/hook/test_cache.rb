cache = Cache.new(namespace: 'sample', size_mb: 2)
cache["hoge"] = "hage"

db = MySQL::Database.new('db', 'root', '', 'information_schema')

db.execute('select * from TABLES') do |row, fields|
  Nginx.echo row
end

Nginx.echo cache["hoge"]
