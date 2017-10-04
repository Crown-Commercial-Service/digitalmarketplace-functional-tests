#!/bin/sh

varnishd -a :80 -T localhost:6082 -f /etc/varnish/default.vcl -S /etc/varnish/secret -s malloc,256m;
/usr/sbin/nginx -g "daemon off;"
