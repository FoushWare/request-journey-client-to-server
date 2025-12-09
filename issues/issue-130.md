# Issue #130: 121- Implement HTTP Requests Polyfill with CORS & Retry Handling

**State:** Open  
**Created:** 2025-12-03T11:29:05Z  
**Updated:** 2025-12-03T11:29:05Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/130

**Labels:** None

---

## Objective
Learn to handle HTTP requests robustly, including CORS errors and retries, using a polyfill or wrapper. This improves understanding of client-server communication and browser behavior.

---

## Tasks / Sub-Issues

- [ ] **1. Research HTTP Requests & CORS**
  - Understand the browser's same-origin policy.
  - Learn why CORS errors occur.
  - Reference: [MDN CORS Guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)

- [ ] **2. Choose / Implement a Polyfill**
  - Use a polyfill/library for `fetch` (e.g., [whatwg-fetch](https://github.com/github/fetch) or `axios`).
  - Ensure compatibility with older browsers if needed.
  - Add retry capability for transient network errors.

- [ ] **3. Build a Request Wrapper**
  - Create a wrapper around `fetch` or `axios` to handle:
    - Automatic retries for network errors
    - CORS fallback (if needed)
    - JSON parsing and error handling
  - Example: `request(url, options) → Promise`

- [ ] **4. Test CORS Handling**
  - Make requests to a cross-origin test API (e.g., https://jsonplaceholder.typicode.com)
  - Simulate CORS errors using browser dev tools
  - Verify polyfill/wrapper handles errors correctly

- [ ] **5. Integrate with Notes App**
  - Replace direct `fetch` or `axios` calls with the wrapper
  - Test all frontend requests: login, create note, get notes

- [ ] **6. Documentation**
  - Document how the polyfill/wrapper works
  - Include example usage and explanation of retry logic and CORS handling
  - Optional: diagram showing client → wrapper → backend flow

---

## References
1. [MDN CORS Guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
2. [whatwg-fetch GitHub](https://github.com/github/fetch)
3. [Axios GitHub](https://github.com/axios/axios)

---

## Labels
`frontend+networking`  
`learning+http`  
`polyfill+retry`  
`phase1+core`

