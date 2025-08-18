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