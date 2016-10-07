# NGINX

* **NGINX**
  * [Core module](http://nginx.org/en/docs/ngx_core_module.html)
  * [HTTP Core module documentation](http://nginx.org/en/docs/http/ngx_http_core_module.html)
  * [Rewrite module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite)
  * [Common configuration pitfalls](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/)


## Reviewing features

### What was the build command

    nginx -V 2>&1 | grep -- '--with-debug'
    configure arguments: --with-cc-opt='-g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-ipv6 --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_addition_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_mp4_module --with-http_perl_module --with-http_random_index_module --with-http_secure_link_module --with-http_v2_module --with-http_sub_module --with-http_xslt_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-threads --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/headers-more-nginx-module --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/nginx-auth-pam --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/nginx-cache-purge --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/nginx-dav-ext-module --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/nginx-development-kit --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/nginx-echo --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/ngx-fancyindex --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/nginx-http-push --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/nginx-lua --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/nginx-upload-progress --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/nginx-upstream-fair --add-module=/build/nginx-3I6R0c/nginx-1.10.1/debian/modules/ngx_http_substitutions_filter_module

## TLS

* https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
* https://cipherli.st/
* http://www.bsdnow.tv/tutorials/nginx


## See also:

* https://github.com/kevva/states/blob/master/nginx/
* [Difference between NGINX versions](https://gist.github.com/jpetazzo/1152774)
* [Strong SSL security on NGINX](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)
* http://nginx.org/en/docs/http/ngx_http_core_module.html#variables
* http://www.cyberciti.biz/faq/custom-nginx-maintenance-page-with-http503/
* [All static files will be served directly?](http://stackoverflow.com/questions/19515132/nginx-cache-static-files#answer-20843725)
* https://www.varnish-cache.org/docs/3.0/tutorial/websockets.html
* http://thruflo.com/post/23226473852/websockets-varnish-nginx
