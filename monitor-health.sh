#!/bin/bash

echo "=== Argo CD Application Health Monitor ==="
echo "Monitoring application: sample-app-health-monitor"
echo "Press Ctrl+C to stop monitoring"
echo

while true; do
    echo "--- $(date) ---"

    STATUS=$(argocd app get sample-app-health-monitor --output json)

    HEALTH=$(echo "$STATUS" | jq -r '.status.health.status // "Unknown"')
    SYNC=$(echo "$STATUS" | jq -r '.status.sync.status // "Unknown"')
    REVISION=$(echo "$STATUS" | jq -r '.status.sync.revision // "Unknown"')

    echo "Health Status: $HEALTH"
    echo "Sync Status: $SYNC"
    echo "Git Revision: $REVISION"

    OUT_OF_SYNC=$(echo "$STATUS" | jq -r '.status.resources[] | select(.status != "Synced") | .name' 2>/dev/null)
    if [ ! -z "$OUT_OF_SYNC" ]; then
        echo "Out of Sync Resources:"
        echo "$OUT_OF_SYNC"
    fi

    echo "------------------------"
    sleep 10
done
