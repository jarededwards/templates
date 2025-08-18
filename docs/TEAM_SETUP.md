# Team Setup Guide

## Creating a New Team Configuration

### 1. Define Team Metadata

Create `/teams/{your-team}/metadata.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: TeamMetadata
metadata:
  name: your-team
  displayName: "Your Team Display Name"
  description: "Description of your team's requirements"
spec:
  extends: default  # Or another team to inherit from
  components:
    - name: cert-manager
      enabled: true
      overrides:
        replicaCount: 2
```

### 2. Add Component Overrides

For each component you want to customize, create:
`/teams/{your-team}/components/{component}/values.yaml`

### 3. Test Your Configuration

Use the konstruct-api to test your team configuration:

```bash
konstruct-api templates preview --team your-team --dry-run
```