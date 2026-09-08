# My Home Lab 🧪

A multi-node Kubernetes cluster to manage all my home server goodness,
deployed via GitOps with FluxCD. See [CLAUDE.md](CLAUDE.md) for detailed
architecture and conventions.

## Services

### Core

- [x] FluxCD
- [x] Traefik
- [x] Cert-Manager
- [x] Sealed Secrets

### Networking

- [x] AdGuard Home
- [x] MetalLB
- [x] Unifi Dashboard
- [x] Wireguard

### Security

- [ ] Authentik
- [ ] CrowdSec
- [ ] SOPS
- [x] Vaultwarden

### Observability

- [x] Grafana
- [x] Prometheus
- [x] Node Exporter
- [x] NFS Exporter
- [ ] Loki
- [ ] InfluxDB
- [ ] Uptime Kuma
- [ ] Homer

### Storage

- [x] SyncThing
- [x] Longhorn
- [ ] NextCloud

### Media

#### Automation

- [x] Radarr
- [x] Sonarr
- [ ] Bazarr
- [x] Prowlarr
- [x] Unpackerr
- [x] Transmission

#### Transcoding

- [x] Tdarr

#### Books

- [ ] Calibre Web

#### Photos

- [x] Immich

#### Servers

- [ ] Jellyfin
- [ ] Plex

### Home Automation

- [ ] Home Assistant
- [ ] Mosquitto MQTT Broker

### Games

- [x] Minecraft

## Infrastructure Diagram

TBA

## Deployments

Deployments are automatically handled through FluxCD. All code committed to
`main` is picked up by FluxCD and automatically reconciled to the cluster 🚀
