#!/usr/bin/env bash
# NOTE: If you see errors in logs like 'column ... does not exist' for table 'alerts',
# make sure to add the missing columns (e.g. anomaly_score, krakow_zone) to the alerts table in your migration or manually.
set -euo pipefail

ENVIRONMENT="${1:-dev}"

case "$ENVIRONMENT" in
  dev)
    NAMESPACE="iotag-dev"
    VALUES_FILE="Helm/values-dev.yaml"
    ;;
  sbx)
    NAMESPACE="iotag-sbx"
    VALUES_FILE="Helm/values-sbx.yaml"
    ;;
  *)
    echo "Unsupported environment: $ENVIRONMENT (allowed: dev|sbx)"
    exit 1
    ;;
esac

RELEASE="iot-agent-postgres"

helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update >/dev/null

helm upgrade --install "$RELEASE" bitnami/postgresql \
  -n "$NAMESPACE" \
  --create-namespace \
  -f "$VALUES_FILE" \
  --wait \
  --timeout 15m

echo "Installed: $RELEASE in namespace $NAMESPACE"
echo "Service: ${RELEASE}-postgresql.${NAMESPACE}.svc.cluster.local:5432"
