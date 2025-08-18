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