FROM gcc:9.1.0 AS builder_single_query
WORKDIR /gcc/src/tfb/C/nginx-dynamic-modules
RUN curl --location --remote-name https://github.com/nginx/nginx/archive/release-1.17.2.tar.gz
RUN tar xvzf release-1.17.2.tar.gz
WORKDIR /gcc/src/tfb/C/nginx-dynamic-modules/modules
COPY ./modules/single_query/ ./single_query/
WORKDIR /gcc/src/tfb/C/nginx-dynamic-modules/nginx-release-1.17.2

RUN ./auto/configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-g -O2 -fdebug-prefix-map=/data/builder/debuild/nginx-1.17.2/debian/debuild-base/nginx-1.17.2=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' --add-dynamic-module=../modules/single_query
RUN make modules

FROM nginx:1.17.2
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder_single_query \
  /gcc/src/tfb/C/nginx-dynamic-modules/nginx-release-1.17.2/objs/ngx_http_single_query_module.so \
  /etc/nginx/modules/
