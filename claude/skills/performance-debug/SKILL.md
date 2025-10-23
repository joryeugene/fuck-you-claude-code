---
name: performance-debug
description: Performance profiling, bottleneck identification, optimization strategies for frontend/backend/database. Use when diagnosing slow performance.
---

# Performance Debug Skill

Systematic approach to identifying and fixing performance issues across the stack.

## When to Use

Use this skill when:

- **App is slow** - Users reporting sluggish performance
- **High resource usage** - CPU/memory/network saturation
- **Slow API responses** - Backend taking too long
- **Database bottlenecks** - Queries timing out
- **Memory leaks** - Memory usage growing over time
- **Bundle size issues** - Frontend loading slowly

## Performance Diagnostic Workflow

```
┌──────────────┐
│   Measure    │ Establish baseline metrics
└──────┬───────┘
       ↓
┌──────────────┐
│   Profile    │ Identify bottlenecks
└──────┬───────┘
       ↓
┌──────────────┐
│   Optimize   │ Fix bottlenecks
└──────┬───────┘
       ↓
┌──────────────┐
│   Verify     │ Measure improvement
└──────────────┘
```

## Frontend Performance

### Measuring Frontend Performance

**Chrome DevTools:**
```bash
# 1. Open DevTools (Cmd+Option+I)
# 2. Performance tab
# 3. Click Record
# 4. Interact with app
# 5. Stop recording
# 6. Analyze flame chart

# Look for:
# - Long tasks (>50ms)
# - Layout thrashing
# - Forced reflows
# - Excessive re-renders
```

**Web Vitals:**
```javascript
// Measure Core Web Vitals
import {getCLS, getFID, getFCP, getLCP, getTTFB} from 'web-vitals';

getCLS(console.log);  // Cumulative Layout Shift
getFID(console.log);  // First Input Delay
getFCP(console.log);  // First Contentful Paint
getLCP(console.log);  // Largest Contentful Paint
getTTFB(console.log); // Time to First Byte

// Goals:
// LCP < 2.5s
// FID < 100ms
// CLS < 0.1
```

### React Performance Issues

**1. Unnecessary Re-renders**

```javascript
// ❌ BAD: Re-renders on every parent render
function ExpensiveChild({ data }) {
  const result = expensiveCalculation(data); // Runs every render
  return <div>{result}</div>;
}

// ✅ GOOD: Memoize expensive calculation
import { useMemo } from 'react';

function ExpensiveChild({ data }) {
  const result = useMemo(() => expensiveCalculation(data), [data]);
  return <div>{result}</div>;
}

// ✅ GOOD: Prevent unnecessary renders
import { memo } from 'react';

const ExpensiveChild = memo(function ExpensiveChild({ data }) {
  return <div>{expensiveCalculation(data)}</div>;
});
```

**2. React DevTools Profiler**

```bash
# Install React DevTools extension
# 1. Open DevTools
# 2. Profiler tab
# 3. Click Record
# 4. Interact with app
# 5. Stop recording

# Look for:
# - Components rendering frequently
# - Long render times
# - Unnecessary renders (props didn't change)
```

**Profiling in Code:**
```javascript
import { Profiler } from 'react';

function onRenderCallback(
  id, phase, actualDuration, baseDuration, startTime, commitTime
) {
  console.log(`${id} (${phase}) took ${actualDuration}ms`);
}

<Profiler id="Navigation" onRender={onRenderCallback}>
  <Navigation />
</Profiler>
```

### Bundle Size Optimization

**Analyze Bundle:**
```bash
# Install bundle analyzer
npm install --save-dev webpack-bundle-analyzer

# Add to webpack config
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

module.exports = {
  plugins: [
    new BundleAnalyzerPlugin()
  ]
};

# Run build and open analyzer
npm run build
# Opens visualization at http://localhost:8888
```

**Optimization Strategies:**

```javascript
// 1. Code Splitting
// ❌ BAD: Load everything upfront
import HeavyComponent from './HeavyComponent';

// ✅ GOOD: Lazy load
const HeavyComponent = lazy(() => import('./HeavyComponent'));

// 2. Tree Shaking
// ❌ BAD: Import entire library
import _ from 'lodash';

// ✅ GOOD: Import only what you need
import debounce from 'lodash/debounce';

// 3. Dynamic Imports
// ❌ BAD: Import chart library upfront
import Chart from 'chart.js';

// ✅ GOOD: Import only when needed
button.addEventListener('click', async () => {
  const Chart = await import('chart.js');
  new Chart(...);
});
```

**Check Bundle Size:**
```bash
# Check gzipped size
npm run build && du -sh dist/* | sort -h

# Set size budget in package.json
{
  "bundlesize": [
    {
      "path": "./dist/app.js",
      "maxSize": "200 kB"
    }
  ]
}
```

### Frontend Checklist

- [ ] Minimize JavaScript bundle (<200KB gzipped)
- [ ] Lazy load routes and heavy components
- [ ] Optimize images (WebP, lazy loading, responsive)
- [ ] Use CDN for static assets
- [ ] Enable compression (gzip/brotli)
- [ ] Cache static assets (service worker)
- [ ] Minimize CSS (remove unused styles)
- [ ] Defer non-critical JavaScript
- [ ] Optimize web fonts (font-display: swap)
- [ ] Reduce third-party scripts

## Backend Performance

### Profiling Node.js

**CPU Profiling:**
```bash
# Start app with profiler
node --prof app.js

# Generate load
# ... use app ...

# Process profiling data
node --prof-process isolate-0x*.log > processed.txt

# Analyze processed.txt for:
# - Functions taking most CPU time
# - Hot paths in your code
```

**Alternative: clinic.js**
```bash
# Install
npm install -g clinic

# Profile CPU
clinic doctor -- node app.js
# Opens browser with flame graph

# Profile event loop
clinic bubbleprof -- node app.js

# Profile memory
clinic heapprofiler -- node app.js
```

### API Response Time

**Measure Endpoint Performance:**
```javascript
// Add timing middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.url} ${duration}ms`);
  });
  next();
});
```

**Identify Slow Endpoints:**
```bash
# Use Application Performance Monitoring (APM)
# - New Relic
# - Datadog
# - Elastic APM

# Or grep logs for slow requests
grep "duration" app.log | awk '{print $4}' | sort -n | tail -20
```

**Common Backend Bottlenecks:**

1. **N+1 Query Problem**
```javascript
// ❌ BAD: Query in loop (N+1 queries)
const users = await User.findAll();
for (const user of users) {
  user.posts = await Post.findAll({ where: { userId: user.id } });
}

// ✅ GOOD: Single query with JOIN
const users = await User.findAll({
  include: [{ model: Post }]
});
```

2. **Missing Caching**
```javascript
// ❌ BAD: Hit database every time
app.get('/expensive-data', async (req, res) => {
  const data = await db.query('SELECT ...');
  res.json(data);
});

// ✅ GOOD: Cache results
const cache = new Map();

app.get('/expensive-data', async (req, res) => {
  if (cache.has('data')) {
    return res.json(cache.get('data'));
  }

  const data = await db.query('SELECT ...');
  cache.set('data', data);
  setTimeout(() => cache.delete('data'), 60000); // 1 min TTL
  res.json(data);
});
```

3. **Synchronous Blocking**
```javascript
// ❌ BAD: Block event loop
app.get('/heavy', (req, res) => {
  const result = heavyComputation(); // Blocks!
  res.json(result);
});

// ✅ GOOD: Offload to worker thread
const { Worker } = require('worker_threads');

app.get('/heavy', (req, res) => {
  const worker = new Worker('./worker.js');
  worker.on('message', result => res.json(result));
  worker.postMessage(data);
});
```

### Backend Checklist

- [ ] Cache frequently accessed data (Redis, Memcached)
- [ ] Use database connection pooling
- [ ] Optimize database queries (indexes, EXPLAIN)
- [ ] Compress responses (gzip/brotli)
- [ ] Use pagination for large datasets
- [ ] Rate limiting to prevent abuse
- [ ] Horizontal scaling (multiple instances)
- [ ] Load balancing
- [ ] CDN for static content
- [ ] Async processing for heavy tasks (job queues)

## Database Performance

### Query Profiling

**PostgreSQL:**
```sql
-- Enable query logging
ALTER DATABASE mydb SET log_min_duration_statement = 100; -- Log queries >100ms

-- Explain query plan
EXPLAIN ANALYZE
SELECT u.*, p.title
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
WHERE u.created_at > '2025-01-01';

-- Look for:
-- Seq Scan (bad - should use index)
-- Index Scan (good)
-- Nested Loop (bad for large datasets)
-- Hash Join (good)

-- Find slow queries
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;
```

**MySQL:**
```sql
-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1; -- Log queries >1s

-- Explain query
EXPLAIN
SELECT u.*, p.title
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
WHERE u.created_at > '2025-01-01';

-- Analyze table
ANALYZE TABLE users;

-- Show slow queries
SHOW FULL PROCESSLIST;
```

### Index Optimization

```sql
-- ❌ BAD: No index on WHERE clause
SELECT * FROM users WHERE email = '[email protected]';
-- Seq Scan on users (cost=0.00..1500.00)

-- ✅ GOOD: Add index
CREATE INDEX idx_users_email ON users(email);
-- Index Scan using idx_users_email (cost=0.42..8.44)

-- Composite index for multiple columns
CREATE INDEX idx_users_created_active ON users(created_at, is_active);

-- Partial index for filtered queries
CREATE INDEX idx_active_users ON users(email) WHERE is_active = true;
```

**Check Index Usage:**
```sql
-- PostgreSQL: Find unused indexes
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
  AND indexname NOT LIKE '%_pkey'
ORDER BY pg_relation_size(indexrelid) DESC;

-- MySQL: Show index statistics
SHOW INDEX FROM users;
```

### Database Checklist

- [ ] Indexes on WHERE, JOIN, ORDER BY columns
- [ ] Remove unused indexes (slow down writes)
- [ ] Use EXPLAIN to verify query plans
- [ ] Optimize N+1 queries (use JOINs or batch loading)
- [ ] Limit result sets (pagination)
- [ ] Use read replicas for read-heavy workloads
- [ ] Connection pooling configured
- [ ] Vacuum/analyze tables regularly (PostgreSQL)
- [ ] Monitor slow query log
- [ ] Database caching (query result cache)

## Memory Leaks

### Detecting Memory Leaks

**Node.js:**
```bash
# Monitor memory usage
node --inspect app.js

# Open Chrome DevTools (chrome://inspect)
# Take heap snapshots over time
# Compare snapshots to find growing objects

# Or use clinic.js
clinic heapprofiler -- node app.js
```

**Browser:**
```bash
# Chrome DevTools
# 1. Performance → Memory
# 2. Take heap snapshot
# 3. Interact with app
# 4. Take another snapshot
# 5. Compare snapshots

# Look for:
# - Detached DOM nodes
# - Growing arrays/objects
# - Event listeners not cleaned up
```

### Common Memory Leak Patterns

**1. Event Listeners**
```javascript
// ❌ BAD: Never removes listener
useEffect(() => {
  window.addEventListener('resize', handleResize);
});

// ✅ GOOD: Cleanup on unmount
useEffect(() => {
  window.addEventListener('resize', handleResize);
  return () => window.removeEventListener('resize', handleResize);
}, []);
```

**2. Timers**
```javascript
// ❌ BAD: Timer continues after unmount
useEffect(() => {
  setInterval(() => fetchData(), 1000);
}, []);

// ✅ GOOD: Clear on unmount
useEffect(() => {
  const id = setInterval(() => fetchData(), 1000);
  return () => clearInterval(id);
}, []);
```

**3. Global References**
```javascript
// ❌ BAD: Keeps references in global scope
const cache = [];

function addToCache(data) {
  cache.push(data); // Grows forever
}

// ✅ GOOD: Limit cache size
const cache = [];
const MAX_SIZE = 100;

function addToCache(data) {
  cache.push(data);
  if (cache.length > MAX_SIZE) {
    cache.shift(); // Remove oldest
  }
}
```

## Performance Testing

### Load Testing

**Apache Bench (ab):**
```bash
# 1000 requests, 10 concurrent
ab -n 1000 -c 10 http://localhost:3000/api/users

# Look for:
# - Requests per second
# - Time per request
# - Failed requests
```

**Artillery:**
```bash
npm install -g artillery

# Create test config (load-test.yml)
config:
  target: 'http://localhost:3000'
  phases:
    - duration: 60
      arrivalRate: 10
scenarios:
  - flow:
    - get:
        url: '/api/users'

# Run test
artillery run load-test.yml
```

**k6:**
```bash
# Install k6
brew install k6

# Create test script (load-test.js)
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  let res = http.get('http://localhost:3000/api/users');
  check(res, { 'status is 200': (r) => r.status === 200 });
  sleep(1);
}

# Run test
k6 run load-test.js
```

### Performance Benchmarking

**JavaScript:**
```javascript
// Benchmark function performance
console.time('operation');
for (let i = 0; i < 1000000; i++) {
  // operation
}
console.timeEnd('operation');

// Or use benchmark.js
const Benchmark = require('benchmark');
const suite = new Benchmark.Suite;

suite
  .add('approach1', () => { /* ... */ })
  .add('approach2', () => { /* ... */ })
  .on('complete', function() {
    console.log('Fastest is ' + this.filter('fastest').map('name'));
  })
  .run();
```

## Monitoring & Alerts

### Key Metrics to Monitor

**Application:**
- Response time (p50, p95, p99)
- Request rate (requests/second)
- Error rate (%)
- Throughput (MB/s)

**System:**
- CPU usage (%)
- Memory usage (%)
- Disk I/O
- Network I/O

**Database:**
- Query execution time
- Connection pool usage
- Cache hit rate
- Lock wait time

### Setting Up Alerts

```javascript
// Example: Alert if p95 response time > 1s
if (p95ResponseTime > 1000) {
  alerting.notify({
    severity: 'warning',
    message: 'High response time detected',
    value: p95ResponseTime
  });
}

// Example: Alert if error rate > 5%
if (errorRate > 0.05) {
  alerting.notify({
    severity: 'critical',
    message: 'High error rate detected',
    value: errorRate
  });
}
```

## Common Performance Mistakes

**DON'T:**
- Premature optimization (optimize after measuring)
- Ignore database indexes
- Load all data at once (no pagination)
- Synchronous blocking operations
- Ignore memory leaks
- Bundle all JavaScript upfront
- Fetch data in loops
- Use `console.log` in production
- Skip performance testing before launch

**DO:**
- Measure first, optimize second
- Use indexes on frequently queried columns
- Paginate large datasets
- Use async/await for I/O operations
- Monitor memory usage over time
- Code split and lazy load
- Batch requests or use JOINs
- Use proper logging libraries
- Load test before going to production

## Best Practices

✅ **Measure before optimizing** - Don't guess, profile
✅ **Focus on bottlenecks** - 80/20 rule applies
✅ **Use caching strategically** - Cache expensive operations
✅ **Optimize database queries** - Use EXPLAIN, add indexes
✅ **Code split** - Don't load code until needed
✅ **Monitor in production** - Real user metrics matter
✅ **Set performance budgets** - Bundle size, response time limits
✅ **Test under load** - Simulate real-world traffic
✅ **Use CDN** - Serve static content from edge
✅ **Compress everything** - gzip/brotli for all responses

## Performance Debug Checklist

**Identify Problem:**
- [ ] Define performance issue (slow page, API timeout, etc.)
- [ ] Establish baseline metrics
- [ ] Reproduce issue consistently

**Profile:**
- [ ] Use appropriate profiling tools (DevTools, clinic.js, etc.)
- [ ] Identify bottleneck (CPU, memory, network, database)
- [ ] Document findings

**Optimize:**
- [ ] Apply targeted optimizations
- [ ] Test changes locally
- [ ] Measure improvement

**Verify:**
- [ ] Compare before/after metrics
- [ ] Test on staging environment
- [ ] Load test if applicable
- [ ] Deploy and monitor in production
