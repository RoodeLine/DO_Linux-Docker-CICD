FROM nginx:latest

WORKDIR /home/

USER root

COPY nginx.conf /etc/nginx/nginx.conf

COPY server.c /home/server.c

COPY server_run.sh /home/server_run.sh

RUN apt-get update \
    && apt-get install -y gcc spawn-fcgi libfcgi-dev \
    && rm -rf /var/lib/apt/lists/* \
    && chown -R nginx:nginx /etc/nginx/nginx.conf \
    && chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /home \
    && touch /var/run/nginx.pid \
    && chown -R nginx:nginx /var/run/nginx.pid \
    && chmod g-s /usr/bin/expiry \
    && chmod u-s /usr/bin/passwd \
    && chmod u-s /usr/bin/newgrp \
    && chmod g-s /sbin/unix_chkpwd \
    && chmod g-s /usr/bin/wall \
    && chmod u-s /bin/umount \
    && chmod u-s /usr/bin/gpasswd \
    && chmod g-s /usr/bin/chage \
    && chmod u-s /bin/mount \
    && chmod u-s /usr/bin/chfn \
    && chmod u-s /usr/bin/chsh \
    && chmod u-s /bin/su \
    && chmod +x /home/server_run.sh

USER nginx

HEALTHCHECK --interval=4m --timeout=3s \
    CMD curl --fail http://localhost/ || exit 1

ENTRYPOINT ["bash", "server_run.sh"]
