# 確認環境の構築

```
docker-compose build
docker-compose up
```

# 動作の確認
```
curl http://127.0.0.1/mruby-cache
curl http://127.0.0.1/mruby-cache-response
```

# 変更の反映

```
docker exec -it nginx_mruby_container /usr/local/nginx/sbin/nginx -s reload
```
