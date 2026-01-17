# Task: Docker - Create docker-compose for Local Development

**Issue:** #33  
**Category:** Docker  
**Priority:** High  
**Effort:** 3 days  
**Status:** Not Started

## Objective
Set up docker-compose configuration for complete local development environment with all services.

## Description
Create docker-compose.yml defining all services (frontend, backend, database, Redis, etc.) for local development with proper networking and volumes.

## Sub-Tasks
- [ ] Design service architecture in compose
- [ ] Add frontend service
- [ ] Add backend service
- [ ] Add PostgreSQL service
- [ ] Add Redis service
- [ ] Add RabbitMQ/Kafka (optional)
- [ ] Configure networking
- [ ] Set up volumes for persistence
- [ ] Configure environment variables
- [ ] Add health checks
- [ ] Create .env.example file
- [ ] Test full stack startup

## Acceptance Criteria
- [ ] All services start with docker-compose up
- [ ] Services can communicate with each other
- [ ] Database persists data
- [ ] Environment variables loaded correctly
- [ ] Health checks passing
- [ ] Logs viewable via docker-compose logs
- [ ] Shutdown clean without errors

## docker-compose.yml Structure
```yaml
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_API_URL=http://backend:3001
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/app
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=app
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

## Common Commands
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Remove volumes
docker-compose down -v
```

## References
- docker-compose Documentation: https://docs.docker.com/compose/
- Compose File Format: https://docs.docker.com/compose/compose-file/
- Multi-container Applications: https://docs.docker.com/get-started/07_multi_container/
