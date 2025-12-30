# SonarQube Setup - Final Solution

This directory contains the complete solution for setting up SonarQube.

## Files

- `docker-compose.yml`: Self-hosted SonarQube setup with PostgreSQL
- `sonar-project.properties.example`: Example configuration file

## Usage

### Self-hosted Setup

1. Start SonarQube:
```bash
docker-compose up -d
```

2. Wait for SonarQube to start (1-2 minutes)

3. Access SonarQube:
   - URL: http://localhost:9000
   - Default credentials: admin/admin (change on first login)

4. Create project and generate token (see task instructions)

### SonarCloud Setup

1. Go to https://sonarcloud.io
2. Sign in with GitHub
3. Create organization
4. Create project
5. Generate token

## Next Steps

After setup, proceed to task-012 to configure the project.

