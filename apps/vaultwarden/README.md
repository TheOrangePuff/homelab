# Vaultwarden Backup Configuration

## Setup Instructions for Backblaze B2

1. **Set up Backblaze B2**
   
   a. Log into your Backblaze account
   b. Create a new private bucket (e.g., `my-vaultwarden-backups`)
   c. Create an Application Key:
      - Go to App Keys
      - Add a New Application Key
      - Name: `vaultwarden-backup`
      - Allow access to your bucket only
      - Note down the `keyID` and `applicationKey` (shown only once!)
   d. Note your bucket's region (e.g., `us-west-002`)

2. **Configure Backup Credentials**
   
   The credentials are stored as a SealedSecret. To update them:
   - `repository`: `s3:s3.<region>.backblazeb2.com/<bucket-name>/vaultwarden`
   - `password`: Strong password for restic encryption (not your B2 password!)
   - `aws-access-key-id`: Your B2 Application Key ID
   - `aws-secret-access-key`: Your B2 Application Key
   - `aws-region`: Your bucket's region

   To update credentials:
   ```bash
   kubectl create secret generic vaultwarden-backup-config \
     --namespace=app \
     --from-literal=repository="s3:s3.<region>.backblazeb2.com/<bucket>/vaultwarden" \
     --from-literal=password="your-restic-password" \
     --from-literal=aws-access-key-id="your-b2-key-id" \
     --from-literal=aws-secret-access-key="your-b2-app-key" \
     --from-literal=aws-region="your-region" \
     --dry-run=client -o yaml | kubeseal \
     --controller-namespace=kube-system \
     --controller-name=sealed-secrets-controller \
     -o yaml > backup-sealed-secret.yaml
   ```
   
   Current configuration:
   - Bucket: theorangeserver-vaultwarden
   - Region: us-west-000
   - Credentials are encrypted in SealedSecret

2. **Deploy the backup system**
   ```bash
   git add .
   git commit -m "feat: add restic backup system for Vaultwarden"
   git push
   flux reconcile kustomization vaultwarden
   ```

3. **Test the backup**
   ```bash
   # Manually trigger a backup
   kubectl create job --from=cronjob/vaultwarden-backup vaultwarden-backup-test -n app
   
   # Check logs
   kubectl logs -n app -l job-name=vaultwarden-backup-test
   ```

## Restore Process

1. **List available snapshots**
   ```bash
   kubectl exec -n app deployment/vaultwarden -- restic snapshots
   ```

2. **Restore from backup**
   ```bash
   # Scale down Vaultwarden
   kubectl scale deployment vaultwarden -n app --replicas=0
   
   # Run restore job (latest snapshot)
   kubectl apply -f restore-restic-job.yaml -n app
   
   # Or restore specific snapshot
   kubectl set env job/vaultwarden-restore SNAPSHOT_ID=abc12345 -n app
   
   # Check restore logs
   kubectl logs -n app job/vaultwarden-restore
   
   # Scale back up
   kubectl scale deployment vaultwarden -n app --replicas=1
   ```

## Switching to Different Backup Backends

To switch from S3 to another backend, simply update the `backup-secret.yaml`:

### SFTP Example
```yaml
repository: "sftp:user@backup-server:/backups/vaultwarden"
# Remove AWS credentials, add SSH key if needed
```

### REST Server Example
```yaml
repository: "rest:https://rest-server.local/vaultwarden"
# Add REST server credentials
```

### Local NFS Example
```yaml
repository: "/nfs-mount/backups/vaultwarden"
# No cloud credentials needed
```

## Backup Schedule

- **Hourly**: 24 most recent hourly backups
- **Daily**: 7 daily backups
- **Weekly**: 4 weekly backups  
- **Monthly**: 3 monthly backups

All backups are encrypted with the restic password before being sent to S3.