# Templates Repository Migration Guide (Revised)

## Overview
This guide provides step-by-step instructions for enhancing the https://github.com/jarededwards/templates repository to support multi-company team-based template management while keeping templates in their original locations.

## Migration Steps

### Step 1: Create Directory Structure

Create the following directories in the repository root:

```bash
# Create team directories
mkdir -p teams/default/components
mkdir -p teams/konstruct/components
mkdir -p teams/mobile-team/components

# Create docs directory
mkdir -p docs

# Create schemas directories for each component
mkdir -p cert-manager/schemas
mkdir -p external-dns/schemas
mkdir -p external-secrets/schemas
mkdir -p ingress-nginx/schemas
mkdir -p cert-manager-issuers/schemas
mkdir -p crossplane/schemas
mkdir -p workload-cluster/schemas
```

### Step 2: Keep Existing Templates in Place

All existing `.yaml.tmpl` files remain in their component root directories:
- `cert-manager/*.yaml.tmpl`
- `external-dns/*.yaml.tmpl`
- `external-secrets/*.yaml.tmpl`
- `ingress-nginx/*.yaml.tmpl`
- `cert-manager-issuers/*.yaml.tmpl`
- `crossplane/*.yaml.tmpl`
- `workload-cluster/*.yaml.tmpl`

### Step 3: Create Repository Metadata File

Create `/metadata.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: RepositoryMetadata
metadata:
  name: konstruct-templates
  description: "Konstruct platform templates repository"
  version: "1.0.0"
spec:
  defaultTeam: default
  templatesVersion: "v1alpha1"
  maintainers:
    - name: "Platform Team"
      email: "platform@example.com"
```

### Step 4: Create Repository Index

Create `/index.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: TemplateIndex
metadata:
  name: template-index
  version: "1.0.0"
spec:
  components:
    - name: cert-manager
      path: cert-manager/
      description: "X.509 certificate management for Kubernetes"
      availableInTeams: ["default", "konstruct", "mobile-team"]
    - name: cert-manager-issuers
      path: cert-manager-issuers/
      description: "Certificate issuers for cert-manager"
      availableInTeams: ["default", "konstruct", "mobile-team"]
    - name: external-dns
      path: external-dns/
      description: "Synchronize exposed Kubernetes Services and Ingresses with DNS providers"
      availableInTeams: ["default", "konstruct", "mobile-team"]
    - name: external-secrets
      path: external-secrets/
      description: "Integrate external secret management systems"
      availableInTeams: ["default", "konstruct", "mobile-team"]
    - name: ingress-nginx
      path: ingress-nginx/
      description: "NGINX Ingress Controller for Kubernetes"
      availableInTeams: ["default", "konstruct", "mobile-team"]
    - name: crossplane
      path: crossplane/
      description: "Cloud Native Control Planes"
      availableInTeams: ["default", "konstruct"]
    - name: workload-cluster
      path: workload-cluster/
      description: "Workload cluster configuration"
      availableInTeams: ["default", "konstruct"]
  teams:
    - name: default
      path: teams/default/
      description: "Default team configuration with standard settings"
    - name: konstruct
      path: teams/konstruct/
      description: "Konstruct platform team with enhanced configurations"
    - name: mobile-team
      path: teams/mobile-team/
      description: "Mobile team optimized for mobile backend services"
```

### Step 5: Create Component Metadata Files

For each component, create a `metadata.yaml` file in the component's root directory:

#### `/cert-manager/metadata.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: ComponentMetadata
metadata:
  name: cert-manager
  description: "X.509 certificate management for Kubernetes"
spec:
  version: "v1.15.3"
  chart:
    repository: "https://charts.jetstack.io"
    name: "cert-manager"
    version: "v1.15.3"
  dependencies: []
  templates:
    - name: "cert-manager.yaml.tmpl"
      description: "Main cert-manager deployment"
  inputs:
    - name: replicaCount
      type: integer
      description: "Number of cert-manager replicas"
      default: 1
      validation:
        min: 1
        max: 10
    - name: webhook.replicaCount
      type: integer
      description: "Number of webhook replicas"
      default: 1
    - name: cainjector.replicaCount
      type: integer
      description: "Number of cainjector replicas"
      default: 1
    - name: cloudProvider
      type: string
      description: "Cloud provider for workload identity"
      enum: ["aws", "gcp", "azure", "none"]
      default: "none"
    - name: serviceAccount.annotations
      type: object
      description: "Annotations for the service account"
      default: {}
```

#### `/external-dns/metadata.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: ComponentMetadata
metadata:
  name: external-dns
  description: "Synchronize exposed Kubernetes Services and Ingresses with DNS providers"
spec:
  version: "v0.14.2"
  chart:
    repository: "https://kubernetes-sigs.github.io/external-dns"
    name: "external-dns"
    version: "1.14.5"
  dependencies:
    - external-secrets  # For provider credentials
  templates:
    - name: "external-dns.yaml.tmpl"
      description: "External DNS controller deployment"
  inputs:
    - name: provider
      type: string
      description: "DNS provider"
      enum: ["route53", "cloudflare", "cloudDNS", "azureDNS", "civo"]
      required: true
    - name: domainFilters
      type: array
      description: "Limit possible target zones by domain suffixes"
      items:
        type: string
      default: []
    - name: sources
      type: array
      description: "K8s resources to monitor for DNS entries"
      items:
        type: string
        enum: ["service", "ingress", "crd"]
      default: ["ingress"]
    - name: cloudProvider
      type: string
      description: "Cloud provider for workload identity"
      enum: ["aws", "gcp", "azure", "civo", "none"]
      default: "none"
    - name: serviceAccount.annotations
      type: object
      description: "Annotations for the service account"
      default: {}
```

#### `/external-secrets/metadata.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: ComponentMetadata
metadata:
  name: external-secrets
  description: "Integrate external secret management systems"
spec:
  version: "v0.10.5"
  chart:
    repository: "https://charts.external-secrets.io"
    name: "external-secrets"
    version: "0.10.5"
  dependencies: []
  templates:
    - name: "external-secrets-operator.yaml.tmpl"
      description: "External Secrets Operator deployment"
  inputs:
    - name: replicaCount
      type: integer
      description: "Number of controller replicas"
      default: 1
    - name: webhook.replicaCount
      type: integer
      description: "Number of webhook replicas"
      default: 1
    - name: certController.replicaCount
      type: integer
      description: "Number of cert controller replicas"
      default: 1
    - name: cloudProvider
      type: string
      description: "Cloud provider for workload identity"
      enum: ["aws", "gcp", "azure", "none"]
      default: "none"
    - name: serviceAccount.annotations
      type: object
      description: "Annotations for the service account"
      default: {}
```

#### `/ingress-nginx/metadata.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: ComponentMetadata
metadata:
  name: ingress-nginx
  description: "NGINX Ingress Controller for Kubernetes"
spec:
  version: "v1.11.3"
  chart:
    repository: "https://kubernetes.github.io/ingress-nginx"
    name: "ingress-nginx"
    version: "4.11.3"
  dependencies: []
  templates:
    - name: "ingress-nginx.yaml.tmpl"
      description: "NGINX Ingress Controller deployment"
  inputs:
    - name: controller.replicaCount
      type: integer
      description: "Number of controller replicas"
      default: 2
      validation:
        min: 1
        max: 10
    - name: controller.service.type
      type: string
      description: "Service type for the controller"
      enum: ["LoadBalancer", "NodePort", "ClusterIP"]
      default: "LoadBalancer"
    - name: controller.service.annotations
      type: object
      description: "Annotations for the controller service"
      default: {}
```

Create similar metadata files for:
- `/cert-manager-issuers/metadata.yaml`
- `/crossplane/metadata.yaml`
- `/workload-cluster/metadata.yaml`

### Step 6: Create Team Configurations

#### `/teams/default/metadata.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: TeamMetadata
metadata:
  name: default
  displayName: "Default Team"
  description: "Default team configuration with standard settings"
spec:
  extends: null  # Base configuration, doesn't extend anything
  components:
    - name: external-secrets
      enabled: true
    - name: cert-manager
      enabled: true
    - name: cert-manager-issuers
      enabled: true
    - name: external-dns
      enabled: true
    - name: ingress-nginx
      enabled: true
```

#### `/teams/konstruct/metadata.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: TeamMetadata
metadata:
  name: konstruct
  displayName: "Konstruct Platform Team"
  description: "Konstruct platform team with enhanced configurations"
spec:
  extends: default
  components:
    - name: external-secrets
      enabled: true
      overrides:
        replicaCount: 2
        webhook:
          replicaCount: 2
    - name: cert-manager
      enabled: true
      overrides:
        replicaCount: 2
    - name: external-dns
      enabled: true
      overrides:
        interval: "30s"
        policy: "sync"
    - name: ingress-nginx
      enabled: true
      overrides:
        controller:
          replicaCount: 3
    - name: crossplane
      enabled: true
    - name: workload-cluster
      enabled: true
```

#### `/teams/mobile-team/metadata.yaml`:

```yaml
apiVersion: konstruct.io/v1alpha1
kind: TeamMetadata
metadata:
  name: mobile-team
  displayName: "Mobile Team"
  description: "Mobile team optimized for mobile backend services"
spec:
  extends: default
  components:
    - name: external-secrets
      enabled: true
    - name: cert-manager
      enabled: true
      overrides:
        webhook:
          replicaCount: 2
    - name: external-dns
      enabled: true
      overrides:
        sources: ["service", "ingress"]
        txtOwnerId: "mobile-team"
    - name: ingress-nginx
      enabled: true
      overrides:
        controller:
          replicaCount: 3
          config:
            client-body-buffer-size: "64k"
            proxy-body-size: "100m"
          resources:
            requests:
              cpu: "200m"
              memory: "256Mi"
```

### Step 7: Create Team Override Files

For each team that has component overrides, create override files:

#### `/teams/konstruct/components/cert-manager/values.yaml`:

```yaml
# Konstruct team cert-manager overrides
replicaCount: 2
webhook:
  replicaCount: 2
cainjector:
  replicaCount: 2
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

#### `/teams/konstruct/components/external-dns/values.yaml`:

```yaml
# Konstruct team external-dns overrides
interval: 30s
policy: sync
txtOwnerId: "konstruct-platform"
logLevel: debug
resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 200m
    memory: 256Mi
```

#### `/teams/mobile-team/components/ingress-nginx/values.yaml`:

```yaml
# Mobile team ingress-nginx overrides
controller:
  replicaCount: 3
  config:
    client-body-buffer-size: "64k"
    proxy-body-size: "100m"
    proxy-connect-timeout: "10"
    proxy-read-timeout: "120"
    proxy-send-timeout: "120"
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
    limits:
      cpu: 1000m
      memory: 1024Mi
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
      service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
```

### Step 8: Create JSON Schema Files

For each component, create validation schemas:

#### `/cert-manager/schemas/config.schema.json`:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Cert-Manager Configuration",
  "type": "object",
  "properties": {
    "replicaCount": {
      "type": "integer",
      "minimum": 1,
      "maximum": 10,
      "default": 1
    },
    "webhook": {
      "type": "object",
      "properties": {
        "replicaCount": {
          "type": "integer",
          "minimum": 1,
          "maximum": 10,
          "default": 1
        }
      }
    },
    "cainjector": {
      "type": "object",
      "properties": {
        "replicaCount": {
          "type": "integer",
          "minimum": 1,
          "maximum": 10,
          "default": 1
        }
      }
    },
    "cloudProvider": {
      "type": "string",
      "enum": ["aws", "gcp", "azure", "none"],
      "default": "none"
    },
    "serviceAccount": {
      "type": "object",
      "properties": {
        "annotations": {
          "type": "object",
          "additionalProperties": {
            "type": "string"
          }
        }
      }
    }
  }
}
```

#### `/external-dns/schemas/config.schema.json`:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "External-DNS Configuration",
  "type": "object",
  "required": ["provider"],
  "properties": {
    "provider": {
      "type": "string",
      "enum": ["route53", "cloudflare", "cloudDNS", "azureDNS", "civo"]
    },
    "domainFilters": {
      "type": "array",
      "items": {
        "type": "string",
        "pattern": "^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]?(?:\\.[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])*$"
      },
      "default": []
    },
    "sources": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["service", "ingress", "crd"]
      },
      "default": ["ingress"]
    },
    "interval": {
      "type": "string",
      "pattern": "^[0-9]+(s|m|h)$",
      "default": "1m"
    },
    "policy": {
      "type": "string",
      "enum": ["sync", "upsert-only"],
      "default": "upsert-only"
    },
    "txtOwnerId": {
      "type": "string",
      "pattern": "^[a-zA-Z0-9-]+$"
    }
  }
}
```

Create similar schema files for other components.

### Step 9: Create Documentation

#### `/docs/CONTRIBUTING.md`:

```markdown
# Contributing to Konstruct Templates

## Adding a New Team

1. Create a new directory under `/teams/{team-name}/`
2. Add a `metadata.yaml` file defining the team configuration
3. Create component override directories as needed
4. Submit a pull request with your changes

## Adding a New Component

1. Create a new directory `/{component-name}/`
2. Add template files (`.yaml.tmpl`) directly in the component directory
3. Create `metadata.yaml` with component definition
4. Add JSON schemas in `schemas/` subdirectory
5. Update `/index.yaml` to include the new component

## Template Guidelines

- Use Go templating syntax
- Follow Kubernetes resource naming conventions
- Include proper labels and annotations
- Test templates with different configurations
```

#### `/docs/TEAM_SETUP.md`:

```markdown
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
```

#### `/docs/OVERRIDE_GUIDE.md`:

```markdown
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
```

### Step 10: Create GitHub Actions Workflow

Create `/.github/workflows/validate-templates.yaml`:

```yaml
name: Validate Templates

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Validate YAML files
        run: |
          find . -name "*.yaml" -o -name "*.yml" | while read file; do
            echo "Validating $file"
            yq eval '.' "$file" > /dev/null || exit 1
          done
      
      - name: Validate metadata files exist
        run: |
          # Check repository metadata
          test -f metadata.yaml || (echo "Missing /metadata.yaml" && exit 1)
          test -f index.yaml || (echo "Missing /index.yaml" && exit 1)
          
          # Check component metadata
          for dir in cert-manager external-dns external-secrets ingress-nginx; do
            test -f "$dir/metadata.yaml" || (echo "Missing $dir/metadata.yaml" && exit 1)
          done
          
          # Check team metadata
          for team in default konstruct mobile-team; do
            test -f "teams/$team/metadata.yaml" || (echo "Missing teams/$team/metadata.yaml" && exit 1)
          done
      
      - name: Validate JSON schemas
        run: |
          for schema in $(find . -name "*.schema.json"); do
            echo "Validating schema: $schema"
            jq '.' "$schema" > /dev/null || exit 1
          done
      
      - name: Check template syntax
        run: |
          # Simple Go template syntax check
          for tmpl in $(find . -name "*.tmpl"); do
            echo "Checking template: $tmpl"
            # Basic syntax validation (checking for common issues)
            grep -E '{{.*}}' "$tmpl" | grep -v -E '{{-?\s*(if|else|end|range|with|define|template|block)' | grep -E '{{[^}]*{{' && echo "Nested template tags found in $tmpl" && exit 1 || true
          done
```

### Step 11: Create .gitignore

Update or create `/.gitignore`:

```
# OS files
.DS_Store
Thumbs.db

# Editor directories and files
.idea/
.vscode/
*.swp
*.swo
*~

# Temporary files
*.tmp
*.bak
*.cache

# Test outputs
test-output/
coverage/
```

### Step 12: Update README.md

Create or update `/README.md`:

```markdown
# Konstruct Templates Repository

This repository contains templates for the Konstruct platform, organized by components and teams.

## Repository Structure

```
/
├── cert-manager/          # Component: Certificate management
│   ├── *.yaml.tmpl       # Template files
│   ├── metadata.yaml     # Component metadata
│   └── schemas/          # JSON schemas
├── external-dns/          # Component: DNS synchronization
├── external-secrets/      # Component: Secret management
├── ingress-nginx/         # Component: Ingress controller
├── teams/                 # Team-specific configurations
│   ├── default/          # Default team (base configuration)
│   ├── konstruct/        # Konstruct platform team
│   └── mobile-team/      # Mobile team configuration
├── docs/                  # Documentation
├── metadata.yaml          # Repository metadata
└── index.yaml            # Template index
```

## Usage

This repository is consumed by the Konstruct API. To use these templates:

1. Fork this repository
2. Customize team configurations in the `/teams` directory
3. Configure your Konstruct API instance to point to your fork
4. Use the Konstruct API to create clusters with your team's configuration

## Templates

All component templates are stored in their respective component directories as `.yaml.tmpl` files. These are the base templates that all teams use by default.

## Team Overrides

Teams can override default template values by creating override files in their team directory under `/teams/{team-name}/components/{component-name}/`.

## Adding a New Team

See [docs/TEAM_SETUP.md](docs/TEAM_SETUP.md) for detailed instructions.

## Contributing

See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for contribution guidelines.
```

## Implementation Order

1. **Create directory structure** (Step 1)
2. **Keep existing files in place** (Step 2 - no action needed)
3. **Create metadata files** (Steps 3-6)
4. **Add team configurations** (Steps 6-7)
5. **Create schemas** (Step 8)
6. **Add documentation** (Steps 9, 12)
7. **Set up CI/CD** (Step 10)
8. **Update .gitignore** (Step 11)

## Key Differences from Original

- Templates remain in component root directories (no `defaults/` subdirectory)
- Simpler file structure while maintaining all functionality
- Teams can still override any component values
- No need to move existing template files

## Testing the Migration

After completing the migration:

1. Run the GitHub Actions workflow to validate all files
2. Test loading templates via a simple Go program
3. Verify all existing templates still render correctly
4. Test team override merging logic

## Notes for Implementation

- All metadata files should use `apiVersion: konstruct.io/v1alpha1`
- Maintain backward compatibility with existing template syntax
- Use consistent YAML formatting (2 spaces for indentation)
- Ensure all paths in metadata files are relative to repository root
- Test template rendering with sample values before committing