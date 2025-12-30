# Final Solution: Microservices Architecture

This directory contains the complete microservices implementation for Notes App.

## Structure

```
final-solution/
├── services/
│   ├── auth-service/      # Authentication service
│   ├── notes-service/      # Notes management service
│   └── user-service/       # User profile service
├── nginx/
│   └── api-gateway.conf    # API Gateway configuration
├── k8s/
│   ├── deployments.yaml    # Kubernetes deployments
│   └── services.yaml        # Kubernetes services
└── README.md
```

## Services

### Auth Service (Port 3001)
- `/auth/login` - User login
- `/auth/register` - User registration
- `/auth/validate` - Token validation

### Notes Service (Port 3002)
- `/notes/create` - Create note
- `/notes/list` - List user's notes
- `/notes/:id` - Update/Delete note

### User Service (Port 3003)
- `/users/profile/:userId` - Get user profile
- `/users/profile/:userId` - Update user profile

## API Gateway

NGINX routes requests:
- `/auth/*` → Auth Service
- `/notes/*` → Notes Service
- `/users/*` → User Service

## Deployment

1. **Build Docker images**:
   ```bash
   docker build -t notes-app-auth ./services/auth-service
   docker build -t notes-app-notes ./services/notes-service
   docker build -t notes-app-user ./services/user-service
   ```

2. **Deploy to Kubernetes**:
   ```bash
   kubectl apply -f k8s/deployments.yaml
   kubectl apply -f k8s/services.yaml
   ```

3. **Test**:
   ```bash
   # Login
   curl -X POST http://api-gateway/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"user@example.com","password":"password"}'
   
   # Create note (use token from login)
   curl -X POST http://api-gateway/notes/create \
     -H "Authorization: Bearer <token>" \
     -H "Content-Type: application/json" \
     -d '{"title":"My Note","content":"Note content"}'
   ```

## Database Setup

Each service has its own database:
- `auth_db` - Auth service
- `notes_db` - Notes service
- `user_db` - User service

