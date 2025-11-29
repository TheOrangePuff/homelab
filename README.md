# My Home Lab 🧪

A multi-node Kubernetes cluster to manage all my home server goodness.

## Services

### Core

- [x] FluxCD
- [x] Traefik
- [x] Cert-Manager
- [x] Sealed Secrets

### Networking

- [ ] AdGuard Home
- [x] MetalLB
- [x] Unifi Dashboard
- [x] Wireguard

### Security

- [ ] Authentik
- [ ] CrowdSec
- [ ] SOPS
- [ ] Vaultwarden

### Observability

- [ ] Grafana
- [ ] Prometheus
- [ ] Loki
- [ ] InfluxDB
- [ ] Uptime Kuma
- [ ] Homer

### Storage

- [x] SyncThing
- [x] Longhorn
- [ ] NextCloud

### Backups

- [ ] Restic
- [ ] Velero

### Media

#### Automation

- [ ] Radarr
- [ ] Sonarr
- [ ] Bazarr
- [ ] Prowlarr
- [x] Transmission

#### Books

- [ ] Calibre Web

#### Photos

- [ ] Immich

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

## Deploymnets

Deployments are automatically handled through FluxCD. All code committed to main is picked up by FluxCD and automatically published to my cluster 🚀
