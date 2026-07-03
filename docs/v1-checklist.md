# V1 checklist

This repo is considered V1-ready when the following installed commands pass:

```bash
homelab-bootstrap doctor
homelab-bootstrap docker --verify
homelab-bootstrap nvidia --verify
homelab-bootstrap tailscale --verify
homelab-bootstrap azure-arc --verify
homelab-bootstrap azure-monitor --verify

Safety rules:

No secrets in the repo.
No Tailscale auth keys in the repo.
No Azure service principal secrets in the repo.
NVIDIA module verifies only; it does not install drivers.
Azure modules verify only; they do not onboard or create cloud resources.
Docker user group access is optional because it is root-equivalent.


## v1.0.0 final checklist

- [x] Doctor command
- [x] JSON doctor smoke test
- [x] Security baseline module
- [x] Safe update module using apt-get
- [x] Docker module
- [x] NVIDIA verification module
- [x] Tailscale module
- [x] Azure Arc module
- [x] Azure Monitor module
- [x] Interactive menu
- [x] Caddy readiness module
- [x] Cloudflare Tunnel readiness module
- [x] Exposure audit module
- [x] V1 verification command
- [x] Installer resets stale repo remote
- [x] Basic secret scan

