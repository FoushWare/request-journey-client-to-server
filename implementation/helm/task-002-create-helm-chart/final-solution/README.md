# Final Solution: Create Helm Chart for Notes App

This directory contains a complete Helm chart for Notes App.

## Structure

```
notes-app/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default values
├── templates/
│   ├── _helpers.tpl        # Template helpers
│   ├── deployment.yaml     # Deployment templates
│   ├── service.yaml         # Service templates
│   └── ingress.yaml        # Ingress template
└── README.md
```

## Usage

1. **Lint the chart**:
   ```bash
   helm lint notes-app
   ```

2. **Dry run**:
   ```bash
   helm install notes-app ./notes-app --dry-run --debug
   ```

3. **Install**:
   ```bash
   helm install notes-app ./notes-app
   ```

4. **Upgrade**:
   ```bash
   helm upgrade notes-app ./notes-app
   ```

5. **Uninstall**:
   ```bash
   helm uninstall notes-app
   ```

## Customization

Override values:
```bash
helm install notes-app ./notes-app \
  --set backend.replicaCount=3 \
  --set frontend.image.tag=v2.0.0
```

Or use values file:
```bash
helm install notes-app ./notes-app -f my-values.yaml
```

