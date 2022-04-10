#!/bin/bash
#
# Author: David Deng
# Url: https://e5.covear.top

ssl_url="/www/server/panel/vhost/cert/e5.covear.top"
web_root="/www/wwwroot/renewx"
need=false

echo "[ WEBROOT: ${web_root} ]"
cd ${web_root}/Deploy
echo "[ ADDR: `pwd` ]"

if [ -f ./privkey.pem ] 
then
echo "[ FOUND privkey.pem ]"
else 
cp ${ssl_url}/privkey.pem ./
echo "[ GET privkey.pem ]"
need=true
fi

if [ -f ./fullchain.pem ] 
then
echo "[ FOUND fullchain.pem ]"
else 
cp ${ssl_url}/fullchain.pem ./
echo "[ GET fullchain.pem ]"
need=true
fi

if [ ./privkey.pem -nt ${ssl_url}/privkey.pem ]
then 
echo "[ LATEST ./privkey.pem ]"
else 
echo "[ LATEST ${ssl_url}/privkey.pem ]"
need=true
fi

if [ ./fullchain.pem -nt ${ssl_url}/fullchain.pem ]
then
echo "[ LATEST ./fullchain.pem ]"
else
echo "[ LATEST ${ssl_url}/fullchain.pem ]"
need=true
fi

if $need 
then
echo "[ CREATE ./renewx.pfx ]"
openssl pkcs12 -passout pass:12345678 -export -out renewx.pfx -inkey privkey.pem -in fullchain.pem
echo "[ GET ./renewx.pfx ]"
else 
echo "[ LATEST ./renewx.pfx ]"
fi

exit
