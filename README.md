# My Home Lab 🧪

A multi-node Kubernetes cluster to manage all my home server goodness.

## Services

### Core

- [x] FluxCD
- [x] Traefik

### Networking

- [ ] AdGuard Home
- [x] MetalLB
- [x] Unifi Dashboard
- [] Wireguard (WIP)

### Security

- [ ] Authentik
- [ ] CrowdSec
- [ ] SOPS
- [x] Vaultwarden

### Observability

- [ ] Grafana
- [ ] Prometheus
- [ ] Loki
- [ ] InfluxDB
- [ ] Uptime Kuma
- [ ] Homer

### Storage

- [x] SyncThing
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

- [ ] Minecraft


## Infrastructure Diagram

TBA

## Deploymnets

Deployments are automatically handled through FluxCD. All code committed to main is picked up by FluxCD and automatically published to my cluster 🚀
