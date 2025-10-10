# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a GitOps-based Kubernetes homelab repository that uses FluxCD for continuous deployment. All infrastructure is defined as code in YAML files, and changes pushed to the main branch are automatically deployed to the cluster.

## Architecture

- **GitOps Pattern**: FluxCD monitors this Git repository and automatically applies changes to the Kubernetes cluster
- **Directory Structure**:
  - `/apps/` - Kubernetes application manifests (each app has its own directory)
  - `/clusters/homelab/` - Cluster-specific FluxCD configurations that register apps with Flux
  - `/namespaces/` - Kubernetes namespace definitions
- **Deployment Flow**: Git push → FluxCD detects change → Kubernetes resources updated automatically
- **Namespaces**: Most apps deploy to `infra` namespace, some use `app` namespace, MetalLB uses `metallb-system`

## Common Commands

### Adding a New Application

1. Create the app directory and manifests:
```bash
mkdir -p apps/<app-name>
# Create deployment.yaml, service.yaml, ingress.yaml (if needed), pvc.yaml (if needed)
```

2. Create kustomization.yaml in the app directory:
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: infra  # Optional: set default namespace for all resources
resources:
  - deployment.yaml
  - service.yaml
  - ingress.yaml  # if needed
  - pvc.yaml      # if needed
```

3. Register the app with FluxCD in `clusters/homelab/<app-name>.yaml`:
```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: <app-name>
  namespace: flux-system
spec:
  interval: 1m
  path: ./apps/<app-name>
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  targetNamespace: infra  # Target namespace for resources
```

### Deploying Changes

```bash
git add .
git commit -m "feat: add <description>"
git push origin main
# FluxCD automatically applies changes within 1 minute
```

### Monitoring Deployments

```bash
# Check FluxCD reconciliation status
kubectl get kustomizations -n flux-system
flux reconcile kustomization <app-name>  # Force immediate reconciliation

# Check app deployments
kubectl get deployments -n infra
kubectl get pods -n infra

# View FluxCD logs for troubleshooting
kubectl logs -n flux-system deployment/kustomize-controller -f
kubectl logs -n flux-system deployment/source-controller -f

# Check all resources in a namespace
kubectl get all -n infra
```

### Validating Changes

```bash
# Validate Kubernetes YAML syntax before committing
kubectl --dry-run=client -f apps/<app-name>/deployment.yaml

# Build and preview kustomization output
kubectl kustomize apps/<app-name>/

# Check FluxCD kustomization errors
kubectl describe kustomization <app-name> -n flux-system
```

## Key Development Patterns

1. **GitOps Workflow**: All changes must be committed to Git. FluxCD automatically deploys from the main branch.

2. **Standard App Structure**:
   - `apps/<app-name>/deployment.yaml` - Kubernetes deployment
   - `apps/<app-name>/service.yaml` - Service definition
   - `apps/<app-name>/kustomization.yaml` - Kustomize configuration
   - `apps/<app-name>/ingress.yaml` - Optional: Ingress for external access
   - `apps/<app-name>/pvc.yaml` - Optional: PersistentVolumeClaim for storage
   - `clusters/homelab/<app-name>.yaml` - FluxCD kustomization registration

3. **Traefik Integration**: Apps using Traefik for ingress should include:
   - IngressRoute resources for Traefik CRDs
   - Middleware configurations for HTTPS redirect, authentication, etc.
   - Backend services configuration

4. **Resource Dependencies**: FluxCD kustomizations don't typically need explicit namespace dependencies as namespaces are pre-created.

## Current Applications

- **Traefik** - Reverse proxy and ingress controller (migrating from legacy Docker deployment)
- **MetalLB** - Bare metal load balancer for Kubernetes
- **Wireguard** - VPN service
- **Syncthing** - File synchronization
- **Vaultwarden** - Password manager
- **Transmission** - BitTorrent client

## Legacy Infrastructure

A legacy Traefik instance runs on host 192.168.0.210 (port 8080/8443) using Docker Compose. The Kubernetes Traefik deployment includes fallback routes to this legacy instance for services not yet migrated.