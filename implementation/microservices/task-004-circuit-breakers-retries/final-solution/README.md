# Final Solution: Circuit Breakers & Retries

This directory contains resilience pattern implementations.

## Files

### `circuit-breaker.js`
- Circuit breaker implementation
- States: CLOSED, OPEN, HALF_OPEN
- Automatic recovery

### `retry-with-backoff.js`
- Retry logic with exponential backoff
- Configurable retry attempts and delays

### `resilient-service-client.js`
- Combined circuit breaker + retry
- Fallback support
- Complete resilient client

## Usage

```javascript
const { ResilientServiceClient } = require('./resilient-service-client');

const client = new ResilientServiceClient('http://auth-service:3001', {
  failureThreshold: 5,
  resetTimeout: 60000,
  maxRetries: 3,
  fallback: () => ({ valid: false, cached: true })
});

// Use client
const result = await client.request('POST', '/auth/validate', { token });
```

## Circuit Breaker States

- **CLOSED**: Normal operation
- **OPEN**: Failing, reject requests immediately
- **HALF_OPEN**: Testing if service recovered

## Best Practices

- Set appropriate failure thresholds
- Use exponential backoff for retries
- Implement fallback responses
- Monitor circuit breaker states
- Log state transitions

