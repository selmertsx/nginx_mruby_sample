class MySQLProxy
  def initialize(host, user, password, database)
    @host = host
    @user = user
    @password = password
    @database = database
  end

  def find_by_id(id)
    rows = []
    db.execute("SELECT * FROM endpoints WHERE id = ?", id) { |row, fields| rows << row }
    rows.first
  end

  def close
    db.close
  end

  private
  def db
    @db ||= MySQL::Database.new(@host, @user, @password, @database)
  end

  def cache
    @cache ||= Cache.new(namespace: 'sample', size_mb: 2)
  end
end

proxy = MySQLProxy.new('db', 'root', '', 'revieee_app_development')
rows = proxy.find_by_id(1);
Nginx.echo rows
proxy.close
