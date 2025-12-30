# SonarQube Pipeline Integration - Final Solution

This directory contains example integrations of SonarQube into CI/CD pipelines.

## Files

- `jenkins/Jenkinsfile.sonarqube`: Jenkins pipeline example
- `github-actions/.github/workflows/sonarqube.yml`: GitHub Actions workflow example

## Usage

### Jenkins Integration

1. Install SonarQube plugins in Jenkins (see task instructions)
2. Configure SonarQube server in Jenkins
3. Add SonarQube stages to your Jenkinsfile (see example)
4. Update project key and configuration

### GitHub Actions Integration

1. Add SonarQube secrets to GitHub (SONAR_TOKEN, SONAR_ORGANIZATION)
2. Add SonarQube job to your workflow (see example)
3. Update project key and organization
4. Commit and push to trigger workflow

## Configuration

Update the following in the examples:
- `your-project-key`: Your actual SonarQube project key
- `SONAR_ORGANIZATION`: Your SonarCloud organization (if using SonarCloud)
- Source paths and exclusions as needed

## Testing

After integration:
1. Trigger pipeline/workflow
2. Verify SonarQube analysis runs
3. Check quality gate status
4. Review results in SonarQube dashboard

