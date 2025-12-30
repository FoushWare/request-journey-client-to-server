# SonarQube Project Configuration - Final Solution

This directory contains example SonarQube project configuration files.

## Files

- `backend/sonar-project.properties`: Backend configuration
- `frontend/sonar-project.properties`: Frontend configuration

## Usage

1. Copy the appropriate configuration file to your project directory
2. Update the following values:
   - `sonar.projectKey`: Your actual project key
   - `sonar.organization`: Your SonarCloud organization key (if using SonarCloud)
   - `sonar.host.url`: Your SonarQube server URL
   - `sonar.sources`: Adjust to match your project structure
   - `sonar.exclusions`: Add any additional exclusions

3. Test the configuration:
```bash
# Install SonarQube Scanner (if not already installed)
# Then run:
sonar-scanner
```

## Next Steps

After configuration, proceed to task-013 to integrate into CI/CD pipelines.

