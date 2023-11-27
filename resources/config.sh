#!/bin/bash

sudo dnf -y install podman socat
#systemctl --user enable --now podman.socket
#loginctl enable-linger 1000
sudo systemctl start podman.socket # systemctl enable podman.socket
sudo systemctl enable podman.socket # systemctl start podman.socket

sudo modprobe iptable-nat
sudo cat > /etc/systemd/system/podman-remote.service <<EOF
[Unit]
Description=Podman Remote
Requires=podman.socket
After=network.target podman.socket

[Service]
Restart=always
ExecStart=socat TCP-LISTEN:2376,reuseaddr,fork,bind=0.0.0.0 unix:/run/podman/podman.sock

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable podman-remote.service
