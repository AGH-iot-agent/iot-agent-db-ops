#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
OUT_DIR="${2:-./backups}"

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

mkdir -p "$OUT_DIR"
RELEASE="iot-agent-postgres"
DB_USER="gte"
DB_NAME="iot_agent"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_FILE="$OUT_DIR/${DB_NAME}-${ENVIRONMENT}-${STAMP}.sql"

POD_NAME="$(kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/instance="$RELEASE" -o jsonpath='{.items[0].metadata.name}')"

kubectl exec -n "$NAMESPACE" "$POD_NAME" -- pg_dump -U "$DB_USER" -d "$DB_NAME" > "$OUT_FILE"

echo "Backup saved: $OUT_FILE"
