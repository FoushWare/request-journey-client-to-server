// Resilient Service Client with Circuit Breaker and Retries
const CircuitBreaker = require('./circuit-breaker');
const { retryWithBackoff } = require('./retry-with-backoff');
const axios = require('axios');

class ResilientServiceClient {
  constructor(serviceUrl, options = {}) {
    this.serviceUrl = serviceUrl;
    this.circuitBreaker = new CircuitBreaker({
      failureThreshold: options.failureThreshold || 5,
      resetTimeout: options.resetTimeout || 60000
    });
    this.retryOptions = {
      maxRetries: options.maxRetries || 3,
      initialDelay: options.initialDelay || 1000,
      maxDelay: options.maxDelay || 10000
    };
    this.fallback = options.fallback || null;
  }

  async request(method, path, data = null, headers = {}) {
    try {
      return await this.circuitBreaker.execute(async () => {
        return await retryWithBackoff(async () => {
          const config = {
            method,
            url: `${this.serviceUrl}${path}`,
            headers,
            timeout: 5000
          };
          
          if (data) {
            config.data = data;
          }
          
          const response = await axios(config);
          return response.data;
        }, this.retryOptions);
      });
    } catch (error) {
      console.error(`Service call failed: ${error.message}`);
      
      // Use fallback if available
      if (this.fallback) {
        console.log('Using fallback response');
        return this.fallback(method, path, data);
      }
      
      throw error;
    }
  }

  getState() {
    return this.circuitBreaker.getState();
  }
}

// Example usage
const authClient = new ResilientServiceClient('http://auth-service:3001', {
  failureThreshold: 5,
  resetTimeout: 60000,
  maxRetries: 3,
  fallback: (method, path, data) => {
    // Return cached token or default response
    return { valid: false, cached: true };
  }
});

// Use the client
async function validateToken(token) {
  try {
    const result = await authClient.request('POST', '/auth/validate', { token });
    return result;
  } catch (error) {
    console.error('Token validation failed:', error);
    return { valid: false };
  }
}

module.exports = { ResilientServiceClient, validateToken };

