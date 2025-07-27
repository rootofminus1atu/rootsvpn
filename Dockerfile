FROM tailscale/tailscale:stable

RUN apk add --no-cache curl tar wget && \
    wget https://github.com/caddyserver/caddy/releases/download/v2.8.4/caddy_2.8.4_linux_amd64.tar.gz && \
    tar -xzf caddy_2.8.4_linux_amd64.tar.gz && \
    mv caddy /usr/bin/caddy && \
    chmod +x /usr/bin/caddy && \
    rm -f caddy_2.8.4_linux_amd64.tar.gz LICENSE README.md

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
