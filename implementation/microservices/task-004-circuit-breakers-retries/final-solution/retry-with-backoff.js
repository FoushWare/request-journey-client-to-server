// Retry with Exponential Backoff
async function retryWithBackoff(fn, options = {}) {
  const maxRetries = options.maxRetries || 3;
  const initialDelay = options.initialDelay || 1000; // 1 second
  const maxDelay = options.maxDelay || 10000; // 10 seconds
  const factor = options.factor || 2;

  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxRetries) {
        throw error; // Last attempt failed
      }

      // Calculate delay with exponential backoff
      const delay = Math.min(
        initialDelay * Math.pow(factor, attempt),
        maxDelay
      );

      console.log(`Retry attempt ${attempt + 1}/${maxRetries} after ${delay}ms`);
      await sleep(delay);
    }
  }
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Example usage
async function callAuthService(token) {
  return retryWithBackoff(
    async () => {
      const response = await axios.post('http://auth-service:3001/auth/validate', { token });
      if (!response.data.valid) {
        throw new Error('Invalid token');
      }
      return response.data;
    },
    {
      maxRetries: 3,
      initialDelay: 1000,
      maxDelay: 10000
    }
  );
}

module.exports = { retryWithBackoff, callAuthService };

