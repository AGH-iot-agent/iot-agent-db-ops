#!/usr/bin/env bash
# NOTE: If you see errors in logs like 'column ... does not exist' for table 'alerts',
# make sure to add the missing columns (e.g. anomaly_score, krakow_zone) to the alerts table in your migration or manually.
set -euo pipefail

ENVIRONMENT="${1:-dev}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHART_DIR="$SCRIPT_DIR/../Helm"

case "$ENVIRONMENT" in
  dev)  NAMESPACE="iotag-dev" ;;
  sbx)  NAMESPACE="iotag-sbx" ;;
  *)    echo "Unsupported environment: $ENVIRONMENT (allowed: dev|sbx)"; exit 1 ;;
esac

echo "==> Deploying DB init job to $NAMESPACE..."
helm upgrade --install iot-agent-db-ops "$CHART_DIR" \
  -f "$CHART_DIR/values-${ENVIRONMENT}.yaml" \
  -n "$NAMESPACE" \
  --wait

echo "==> Done. Job logs:"
kubectl logs -n "$NAMESPACE" \
  -l app=iot-agent-db-ops-init \
  --tail=50 2>/dev/null || true
