# Vaultwarden Admin Panel Access

## Accessing the Admin Panel

1. Navigate to: https://bitwarden.theorangeserver.net/admin
2. Enter the admin token when prompted

## Admin Token

The admin token is stored as a SealedSecret and automatically injected into the container.

To retrieve the current token (if you have cluster access):
```bash
kubectl get secret vaultwarden-admin -n app -o jsonpath='{.data.token}' | base64 -d
```

## Updating the Admin Token

To generate and set a new admin token:
```bash
# Generate a new secure token
NEW_TOKEN=$(openssl rand -base64 48)

# Create new sealed secret
kubectl create secret generic vaultwarden-admin \
  --namespace=app \
  --from-literal=token="$NEW_TOKEN" \
  --dry-run=client -o yaml | kubeseal \
  --controller-namespace=kube-system \
  --controller-name=sealed-secrets-controller \
  -o yaml > admin-sealed-secret.yaml

# Commit and push
git add admin-sealed-secret.yaml
git commit -m "chore: rotate admin token"
git push

# Restart Vaultwarden to use new token
kubectl rollout restart deployment vaultwarden -n app
```

## Security Notes

- Admin panel is protected by token authentication
- Public signups are disabled (SIGNUPS_ALLOWED=false)
- Only use the admin panel over HTTPS
- Keep the admin token secure and rotate it periodically