#!/bin/bash
# Test network connectivity between containers

echo "Testing Docker network connectivity..."

# Test backend can reach postgres
echo "1. Testing backend -> postgres:"
docker exec notes-backend ping -c 2 postgres

# Test frontend can reach backend
echo "2. Testing frontend -> backend:"
docker exec notes-frontend ping -c 2 backend

# List network
echo "3. Network details:"
docker network inspect notes-app-network

echo "Network test complete!"

