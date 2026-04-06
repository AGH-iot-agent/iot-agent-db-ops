#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
DUMP_FILE="${2:-}"

if [[ -z "$DUMP_FILE" ]]; then
  echo "Usage: $0 <dev|sbx> <dump-file.sql>"
  exit 1
fi

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

kubectl cp "$DUMP_FILE" "$NAMESPACE/$POD_NAME:/tmp/restore.sql"
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- psql -U "$DB_USER" -d "$DB_NAME" -f /tmp/restore.sql

echo "Restore complete from $DUMP_FILE"
