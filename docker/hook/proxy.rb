class MySQLProxy
  def initialize(host, user, password, database)
    @host = host
    @user = user
    @password = password
    @database = database
  end

  def select(query)
    rows = []
    db.execute(query) { |row, fields| rows << row }
    rows
  end

  def close
    db.close
  end

  private
  def db
    @db ||= MySQL::Database.new('db', 'root', '', 'information_schema')
  end
end

proxy = MySQLProxy.new('db', 'root', '', 'information_schema')
rows = proxy.select("select * from TABLES")
Nginx.echo rows
proxy.close
