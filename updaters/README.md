# Updater scripts

Scripts in this directory fetch starlink IP ranges from https://geoip.starlinkisp.net/feed.csv and output configuration files for given formats.

They can be used, for example, in a cron job to update ranges regularly.
```crontab
@weekly /usr/local/bin/starlink-nginx.sh > /etc/nginx/starlink-geoip.tmp && mv /etc/nginx/starlink-geoip.tmp /etc/nginx/starlink-geoip.conf
```

The source seems to be official as it is linked from https://starlink-enterprise-guide.readme.io/docs/ip-addresses, which is itself linked from https://www.starlink.com/business (which is the official site according to wikipedia) as the "buyer's guide".

The file itself isn’t hosted from starlink IPs.
