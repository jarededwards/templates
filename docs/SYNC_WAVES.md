# Argo CD Sync Wave Order

This document describes the sync wave order for all components to ensure proper deployment dependencies.

## Sync Wave Order

This order matches the Konstruct API deployment strategy as defined in `/docs/deployment-order.md`.

| Wave | Component | Description | Reason |
|------|-----------|-------------|---------|
| 10 | external-secrets | External Secrets Operator | Must deploy first for secrets management |
| 20 | cert-manager | Certificate Manager | Required for TLS certificate generation |
| 30 | cert-manager-issuers | Let's Encrypt Issuers | Deploys after cert-manager is ready |
| 40 | external-dns | External DNS | DNS management before ingress |
| 50 | ingress-nginx | NGINX Ingress Controller | Network ingress after DNS setup |
| 60 | crossplane | Cloud Infrastructure | Infrastructure management capabilities |
| 70 | workload-cluster | Application Workloads | Applications deploy last |

**Note**: The API also includes wait jobs at +1 wave numbers (11, 21, 31, 41, 51) to ensure readiness between deployments.

## Standardized Labels and Annotations

All Argo CD applications include these standardized labels and annotations:

### Labels
```yaml
labels:
  konstruct.io/cluster: "{{ .clusterName }}"
  konstruct.io/team: "{{ .teamName | default "default" }}"
  konstruct.io/component: "<component-name>"
```

### Annotations
```yaml
annotations:
  konstruct.io/created-by: "konstruct-api"
  argocd.argoproj.io/sync-wave: "<wave-number>"
```

## Benefits

1. **Ordered Deployment**: Components deploy in the correct dependency order
2. **Cluster Identification**: Easy to identify which cluster resources belong to
3. **Team Management**: Clear ownership and team association
4. **Component Tracking**: Identify which component an application belongs to
5. **API Attribution**: Track which applications were created by the Konstruct API

## Modifying Sync Waves

When adding new components, consider their dependencies:

- **Infrastructure components** (secrets, certificates): Lower wave numbers (0-10)
- **Platform components** (ingress, DNS): Medium wave numbers (15-25)  
- **Application components** (workloads): Higher wave numbers (30+)

Ensure dependencies are respected by assigning appropriate wave numbers.