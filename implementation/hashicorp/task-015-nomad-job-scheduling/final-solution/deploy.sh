#!/bin/bash
# Deploy Notes App to Nomad

echo "Deploying Notes App to Nomad..."

# Submit job
nomad job run notes-app.nomad

# Check status
nomad job status notes-app

# View logs
echo "View logs with: nomad alloc logs <allocation-id>"

