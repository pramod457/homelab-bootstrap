# homelab-bootstrap v1.0.0

## Scope

v1.0.0 is a safe Ubuntu homelab / AI workstation bootstrap and verification toolkit.

It verifies:

- Ubuntu baseline
- UFW / Fail2Ban security posture
- Tailscale-only SSH readiness
- Docker Engine
- Docker Compose
- NVIDIA GPU readiness
- NVIDIA container runtime readiness
- Azure Arc
- Azure Monitor Agent
- Safe Ubuntu package updates
- Caddy readiness
- Cloudflare Tunnel readiness
- Local exposure risks

## Safety boundaries

v1.0.0 does not automatically:

- open router ports
- change DNS
- expose private apps
- create Cloudflare tunnels
- store provider credentials
- run autoremove
- run dist-upgrade/full-upgrade

## Main commands

homelab-bootstrap menu
homelab-bootstrap v1 --verify
homelab-bootstrap exposure --verify
homelab-bootstrap caddy --verify
homelab-bootstrap cloudflare-tunnel --verify
