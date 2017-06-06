cache = Cache.new(namespace: 'sample', size_mb: 2)
puts cache["hoge"]
Nginx.echo cache["hoge"]
