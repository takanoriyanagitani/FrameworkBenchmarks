FROM gcc:9.2.0 AS builder_test2query1
WORKDIR /gcc/9.2.0/nginx-dynamic-modules
RUN curl --location --remote-name https://github.com/nginx/nginx/archive/release-1.17.3.tar.gz
RUN tar xvzf release-1.17.3.tar.gz
WORKDIR /gcc/9.2.0/nginx-dynamic-modules/modules
COPY ./modules/test2query1/ ./test2query1/
WORKDIR /gcc/9.2.0/nginx-dynamic-modules/nginx-release-1.17.3

RUN ./auto/configure --add-dynamic-module=../modules/test2query1 --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-g -O2 -fdebug-prefix-map=/data/builder/debuild/nginx-1.17.3/debian/debuild-base/nginx-1.17.3=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie -lpq'

RUN make modules

FROM nginx:1.17.3
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=builder_test2query1 \
  /gcc/9.2.0/nginx-dynamic-modules/nginx-release-1.17.3/objs/ngx_http_test2query1_module.so \
  /etc/nginx/modules/
