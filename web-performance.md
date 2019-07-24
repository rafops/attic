# Web Performance

## cURL

```
date
while [ 1 ] ; do
  curl -w '%{time_namelookup},%{time_connect},%{time_appconnect},%{time_pretransfer},%{time_redirect},%{time_starttransfer},%{time_total}\n' -o /dev/null -s "https://example.com/fitter_happier/site_and_database_check"
done
date
```

## ab

```
date
time ab -n 1000 "https://example.com/fitter_happier/site_and_database_check"
date
```

## sitespeed.io

```
docker run --rm -v "$(pwd)":/sitespeed.io sitespeedio/sitespeed.io:9.6.0 https://example.com/fitter_happier/site_and_database_check
open sitespeed-result/example.com/*/index.html
```
