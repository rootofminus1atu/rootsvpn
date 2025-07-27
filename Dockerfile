FROM tailscale/tailscale:stable

CMD tailscaled --tun=userspace-networking --state=mem: & \
    sleep 2 && \
    tailscale up \
      --authkey=${TS_AUTHKEY} \
      --hostname=${TS_HOSTNAME} \
      --advertise-exit-node \
      --reset && \
    tail -f /dev/null
