// Example: Service-to-service communication using Kubernetes DNS

const axios = require('axios');

// Service discovery via Kubernetes DNS
// Format: <service-name>.<namespace>.svc.cluster.local

const AUTH_SERVICE_URL = process.env.AUTH_SERVICE_URL || 'http://auth-service.notes-app.svc.cluster.local:3001';
const NOTES_SERVICE_URL = process.env.NOTES_SERVICE_URL || 'http://notes-service.notes-app.svc.cluster.local:3002';
const USER_SERVICE_URL = process.env.USER_SERVICE_URL || 'http://user-service.notes-app.svc.cluster.local:3003';

// In same namespace, you can use just service name
// const AUTH_SERVICE_URL = 'http://auth-service:3001';

// Example: Notes Service calling Auth Service
async function validateToken(token) {
  try {
    const response = await axios.post(
      `${AUTH_SERVICE_URL}/auth/validate`,
      { token },
      { timeout: 5000 }
    );
    return response.data.valid;
  } catch (error) {
    console.error('Token validation failed:', error.message);
    return false;
  }
}

// Example: Frontend calling Notes Service
async function getNotes(token) {
  try {
    const response = await axios.get(
      `${NOTES_SERVICE_URL}/notes/list`,
      {
        headers: {
          'Authorization': `Bearer ${token}`
        },
        timeout: 5000
      }
    );
    return response.data;
  } catch (error) {
    console.error('Get notes failed:', error.message);
    throw error;
  }
}

module.exports = {
  validateToken,
  getNotes
};

