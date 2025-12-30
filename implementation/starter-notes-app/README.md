# Notes App - Base Starter Codebase

This is the base Notes App codebase used as the starter for the first task in each category. It contains:

- **Frontend**: Next.js/React application
- **Backend**: Node.js/Express API
- **Database**: PostgreSQL schema and migrations

## Important Notes

- **No Docker**: This base codebase does NOT include Dockerfiles or docker-compose.yml
- **No Kubernetes**: No K8s manifests or configurations
- **No CI/CD**: No pipeline configurations
- **Basic Setup**: Just the working application that can run locally

## Usage

This codebase is copied into:
- `implementation/{category}/task-001/starter/` (first task in each category)
- Subsequent tasks use the final-solution of their prerequisite task as starter

## Structure

```
starter-notes-app/
├── frontend/          # Next.js frontend application
├── backend/           # Express API backend
├── database/          # Database schema and migrations
├── README.md          # This file
└── .env.example       # Environment variables template
```

## Setup Instructions

### Prerequisites
- Node.js 18+ installed
- PostgreSQL installed and running
- npm or yarn package manager

### Frontend Setup
```bash
cd frontend
npm install
cp .env.example .env.local
# Edit .env.local with your API URL
npm run dev
```

### Backend Setup
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with database connection and JWT secret
npm run dev
```

### Database Setup
```bash
# Create database
createdb notesapp

# Run migrations
cd database
psql notesapp < schema.sql
```

## Features

- User authentication (register, login, logout)
- Note creation, viewing, editing, deletion
- JWT-based authentication
- RESTful API
- Responsive UI

## Next Steps

After setting up this base codebase, proceed to:
- Docker tasks: Start with `task-001-create-notes-app-frontend-dockerfile`
- Kubernetes tasks: Complete Docker tasks first
- Other categories: Follow the learning path






