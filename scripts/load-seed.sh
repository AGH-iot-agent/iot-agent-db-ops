#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"

case "$ENVIRONMENT" in
  dev)
    NAMESPACE="iotag-dev"
    ;;
  sbx)
    NAMESPACE="iotag-sbx"
    ;;
  *)
    echo "Unsupported environment: $ENVIRONMENT (allowed: dev|sbx)"
    exit 1
    ;;
esac

RELEASE="iot-agent-postgres"
DB_USER="gte"
DB_NAME="iot_agent"

POD_NAME="$(kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/instance="$RELEASE" -o jsonpath='{.items[0].metadata.name}')"

kubectl cp sql/00-schema.sql "$NAMESPACE/$POD_NAME:/tmp/00-schema.sql"
kubectl cp sql/10-seed-dev.sql "$NAMESPACE/$POD_NAME:/tmp/10-seed-dev.sql"

kubectl exec -n "$NAMESPACE" "$POD_NAME" -- psql -U "$DB_USER" -d "$DB_NAME" -f /tmp/00-schema.sql
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- psql -U "$DB_USER" -d "$DB_NAME" -f /tmp/10-seed-dev.sql

echo "Schema and seed loaded into $DB_NAME ($NAMESPACE)"
