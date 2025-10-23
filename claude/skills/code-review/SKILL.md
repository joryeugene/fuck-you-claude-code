---
name: code-review
description: Perform thorough code reviews with systematic checklist covering code quality, security, performance, testing, and best practices.
---

# Code Review Skill

This skill provides a systematic approach to reviewing code for quality, security, performance, and maintainability.

## When to Use

Use this skill when:

- **Reviewing pull requests** - Before merging code
- **Auditing existing code** - Assessing code quality
- **Refactoring prep** - Identifying issues before refactoring
- **Learning codebases** - Understanding code quality patterns
- **Pre-deployment checks** - Final verification before release

## Review Checklist

### 1. Code Quality & Readability

**Check for:**
- [ ] Clear, descriptive variable and function names
- [ ] Functions doing one thing well (single responsibility)
- [ ] Appropriate code comments for complex logic
- [ ] Consistent formatting and style
- [ ] No commented-out code (use git history instead)
- [ ] DRY principle (Don't Repeat Yourself)
- [ ] Appropriate abstraction levels

**Red Flags:**
- Magic numbers without constants
- Deeply nested conditionals (>3 levels)
- Functions longer than 50 lines
- Unclear variable names (x, temp, data, etc.)

### 2. Security

**Check for:**
- [ ] No hardcoded secrets, API keys, passwords
- [ ] Input validation and sanitization
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output encoding)
- [ ] Authentication and authorization checks
- [ ] Secure data transmission (HTTPS, encryption)
- [ ] No sensitive data in logs

**Red Flags:**
- Direct string interpolation in SQL
- User input rendered without escaping
- Weak or no authentication
- Passwords in plaintext
- Missing rate limiting

### 3. Performance

**Check for:**
- [ ] Efficient algorithms (appropriate Big O)
- [ ] No unnecessary loops or iterations
- [ ] Database queries optimized (indexes, n+1 prevention)
- [ ] Appropriate caching strategies
- [ ] Lazy loading where beneficial
- [ ] No memory leaks (cleanup in useEffect, event listeners)
- [ ] Debouncing/throttling for expensive operations

**Red Flags:**
- Nested loops over large datasets
- Fetching data in loops (n+1 queries)
- Large bundle sizes without code splitting
- Missing memoization for expensive calculations
- Synchronous blocking operations

### 4. Error Handling

**Check for:**
- [ ] Try-catch blocks for risky operations
- [ ] Meaningful error messages
- [ ] Graceful degradation
- [ ] Error logging for debugging
- [ ] User-friendly error states
- [ ] Proper async/await error handling

**Red Flags:**
- Empty catch blocks
- Swallowed errors
- No error boundaries (React)
- Unhandled promise rejections

### 5. Testing

**Check for:**
- [ ] Unit tests for business logic
- [ ] Edge cases covered
- [ ] Integration tests for critical paths
- [ ] Test names describe what they test
- [ ] Tests are independent (no shared state)
- [ ] Mocks used appropriately

**Red Flags:**
- No tests for new functionality
- Tests that don't actually test anything
- Flaky tests
- Low coverage on critical code

### 6. Architecture & Design

**Check for:**
- [ ] Follows project patterns and conventions
- [ ] Appropriate separation of concerns
- [ ] No tight coupling
- [ ] Dependency injection where appropriate
- [ ] Consistent with existing architecture
- [ ] Scalable design

**Red Flags:**
- Circular dependencies
- God objects/classes
- Mixing presentation and business logic
- Hard dependencies on concrete implementations

### 7. TypeScript/Type Safety (if applicable)

**Check for:**
- [ ] No `any` types (use `unknown` if needed)
- [ ] Proper type definitions
- [ ] No type assertions without good reason
- [ ] Interfaces for object shapes
- [ ] Generics for reusable code

**Red Flags:**
- Excessive use of `any`
- Type assertions everywhere (`as` keyword)
- Missing return types on functions

## Review Process

### Step 1: Understand Context
- What problem does this solve?
- What's the scope of changes?
- Are there related PRs or issues?

### Step 2: High-Level Review
- Overall architecture and approach
- Does it fit with existing patterns?
- Is this the right solution?

### Step 3: Detailed Review
- Go through checklist above
- Read code line by line
- Check tests

### Step 4: Provide Feedback
- **Critical issues** - Must fix (security, bugs)
- **Suggestions** - Should consider (performance, readability)
- **Nitpicks** - Nice to have (style preferences)
- **Praise** - Call out good patterns!

### Step 5: Verify Fixes
- Review changes from feedback
- Re-check critical items
- Approve or request further changes

## Feedback Format

```markdown
## Critical Issues
- [ ] Security: Hardcoded API key on line 42
- [ ] Bug: Null pointer exception possible on line 67

## Suggestions
- [ ] Performance: Consider memoizing this calculation (line 89)
- [ ] Readability: Extract this complex logic into separate function

## Nitpicks
- [ ] Style: Prefer const over let here (line 12)

## Positive Notes
- ✅ Great test coverage
- ✅ Well-documented complex logic
- ✅ Good error handling
```

## Examples

### Example 1: Security Issue
```javascript
// ❌ BAD - SQL Injection vulnerability
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ GOOD - Parameterized query
const query = 'SELECT * FROM users WHERE id = ?';
db.execute(query, [userId]);
```

### Example 2: Performance Issue
```javascript
// ❌ BAD - N+1 query problem
users.forEach(user => {
  const posts = await db.query('SELECT * FROM posts WHERE user_id = ?', [user.id]);
});

// ✅ GOOD - Single query with JOIN
const usersWithPosts = await db.query(`
  SELECT u.*, p.* FROM users u
  LEFT JOIN posts p ON u.id = p.user_id
`);
```

### Example 3: Code Quality
```javascript
// ❌ BAD - Unclear, doing too much
function doStuff(d) {
  const x = d.filter(i => i.a > 5);
  const y = x.map(i => i.b * 2);
  saveToDb(y);
  sendEmail(y);
  logAnalytics(y);
  return y;
}

// ✅ GOOD - Clear, single responsibility
function filterActiveUsers(users) {
  return users.filter(user => user.loginCount > 5);
}

function calculateScores(users) {
  return users.map(user => user.baseScore * 2);
}

function processUserScores(users) {
  const activeUsers = filterActiveUsers(users);
  const scores = calculateScores(activeUsers);

  saveToDb(scores);
  sendEmail(scores);
  logAnalytics(scores);

  return scores;
}
```

## Guidelines

- **Be constructive** - Suggest improvements, don't just criticize
- **Explain why** - Help the author understand the reasoning
- **Prioritize** - Distinguish critical from nice-to-have
- **Praise good code** - Positive reinforcement matters
- **Be thorough** - Use the checklist systematically
- **Consider context** - Deadlines, scope, constraints matter
