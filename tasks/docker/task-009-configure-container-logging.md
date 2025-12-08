# Task: Docker - Configure Container Logging

**Related Issue:** #39, #40  
**Prerequisites:** task-001, task-002 (Frontend and Backend Dockerfiles)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Configure Notes App frontend and backend to log to stdout/stderr so logs are accessible via Docker logging and can be collected by log aggregation systems

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand Docker logging
- Configure applications to log to stdout/stderr
- Use structured logging (JSON)
- Access logs via docker logs
- Configure log drivers
- Prepare for log aggregation (ELK stack)

---

## Theory Section

### What is Container Logging?

**Container logging** captures application output. Docker captures:
- **stdout**: Standard output (console.log, print statements)
- **stderr**: Error output (errors, warnings)

**Why This Matters for Notes App:**

- Debug issues in production
- Monitor application health
- Track user actions (audit log)
- Integrate with log aggregation (ELK stack in Phase 4)
- Centralized logging for all services

**Log Drivers:**
- **json-file**: Default, logs to files
- **syslog**: Send to syslog
- **journald**: Systemd journal
- **gelf**: Graylog Extended Format
- **fluentd**: Send to Fluentd

---

## Prerequisites Check

- [ ] Completed task-001 (Frontend Dockerfile)
- [ ] Completed task-002 (Backend Dockerfile)
- [ ] Understanding of logging concepts

---

## Step-by-Step Instructions

### Step 1: Configure Backend Logging

**Update backend logger to output JSON to stdout:**

**Install logging library (if needed):**
```bash
npm install winston pino
```

**Backend logging setup (using Winston):**
```javascript
// logger.js
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'notes-app-backend' },
  transports: [
    new winston.transports.Console({
      format: winston.format.json()
    })
  ]
});

module.exports = logger;
```

**Use in application:**
```javascript
const logger = require('./logger');

logger.info('Server starting', { port: process.env.PORT });
logger.error('Database connection failed', { error: err.message });
logger.info('User logged in', { userId: user.id });
```

### Step 2: Configure Frontend Logging

**Frontend logs to console (Next.js):**
```javascript
// utils/logger.js
const logger = {
  info: (message, data) => {
    console.log(JSON.stringify({
      level: 'info',
      message,
      data,
      timestamp: new Date().toISOString(),
      service: 'notes-app-frontend'
    }));
  },
  error: (message, error) => {
    console.error(JSON.stringify({
      level: 'error',
      message,
      error: error?.message,
      stack: error?.stack,
      timestamp: new Date().toISOString(),
      service: 'notes-app-frontend'
    }));
  }
};

export default logger;
```

**Use in components:**
```javascript
import logger from '@/utils/logger';

logger.info('User logged in', { userId: user.id });
logger.error('API call failed', { error: err });
```

### Step 3: Verify Logs in Containers

**View logs:**
```bash
# All logs
docker-compose logs

# Specific service
docker-compose logs backend
docker-compose logs frontend

# Follow logs (real-time)
docker-compose logs -f backend

# Last 100 lines
docker-compose logs --tail=100 backend
```

**Using docker logs:**
```bash
docker logs notes-app-backend
docker logs -f notes-app-backend  # Follow
docker logs --tail=50 notes-app-backend
```

### Step 4: Configure Log Drivers in docker-compose.yml

**Configure logging:**
```yaml
services:
  backend:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
        labels: "service=backend"

  frontend:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
        labels: "service=frontend"
```

**Log rotation:**
- `max-size`: Rotate when log reaches 10MB
- `max-file`: Keep 3 rotated files
- Prevents disk space issues

### Step 5: Test Structured Logging

**Verify JSON logs:**
```bash
# Check logs are JSON
docker-compose logs backend | head -1 | jq .

# Should output:
# {
#   "level": "info",
#   "message": "Server starting",
#   "service": "notes-app-backend",
#   "timestamp": "2025-01-15T10:30:00.000Z"
# }
```

### Step 6: Add Log Levels

**Use environment variables:**
```yaml
services:
  backend:
    environment:
      LOG_LEVEL: ${LOG_LEVEL:-info}  # debug, info, warn, error

  frontend:
    environment:
      LOG_LEVEL: ${LOG_LEVEL:-info}
```

**In code:**
```javascript
if (process.env.LOG_LEVEL === 'debug') {
  logger.debug('Detailed debug information');
}
```

---

## Notes App Specifics

**Backend Logs:**
- API requests/responses
- Database queries
- Authentication events
- Errors and exceptions
- Performance metrics

**Frontend Logs:**
- User actions (login, create note)
- API call failures
- Client-side errors
- Performance metrics

**Log Format:**
- JSON structured logs
- Consistent format across services
- Ready for ELK stack (Phase 4)

---

## Verification

- [ ] Backend logs to stdout in JSON format
- [ ] Frontend logs to console in JSON format
- [ ] Logs accessible via `docker logs`
- [ ] Log rotation configured
- [ ] Log levels configurable via environment
- [ ] Structured logs parse correctly: `docker logs backend | jq .`

---

## Troubleshooting

**Issue: No logs appearing**
- Verify application logs to console (not files)
- Check log level is appropriate
- Verify container is running: `docker ps`

**Issue: Logs not JSON**
- Check logger configuration
- Verify format is JSON, not plain text
- Test logger output locally first

**Issue: Too many logs**
- Adjust log level (use 'warn' or 'error' in production)
- Configure log rotation
- Filter logs: `docker logs backend | grep ERROR`

---

## Best Practices

1. **Structured Logging**: Always use JSON format
2. **Log Levels**: Use appropriate levels (debug, info, warn, error)
3. **Log Rotation**: Configure to prevent disk issues
4. **No Sensitive Data**: Don't log passwords, tokens, PII
5. **Context**: Include request IDs, user IDs for tracing
6. **Performance**: Log asynchronously if possible

---

## Next Steps

- Phase 4: Integrate with ELK stack for centralized logging
- Phase 4: Use Filebeat/Fluent Bit to ship logs
- Phase 4: Create Kibana dashboards for log visualization

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

