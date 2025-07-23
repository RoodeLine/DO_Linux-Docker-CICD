FROM nginx:latest

USER root

COPY ../nginx/nginx.conf /etc/nginx/nginx.conf

COPY ../server/server.c /home/server.c

COPY 04/server_run.sh /home/

RUN apt-get update \
    && apt-get install -y  gcc spawn-fcgi libfcgi-dev

WORKDIR /home/

CMD ["bash", "server_run.sh"]
