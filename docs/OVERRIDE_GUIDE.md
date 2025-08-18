# Override Mechanism Guide

## Override Hierarchy

Templates are resolved in the following order:

1. **Component Base Templates**: `/{component}/*.yaml.tmpl`
2. **Team Overrides**: `/teams/{team}/components/{component}/`
3. **Runtime Values**: Provided via API during cluster creation

## Override File Structure

### values.yaml

Used for Helm value overrides:

```yaml
replicaCount: 3
resources:
  requests:
    cpu: 100m
    memory: 128Mi
```

### patches/

For Kustomize-style patches (future enhancement):

```yaml
- op: replace
  path: /spec/replicas
  value: 3
```

## Merging Strategy

- Deep merge for objects
- Replace for arrays
- Later values override earlier ones