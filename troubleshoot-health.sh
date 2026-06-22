#!/bin/bash

echo "=== Health Monitoring Troubleshooting ==="
echo

echo "1. Application Status:"
argocd app get sample-app-health-monitor --output json | jq '.status.health, .status.sync'
echo

echo "2. Resource Events:"
kubectl get events --sort-by=.metadata.creationTimestamp -n default | grep problematic-app | tail -10
echo

echo "3. Pod Status:"
kubectl get pods -l app=problematic-app -o wide
echo

echo "4. Pod Logs (if any pods exist):"
PODS=$(kubectl get pods -l app=problematic-app -o jsonpath='{.items[*].metadata.name}')
for pod in $PODS; do
    echo "--- Logs for $pod ---"
    kubectl logs $pod --tail=20 2>/dev/null || echo "No logs available"
done
echo

echo "5. Node Resources:"
kubectl top nodes 2>/dev/null || echo "Metrics server not available"
echo

echo "6. Troubleshooting Recommendations:"
echo "   - Check resource requests vs available cluster resources"
echo "   - Verify health check endpoints are correct"
echo "   - Review application logs for startup issues"
echo "   - Check if images are accessible"
echo "   - Verify network policies and service configurations"
