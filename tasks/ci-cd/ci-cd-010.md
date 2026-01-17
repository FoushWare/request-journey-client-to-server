# Task: Environment Management & Configuration
**Issue:** #50 | **Category:** CI/CD | **Priority:** High | **Effort:** 6h

---

## 📋 Objective

Implement environment management for dev, staging, and production with proper configuration separation.

---

## 📝 Description

Configure environment-specific settings:
- Environment-specific variables
- Configuration management
- Environment parity
- Database schemas per environment
- API endpoint management
- Feature flags

---

## ✅ Acceptance Criteria

- [ ] All environments configured
- [ ] Variables properly managed
- [ ] Database schemas synced
- [ ] Endpoints configured correctly
- [ ] Feature flags working
- [ ] Configuration validation passing
- [ ] Documentation complete
- [ ] Team trained
- [ ] Zero configuration errors
- [ ] Monitoring enabled

---

## 🔧 Sub-Tasks

### 1. Environment Setup
- [ ] Create dev environment
- [ ] Create staging environment
- [ ] Create production environment
- [ ] Document environment specs
- [ ] Configure access controls
- [ ] Document procedures

### 2. Configuration Files
- [ ] Create .env.development
- [ ] Create .env.staging
- [ ] Create .env.production
- [ ] Define all variables
- [ ] Document validation
- [ ] Test loading

### 3. Database Management
- [ ] Configure dev database
- [ ] Configure staging database
- [ ] Configure production database
- [ ] Set up replication
- [ ] Create backup procedures
- [ ] Document procedures

### 4. API Endpoints
- [ ] Configure dev endpoints
- [ ] Configure staging endpoints
- [ ] Configure production endpoints
- [ ] Document endpoint mapping
- [ ] Test connectivity
- [ ] Create endpoint guide

### 5. Feature Flags
- [ ] Design flag system
- [ ] Implement flag evaluation
- [ ] Configure flags per environment
- [ ] Test flag functionality
- [ ] Create flag documentation
- [ ] Document usage

### 6. Infrastructure Parity
- [ ] Ensure environment parity
- [ ] Compare configurations
- [ ] Identify differences
- [ ] Document approved differences
- [ ] Test consistency
- [ ] Create parity guide

### 7. Secrets per Environment
- [ ] Manage dev secrets
- [ ] Manage staging secrets
- [ ] Manage production secrets
- [ ] Separate secret stores
- [ ] Document access
- [ ] Rotate regularly

### 8. Logging & Monitoring
- [ ] Configure dev logging
- [ ] Configure staging logging
- [ ] Configure production logging
- [ ] Set retention policies
- [ ] Create monitoring dashboards
- [ ] Document configuration

### 9. Health Checks
- [ ] Create environment health checks
- [ ] Configure monitoring
- [ ] Set up alerting
- [ ] Document check procedures
- [ ] Test health checks
- [ ] Create troubleshooting guide

### 10. Documentation & Training
- [ ] Create environment guide
- [ ] Document procedures
- [ ] Document troubleshooting
- [ ] Train team
- [ ] Create runbooks
- [ ] Schedule reviews

---

## 📚 Learning Resources

- **Twelve-Factor App:** https://12factor.net/
- **Environment Configuration:** https://create-react-app.dev/docs/adding-custom-environment-variables/
- **Feature Toggles:** https://martinfowler.com/articles/feature-toggles.html
- **Configuration Management:** https://cheatsheetseries.owasp.org/

---

## 💻 Code Example: Environment Configuration

```javascript
// config/environment.js
const environments = {
  development: {
    api: 'http://localhost:3000',
    database: 'postgres://localhost:5432/dev_db',
    redis: 'redis://localhost:6379/0',
    logLevel: 'debug',
    features: {
      newDashboard: true,
      betaFeatures: true,
      experimentalAPI: true,
    },
  },
  staging: {
    api: 'https://api-staging.example.com',
    database: process.env.DATABASE_URL,
    redis: process.env.REDIS_URL,
    logLevel: 'info',
    features: {
      newDashboard: true,
      betaFeatures: true,
      experimentalAPI: false,
    },
  },
  production: {
    api: 'https://api.example.com',
    database: process.env.DATABASE_URL,
    redis: process.env.REDIS_URL,
    logLevel: 'warn',
    features: {
      newDashboard: true,
      betaFeatures: false,
      experimentalAPI: false,
    },
  },
};

const currentEnv = process.env.NODE_ENV || 'development';
module.exports = environments[currentEnv];
```

---

## 💻 .env File Template

```bash
# .env.example
# Node Environment
NODE_ENV=development

# API Configuration
API_PORT=3000
API_HOST=0.0.0.0
API_VERSION=v1

# Database Configuration
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=dev_db
DATABASE_USER=postgres
DATABASE_PASSWORD=password

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_DB=0

# Authentication
JWT_SECRET=your-secret-key
JWT_EXPIRY=24h

# Logging
LOG_LEVEL=debug
LOG_FORMAT=json

# Feature Flags
FEATURE_NEW_DASHBOARD=true
FEATURE_BETA_FEATURES=true
FEATURE_EXPERIMENTAL_API=false

# External Services
SMTP_HOST=localhost
SMTP_PORT=1025
SLACK_WEBHOOK_URL=
```

---

## 📊 Environment Comparison

| Aspect | Development | Staging | Production |
|--------|-------------|---------|------------|
| Database | Local | AWS RDS | AWS RDS Multi-AZ |
| Replicas | 1 | 1 | 3 |
| Caching | Redis Local | Redis Cluster | ElastiCache |
| API Endpoint | localhost:3000 | staging.example.com | api.example.com |
| SSL/TLS | No | Yes | Yes |
| Monitoring | Basic | Full | Full |
| Logging | Console | CloudWatch | CloudWatch |
| Backups | Manual | Daily | Continuous |

---

## 🔒 Security Considerations

- **Secret Separation:** Never share secrets across environments
- **Access Control:** Limit production access
- **Data Isolation:** Use separate databases
- **Network Isolation:** Use VPCs per environment
- **Audit Logging:** Log all production access
- **Compliance:** Follow compliance requirements

---

## ✨ Success Metrics

- All configurations validated
- Environment parity maintained
- Zero configuration errors
- Features toggle correctly
- Zero security violations
- Team proficient

---

## 📖 Related Tasks

- [Secrets Management](ci-cd-008.md) - Credential handling
- [Terraform IaC](ci-cd-007.md) - Infrastructure setup

---

**Created:** January 17, 2026 | **Last Updated:** January 17, 2026
