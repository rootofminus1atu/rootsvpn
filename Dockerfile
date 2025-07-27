FROM tailscale/tailscale:stable

RUN apk add --no-cache curl && \
    curl -fsSL https://caddyserver.com/api/download?os=linux&arch=amd64 | tar -xz -C /usr/bin --strip-components=1 caddy && \
    chmod +x /usr/bin/caddy

RUN mkdir -p /srv && echo '<!DOCTYPE html><html><body><h1>it works</h1></body></html>' > /srv/index.html

RUN echo ":8080 {\n root * /srv\n file_server\n}" > /etc/caddy/Caddyfile

EXPOSE 8080

CMD tailscaled --tun=userspace-networking --state=mem: & \
    sleep 2 && \
    tailscale up \
      --authkey=${TS_AUTHKEY} \
      --hostname=${TS_HOSTNAME} \
      --advertise-exit-node \
      --reset && \
    tail -f /dev/null
