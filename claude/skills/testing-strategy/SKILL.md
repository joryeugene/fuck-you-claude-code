---
name: testing-strategy
description: When to write what tests, test patterns, coverage strategies, and mock/stub guidance. Use when planning or writing tests.
---

# Testing Strategy Skill

Comprehensive guide for test strategy, patterns, and best practices.

## When to Use

- Planning test approach for new features
- Writing tests
- Debugging test failures
- Improving test coverage
- Refactoring tests

## Test Pyramid

```
        /\
       /E2\     10% - End-to-End (Slow, Brittle, High Value)
      /____\
     /      \
    / Integ  \  20% - Integration (Medium Speed, Medium Value)
   /__________\
  /            \
 /     Unit     \ 70% - Unit Tests (Fast, Stable, Foundation)
/________________\
```

**Distribution:**
- **70% Unit tests** - Fast, isolated, many
- **20% Integration tests** - Module interactions
- **10% E2E tests** - Full user flows

## What to Test

### DO Test

✅ **Business Logic**
```javascript
// Good: Test core business rules
test('discount applies only to orders over $100', () => {
  expect(calculateDiscount(99)).toBe(0);
  expect(calculateDiscount(100)).toBe(10);
  expect(calculateDiscount(150)).toBe(15);
});
```

✅ **Edge Cases**
```javascript
test('handles empty arrays', () => {
  expect(sum([])).toBe(0);
});

test('handles null input', () => {
  expect(parseUser(null)).toBeNull();
});
```

✅ **Error Conditions**
```javascript
test('throws error for invalid email', () => {
  expect(() => validateEmail('not-an-email')).toThrow('Invalid email');
});
```

✅ **Public APIs**
```javascript
test('GET /api/users returns user list', async () => {
  const response = await request(app).get('/api/users');
  expect(response.status).toBe(200);
  expect(response.body).toHaveLength(3);
});
```

✅ **Complex Calculations**
```javascript
test('calculates compound interest correctly', () => {
  const result = calculateCompoundInterest(1000, 0.05, 10);
  expect(result).toBeCloseTo(1628.89, 2);
});
```

### DON'T Test

❌ **Framework Code**
```javascript
// Bad: Testing React itself
test('useState updates state', () => {
  const [state, setState] = useState(0);
  setState(1);
  expect(state).toBe(1); // Testing React, not your code
});
```

❌ **Third-Party Libraries**
```javascript
// Bad: Testing axios
test('axios makes HTTP request', async () => {
  const result = await axios.get('url');
  expect(result).toBeDefined(); // Testing axios
});
```

❌ **Trivial Code**
```javascript
// Bad: Testing getters/setters
test('getName returns name', () => {
  user.setName('John');
  expect(user.getName()).toBe('John'); // Too simple
});
```

❌ **Implementation Details**
```javascript
// Bad: Testing internal methods
test('_privateHelper is called', () => {
  const spy = jest.spyOn(obj, '_privateHelper');
  obj.publicMethod();
  expect(spy).toHaveBeenCalled(); // Couples test to implementation
});
```

## Test Patterns

### Test Behavior, Not Implementation

```javascript
// ❌ BAD: Testing implementation
test('login calls validateEmail and hashPassword', () => {
  const validateSpy = jest.spyOn(auth, 'validateEmail');
  const hashSpy = jest.spyOn(auth, 'hashPassword');

  login('[email protected]', 'password');

  expect(validateSpy).toHaveBeenCalled();
  expect(hashSpy).toHaveBeenCalled();
});

// ✅ GOOD: Testing behavior
test('user can log in with valid credentials', async () => {
  const result = await login('[email protected]', 'password123');

  expect(result.success).toBe(true);
  expect(result.user.email).toBe('[email protected]');
  expect(result.token).toBeDefined();
});
```

### Arrange-Act-Assert (AAA)

```javascript
test('shopping cart calculates total correctly', () => {
  // Arrange: Set up test data
  const cart = new ShoppingCart();
  cart.addItem({ name: 'Book', price: 10 });
  cart.addItem({ name: 'Pen', price: 2 });

  // Act: Perform the action
  const total = cart.calculateTotal();

  // Assert: Verify the result
  expect(total).toBe(12);
});
```

### Test Naming Conventions

```javascript
// Pattern: test('should [expected behavior] when [condition]')

test('should return 401 when authentication token is missing', async () => {
  const response = await request(app).get('/api/protected');
  expect(response.status).toBe(401);
});

test('should calculate shipping cost when destination is international', () => {
  const cost = calculateShipping('Canada', 5);
  expect(cost).toBe(25);
});
```

## Unit Tests

### Characteristics
- Test single function/method
- Fast (milliseconds)
- No external dependencies
- Deterministic (same input = same output)

### Example

```javascript
// Function to test
function isPrime(n) {
  if (n <= 1) return false;
  for (let i = 2; i <= Math.sqrt(n); i++) {
    if (n % i === 0) return false;
  }
  return true;
}

// Unit tests
describe('isPrime', () => {
  test('returns false for numbers <= 1', () => {
    expect(isPrime(0)).toBe(false);
    expect(isPrime(1)).toBe(false);
    expect(isPrime(-5)).toBe(false);
  });

  test('returns true for prime numbers', () => {
    expect(isPrime(2)).toBe(true);
    expect(isPrime(3)).toBe(true);
    expect(isPrime(17)).toBe(true);
  });

  test('returns false for composite numbers', () => {
    expect(isPrime(4)).toBe(false);
    expect(isPrime(9)).toBe(false);
    expect(isPrime(100)).toBe(false);
  });
});
```

## Integration Tests

### Characteristics
- Test multiple modules together
- Slower than unit tests
- May use real dependencies (database, API)
- Test module boundaries

### Example

```javascript
describe('User Registration Flow', () => {
  let db;

  beforeAll(async () => {
    db = await setupTestDatabase();
  });

  afterAll(async () => {
    await db.close();
  });

  test('registers new user and sends welcome email', async () => {
    const userData = {
      email: '[email protected]',
      password: 'secure123',
      name: 'John Doe'
    };

    // Test actual registration flow
    const result = await registerUser(userData);

    // Verify user in database
    const user = await db.users.findByEmail('[email protected]');
    expect(user).toBeDefined();
    expect(user.name).toBe('John Doe');

    // Verify email sent
    const emails = await getTestEmails();
    expect(emails).toHaveLength(1);
    expect(emails[0].to).toBe('[email protected]');
    expect(emails[0].subject).toContain('Welcome');
  });
});
```

## E2E Tests

### Characteristics
- Test complete user flows
- Slowest tests
- Use real browser/app
- Most brittle (UI changes break tests)

### Example (Playwright)

```javascript
test('user can complete checkout process', async ({ page }) => {
  // Navigate to store
  await page.goto('https://example.com');

  // Add items to cart
  await page.click('[data-testid="product-1"]');
  await page.click('[data-testid="add-to-cart"]');

  // Go to checkout
  await page.click('[data-testid="cart-icon"]');
  await page.click('[data-testid="checkout-button"]');

  // Fill shipping info
  await page.fill('[name="address"]', '123 Main St');
  await page.fill('[name="city"]', 'San Francisco');

  // Complete purchase
  await page.click('[data-testid="place-order"]');

  // Verify success
  await expect(page.locator('[data-testid="order-confirmation"]')).toBeVisible();
});
```

## Mocking & Stubbing

### When to Mock

✅ **Mock external dependencies:**
- API calls
- Database queries
- File system operations
- Third-party services
- Slow operations

❌ **Don't mock everything:**
- Your own business logic
- Simple functions
- Test doubles (prefer real when fast)

### Mocking Examples

```javascript
// Mock API call
jest.mock('./api');
test('displays user data from API', async () => {
  api.fetchUser.mockResolvedValue({
    id: 1,
    name: 'John Doe'
  });

  const result = await getUserProfile(1);
  expect(result.name).toBe('John Doe');
});

// Mock database
jest.mock('./database');
test('saves user to database', async () => {
  db.save.mockResolvedValue({ id: 123 });

  const user = await createUser({ name: 'Jane' });
  expect(user.id).toBe(123);
  expect(db.save).toHaveBeenCalledWith({ name: 'Jane' });
});

// Spy on function
test('logs error when save fails', async () => {
  const consoleSpy = jest.spyOn(console, 'error').mockImplementation();

  await saveUser({ invalid: 'data' });

  expect(consoleSpy).toHaveBeenCalledWith(expect.stringContaining('Failed'));
  consoleSpy.mockRestore();
});
```

## Test Coverage

### What is Good Coverage?

- **80%+ overall** is good target
- **100% critical paths** (auth, payment, data integrity)
- **Focus on business logic**, not boilerplate

### Check Coverage

```bash
# Jest
npm test -- --coverage

# Displays coverage report:
# Statements: 85%
# Branches: 75%
# Functions: 90%
# Lines: 85%
```

### Coverage is NOT the Goal

❌ **Bad**: Writing tests just to hit 100%
✅ **Good**: Writing meaningful tests that happen to achieve high coverage

## Test Data

### Use Factories/Builders

```javascript
// Test data factory
function createTestUser(overrides = {}) {
  return {
    id: 1,
    email: '[email protected]',
    name: 'Test User',
    role: 'user',
    ...overrides
  };
}

test('admin can delete users', () => {
  const admin = createTestUser({ role: 'admin' });
  const result = deleteUser(admin, 123);
  expect(result.success).toBe(true);
});
```

### Use Fixtures for Complex Data

```javascript
// fixtures/users.json
{
  "standard": { "id": 1, "email": "[email protected]", "role": "user" },
  "admin": { "id": 2, "email": "[email protected]", "role": "admin" },
  "inactive": { "id": 3, "email": "[email protected]", "active": false }
}

// In tests
import users from './fixtures/users.json';

test('inactive users cannot log in', () => {
  expect(canLogin(users.inactive)).toBe(false);
});
```

## Test Organization

### Describe Blocks

```javascript
describe('User Authentication', () => {
  describe('login', () => {
    test('succeeds with valid credentials', () => {});
    test('fails with invalid password', () => {});
    test('fails with non-existent email', () => {});
  });

  describe('logout', () => {
    test('clears authentication token', () => {});
    test('redirects to login page', () => {});
  });
});
```

### Setup/Teardown

```javascript
describe('Shopping Cart', () => {
  let cart;

  beforeEach(() => {
    cart = new ShoppingCart();
  });

  afterEach(() => {
    cart.clear();
  });

  test('starts empty', () => {
    expect(cart.items).toHaveLength(0);
  });

  test('can add items', () => {
    cart.addItem({ id: 1, price: 10 });
    expect(cart.items).toHaveLength(1);
  });
});
```

## Common Testing Mistakes

❌ **Testing implementation details**
❌ **Tests depend on each other**
❌ **Tests depend on execution order**
❌ **Shared mutable state between tests**
❌ **Too many assertions in one test**
❌ **Not testing edge cases**
❌ **Flaky tests (pass/fail randomly)**

## Best Practices

✅ **Write tests first (TDD)** or alongside code
✅ **Keep tests simple** - one concept per test
✅ **Make tests independent** - no shared state
✅ **Use descriptive test names**
✅ **Test edge cases** - null, empty, boundary values
✅ **Mock external dependencies**
✅ **Avoid implementation details**
✅ **Run tests frequently** - in CI/CD and locally
✅ **Fix flaky tests immediately**
✅ **Delete obsolete tests**

## Test Checklist

Before merging code:
- [ ] All tests passing
- [ ] New features have tests
- [ ] Edge cases covered
- [ ] No flaky tests
- [ ] Coverage meets threshold
- [ ] Tests are independent
- [ ] Test names are descriptive
- [ ] No commented-out tests
