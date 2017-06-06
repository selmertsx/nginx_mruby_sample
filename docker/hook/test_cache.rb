cache = Cache.new(namespace: 'sample', size_mb: 2)
cache["hoge"] = "hage"
Nginx.echo cache["hoge"]
