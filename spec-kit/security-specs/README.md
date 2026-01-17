# Security Specifications

Contains security configurations, policies, and best practices.

## Organization

- **mtls-config.yaml** - Mutual TLS configuration
- **rbac-policies.yaml** - Role-Based Access Control policies
- **vault-policies.hcl** - HashiCorp Vault secret policies
- **jwt-strategy.md** - JWT authentication approach
- **zero-trust-model.md** - Zero-trust security principles

## Security Layers

### Network Security
- mTLS for service-to-service communication
- Network policies for pod-to-pod communication
- TLS termination at ingress

### Application Security
- JWT token-based authentication
- RBAC for authorization
- Input validation and sanitization
- Rate limiting and DDoS protection

### Secrets Management
- HashiCorp Vault for secrets
- Automatic secret rotation
- Audit logging of secret access

### Compliance
- Security headers (HSTS, CSP, X-Frame-Options)
- CORS policies
- Data encryption at rest and in transit

---

See parent [README.md](../README.md) for project overview.
