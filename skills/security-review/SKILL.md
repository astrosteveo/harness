---
name: security-review
description: Use when reviewing code for security vulnerabilities, before deploying auth-related changes, or auditing existing code for security issues
---

# Security-Focused Code Review

**Rigid Protocol.** Security requires discipline. Follow this checklist systematically.

## When to Use

**Mandatory:**
- Before deploying authentication/authorization changes
- When reviewing code that handles user input
- Before merging code that touches secrets or credentials
- When auditing existing code for security issues
- After adding new dependencies

**Recommended:**
- Any code handling sensitive data (PII, financial, health)
- API endpoint implementations
- Database query construction
- File system operations
- External service integrations

---

## Security Review Checklist

Use this checklist for every security review. Do not skip sections.

### 1. OWASP Top 10 Quick Scan

| Category | Check | Status |
|----------|-------|--------|
| A01 Broken Access Control | Are authorization checks present on all protected resources? | [ ] |
| A02 Cryptographic Failures | Is sensitive data encrypted at rest and in transit? | [ ] |
| A03 Injection | Are all inputs parameterized or properly escaped? | [ ] |
| A04 Insecure Design | Does the design follow security principles (least privilege, defense in depth)? | [ ] |
| A05 Security Misconfiguration | Are defaults secure? Debug modes disabled? | [ ] |
| A06 Vulnerable Components | Are dependencies up to date? Known CVEs addressed? | [ ] |
| A07 Authentication Failures | Are auth mechanisms properly implemented? | [ ] |
| A08 Software/Data Integrity | Are updates and CI/CD pipelines protected? | [ ] |
| A09 Logging Failures | Is security-relevant activity logged (without sensitive data)? | [ ] |
| A10 SSRF | Are outbound requests validated and restricted? | [ ] |

### 2. Input Validation and Sanitization

**Check every input source:**
- [ ] URL parameters
- [ ] Request body (JSON, form data, XML)
- [ ] HTTP headers (including cookies)
- [ ] File uploads
- [ ] WebSocket messages
- [ ] Environment variables from untrusted sources

**Validation requirements:**
- [ ] Type validation (string, number, boolean, etc.)
- [ ] Length/size limits enforced
- [ ] Format validation (regex for emails, UUIDs, etc.)
- [ ] Allowlist validation where possible (not blocklist)
- [ ] Encoding validation (UTF-8, no null bytes)

**Red flags:**
```
// DANGEROUS - No validation
app.get('/user/:id', (req, res) => {
  db.query(`SELECT * FROM users WHERE id = ${req.params.id}`);
});

// SAFE - Parameterized
app.get('/user/:id', (req, res) => {
  db.query('SELECT * FROM users WHERE id = ?', [parseInt(req.params.id)]);
});
```

### 3. Authentication and Authorization

**Authentication checks:**
- [ ] Passwords hashed with bcrypt/argon2/scrypt (NOT MD5/SHA1)
- [ ] Password requirements enforced (length, complexity)
- [ ] Rate limiting on login attempts
- [ ] Secure session management (HttpOnly, Secure, SameSite cookies)
- [ ] Token expiration implemented
- [ ] Secure password reset flow (time-limited tokens)
- [ ] MFA implementation correct (if applicable)

**Authorization checks:**
- [ ] Authorization checked on EVERY protected endpoint
- [ ] Authorization checked AFTER authentication
- [ ] Object-level authorization (can user X access resource Y?)
- [ ] Function-level authorization (can user X perform action Z?)
- [ ] No authorization bypasses via parameter manipulation
- [ ] Horizontal privilege escalation prevented
- [ ] Vertical privilege escalation prevented

**Red flags:**
```
// DANGEROUS - No authorization check
app.delete('/post/:id', async (req, res) => {
  await Post.delete(req.params.id);  // Anyone can delete any post!
});

// SAFE - Authorization verified
app.delete('/post/:id', async (req, res) => {
  const post = await Post.findById(req.params.id);
  if (post.authorId !== req.user.id) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  await post.delete();
});
```

### 4. Secret Handling

**Hardcoded secrets scan:**
- [ ] No API keys in code
- [ ] No passwords in code
- [ ] No tokens in code
- [ ] No private keys in code
- [ ] No connection strings with credentials in code
- [ ] `.env` files in `.gitignore`
- [ ] No secrets in comments or documentation

**Grep for common patterns:**
```bash
# Run these against the codebase
grep -rn "password\s*=" --include="*.{js,ts,py,java,go,rb}"
grep -rn "api_key\s*=" --include="*.{js,ts,py,java,go,rb}"
grep -rn "secret\s*=" --include="*.{js,ts,py,java,go,rb}"
grep -rn "BEGIN.*PRIVATE KEY" --include="*"
grep -rn "sk_live_\|pk_live_" --include="*"  # Stripe keys
grep -rn "AKIA" --include="*"  # AWS keys
```

**Proper secret storage:**
- [ ] Secrets loaded from environment variables
- [ ] Secrets management service used (Vault, AWS Secrets Manager, etc.)
- [ ] Secrets rotated regularly
- [ ] Different secrets per environment (dev/staging/prod)

### 5. Injection Vulnerabilities

**SQL Injection:**
- [ ] All queries use parameterized statements or ORM
- [ ] No string concatenation in queries
- [ ] Dynamic table/column names validated against allowlist

**Command Injection:**
- [ ] No `exec()`, `system()`, `eval()` with user input
- [ ] Shell commands use arrays, not strings
- [ ] User input never passed to shell

**XSS (Cross-Site Scripting):**
- [ ] All output HTML-encoded by default
- [ ] Content-Security-Policy header set
- [ ] User input not inserted into `<script>` tags
- [ ] User input not inserted into event handlers
- [ ] `dangerouslySetInnerHTML` / `innerHTML` avoided or sanitized

**Template Injection:**
- [ ] User input not passed to template engines unsanitized
- [ ] No server-side template injection vectors

**Red flags:**
```
// SQL INJECTION
query = f"SELECT * FROM users WHERE name = '{user_input}'"

// COMMAND INJECTION
os.system(f"convert {filename} output.png")

// XSS
element.innerHTML = userInput;
```

### 6. Dependency Vulnerabilities

**Pre-merge checks:**
- [ ] Run `npm audit` / `pip-audit` / `cargo audit` / equivalent
- [ ] No critical or high severity vulnerabilities
- [ ] Known CVEs in dependencies addressed
- [ ] Lock files committed (package-lock.json, Pipfile.lock, etc.)

**Dependency hygiene:**
- [ ] Minimal dependencies (YAGNI)
- [ ] Dependencies from trusted sources
- [ ] No dependencies with known security issues
- [ ] Dependencies pinned to specific versions

**Commands to run:**
```bash
# JavaScript/Node
npm audit
npx snyk test

# Python
pip-audit
safety check

# Go
govulncheck ./...

# Rust
cargo audit

# Ruby
bundle audit
```

### 7. Security Headers and CORS

**Required headers:**
- [ ] `Content-Security-Policy` - Prevents XSS
- [ ] `X-Content-Type-Options: nosniff` - Prevents MIME sniffing
- [ ] `X-Frame-Options: DENY` or `SAMEORIGIN` - Prevents clickjacking
- [ ] `Strict-Transport-Security` - Enforces HTTPS
- [ ] `Referrer-Policy` - Controls referrer information

**CORS configuration:**
- [ ] `Access-Control-Allow-Origin` not set to `*` for authenticated endpoints
- [ ] Allowed origins explicitly listed
- [ ] `Access-Control-Allow-Credentials` only with explicit origins
- [ ] Preflight requests handled correctly

**Red flags:**
```
// DANGEROUS - Allows any origin
app.use(cors({ origin: '*', credentials: true }));

// SAFE - Explicit allowlist
app.use(cors({
  origin: ['https://myapp.com', 'https://admin.myapp.com'],
  credentials: true
}));
```

### 8. Logging Security

**Never log:**
- [ ] Passwords (even hashed)
- [ ] API keys or tokens
- [ ] Credit card numbers
- [ ] Social Security Numbers
- [ ] Personal health information
- [ ] Full session tokens
- [ ] Private keys
- [ ] Database connection strings

**Always log:**
- [ ] Authentication attempts (success/failure)
- [ ] Authorization failures
- [ ] Input validation failures
- [ ] Security-relevant configuration changes
- [ ] Administrative actions

**Log safely:**
- [ ] Mask sensitive data in logs (last 4 digits only)
- [ ] Use structured logging
- [ ] Include request IDs for tracing
- [ ] Timestamp all entries
- [ ] Protect log storage

**Red flags:**
```
// DANGEROUS
logger.info(`User login: ${email}, password: ${password}`);
logger.debug(`API response: ${JSON.stringify(responseWithTokens)}`);

// SAFE
logger.info(`User login attempt: ${maskEmail(email)}, success: ${success}`);
logger.debug(`API response status: ${response.status}`);
```

---

## Review Process

### Step 1: Automated Scans
```bash
# Run before manual review
npm audit                    # or equivalent
grep -rn "TODO.*security" .  # Find security TODOs
grep -rn "FIXME.*security" . # Find security FIXMEs
```

### Step 2: Manual Review
Walk through each section of the checklist above. Do not skip.

### Step 3: Document Findings

**Format:**
```
## Security Review: [Feature/PR Name]
Date: YYYY-MM-DD
Reviewer: [Name]

### Critical Issues (Block merge)
- [ ] Issue description and location
- [ ] Remediation required

### High Issues (Fix before deploy)
- [ ] Issue description and location
- [ ] Recommended fix

### Medium Issues (Fix soon)
- [ ] Issue description and location
- [ ] Recommended fix

### Low Issues (Track for later)
- [ ] Issue description and location

### Passed Checks
- [x] Input validation
- [x] Authentication
- etc.
```

### Step 4: Verify Fixes
- All Critical issues fixed and verified
- All High issues fixed and verified
- Medium/Low issues tracked in backlog

---

## Severity Classification

| Severity | Description | Action |
|----------|-------------|--------|
| **Critical** | Exploitable vulnerability, data breach risk | Block merge. Fix immediately. |
| **High** | Significant security weakness | Fix before production deploy. |
| **Medium** | Defense-in-depth issue | Fix within sprint. |
| **Low** | Minor hardening opportunity | Track in backlog. |

---

## Common Vulnerability Patterns by Language

### JavaScript/TypeScript
- `eval()`, `new Function()` with user input
- `innerHTML`, `dangerouslySetInnerHTML`
- Missing `httpOnly`/`secure` on cookies
- Prototype pollution
- RegExp DoS (ReDoS)

### Python
- `pickle.loads()` with untrusted data
- `yaml.load()` without `SafeLoader`
- `exec()`, `eval()` with user input
- SQL string formatting (use parameterized)
- Insecure deserialization

### Go
- `html/template` vs `text/template` confusion
- Missing input validation on type conversions
- Goroutine race conditions in auth checks

### Java
- Deserialization vulnerabilities
- XXE in XML parsing
- LDAP injection
- Path traversal in file operations

---

## Remember

1. **Assume all input is malicious** - Validate everything
2. **Defense in depth** - Multiple layers of security
3. **Least privilege** - Minimum necessary permissions
4. **Fail securely** - Errors should not leak information
5. **Keep it simple** - Complex security is broken security
6. **Verify, then trust** - Never trust claims without verification
