---
name: deployment-workflow
description: Deployment best practices, CI/CD patterns, pre-deployment checklists, rollback procedures, and environment management. Use when deploying or planning deployments.
---

# Deployment Workflow Skill

Comprehensive guide for safe, reliable deployments from development to production.

## When to Use

Use this skill when:

- **Planning deployments** - Preparing releases
- **Deploying to production** - Executing releases
- **Setting up CI/CD** - Automating deployment pipelines
- **Debugging deployment failures** - Investigating issues
- **Rolling back** - Reverting problematic deployments
- **Managing environments** - Configuring dev/staging/prod

## Deployment Pipeline

```
┌─────────┐     ┌──────┐     ┌──────┐     ┌────────┐     ┌─────────┐
│  Build  │ --> │ Test │ --> │Stage │ --> │  Prod  │ --> │ Monitor │
└─────────┘     └──────┘     └──────┘     └────────┘     └─────────┘
     ↓              ↓            ↓             ↓              ↓
  Compile       Unit/Int    Smoke Test    Blue/Green    Logs/Metrics
  Bundle        E2E Tests   QA Review     Canary        Alerts
  Validate      Coverage    Perf Test     Rolling       Health
```

## Pre-Deployment Checklist

Before deploying to production:

### Code Quality
- [ ] All tests passing locally and in CI
- [ ] Code reviewed and approved
- [ ] No console.log / debug code
- [ ] No hardcoded secrets or credentials
- [ ] Linting/formatting passing
- [ ] No TODOs or FIXMEs in critical paths

### Testing
- [ ] Unit tests passing (>80% coverage)
- [ ] Integration tests passing
- [ ] E2E tests passing on staging
- [ ] Manual testing completed
- [ ] Edge cases tested
- [ ] Error handling verified

### Database
- [ ] Migrations tested on staging
- [ ] Backup created before migration
- [ ] Rollback plan for migrations
- [ ] No destructive migrations (DROP, DELETE)
- [ ] Indexes created for new queries
- [ ] Data integrity verified

### Infrastructure
- [ ] Environment variables configured
- [ ] SSL certificates valid
- [ ] DNS records updated (if needed)
- [ ] CDN cache invalidation plan
- [ ] Load balancer configured
- [ ] Resource limits appropriate

### Monitoring
- [ ] Logging configured
- [ ] Error tracking enabled (Sentry, etc.)
- [ ] Performance monitoring setup
- [ ] Alerts configured
- [ ] Health check endpoints working
- [ ] Dashboards ready

### Communication
- [ ] Team notified of deployment
- [ ] Deployment window scheduled
- [ ] Stakeholders informed
- [ ] Rollback plan documented
- [ ] On-call engineer identified

## Deployment Stages

### 1. Build Stage

```bash
# Install dependencies
npm ci --production

# Run build
npm run build

# Validate build artifacts
test -f dist/index.js || exit 1

# Create version tag
VERSION=$(git describe --tags --always)
echo "Building version: $VERSION"

# Run security audit
npm audit --production --audit-level=high
```

### 2. Test Stage

```bash
# Run all tests
npm run test:unit
npm run test:integration
npm run test:e2e

# Check coverage
npm run test:coverage

# Verify coverage threshold
if [ $(coverage-percent) -lt 80 ]; then
  echo "Coverage below 80%"
  exit 1
fi

# Linting
npm run lint

# Type checking
npm run type-check
```

### 3. Staging Deployment

```bash
# Deploy to staging
npm run deploy:staging

# Wait for deployment
sleep 30

# Run smoke tests
npm run test:smoke -- --env=staging

# Manual verification
echo "Verify staging at: https://staging.example.com"
echo "Proceed to production? (y/n)"
read answer

if [ "$answer" != "y" ]; then
  echo "Deployment cancelled"
  exit 1
fi
```

### 4. Production Deployment

**Strategy Options:**

#### Blue/Green Deployment
```bash
# Deploy to green (inactive) environment
deploy-to green

# Run health checks
health-check green

# Switch traffic to green
switch-traffic green

# Monitor for 10 minutes
monitor-errors green --duration 10m

# If errors, rollback to blue
if [ $? -ne 0 ]; then
  switch-traffic blue
  exit 1
fi

# Keep blue as backup for 24h
```

#### Rolling Deployment
```bash
# Deploy to instances one by one
for instance in $(get-instances); do
  # Remove from load balancer
  lb-remove $instance

  # Deploy new version
  deploy-to $instance

  # Health check
  health-check $instance

  # Add back to load balancer
  lb-add $instance

  # Wait before next instance
  sleep 30
done
```

#### Canary Deployment
```bash
# Deploy to 5% of servers
deploy-canary --percentage 5

# Monitor for 15 minutes
monitor --duration 15m

# If successful, increase to 25%
deploy-canary --percentage 25
monitor --duration 10m

# If successful, deploy to 100%
deploy-canary --percentage 100
```

### 5. Post-Deployment

```bash
# Verify deployment
curl -f https://api.example.com/health || exit 1

# Check error rates
check-error-rate --threshold 1% --duration 5m

# Verify key features
npm run test:smoke -- --env=production

# Check database migrations applied
psql $DB -c "SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1;"

# Notify team
slack-notify "Deployment v$VERSION successful"

# Tag release
git tag -a "v$VERSION" -m "Release $VERSION"
git push origin "v$VERSION"
```

## Rollback Procedures

### Immediate Rollback

```bash
# 1. Revert to previous version
kubectl rollout undo deployment/my-app
# or
heroku rollback
# or
git revert HEAD && git push && deploy

# 2. Verify rollback
health-check production

# 3. Investigate issue
check-logs --since 1h
check-errors --since 1h

# 4. Notify team
slack-notify "ROLLBACK: Reverted to previous version due to [reason]"
```

### Database Rollback

```bash
# 1. Stop application (prevent writes)
scale-app --replicas 0

# 2. Restore from backup
psql $DB < backup_pre_deployment.sql

# 3. Verify data integrity
psql $DB -c "SELECT COUNT(*) FROM critical_table;"

# 4. Restart application
scale-app --replicas 3

# 5. Monitor
check-error-rate --duration 10m
```

### Partial Rollback (Feature Flags)

```bash
# Disable problematic feature without full rollback
feature-flag disable new-checkout-flow

# Monitor impact
check-error-rate --duration 5m

# If fixed, re-enable gradually
feature-flag enable new-checkout-flow --percentage 10
```

## Environment Management

### Environment Variables

```bash
# Development (.env.development)
NODE_ENV=development
API_URL=http://localhost:3000
DB_HOST=localhost
LOG_LEVEL=debug

# Staging (.env.staging)
NODE_ENV=staging
API_URL=https://api-staging.example.com
DB_HOST=staging-db.internal
LOG_LEVEL=info

# Production (.env.production)
NODE_ENV=production
API_URL=https://api.example.com
DB_HOST=prod-db.internal
LOG_LEVEL=warn
```

**Best Practices:**
- Never commit .env files to git
- Use secret management tools (AWS Secrets Manager, Vault)
- Validate required env vars on startup
- Document all env vars in README

### Environment Parity

**Keep dev/staging/prod similar:**
- Same OS and runtime versions
- Same database versions
- Same environment variables (different values)
- Same deployment process
- Similar data volume (use production-like fixtures in staging)

## CI/CD Patterns

### GitHub Actions Example

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
      - run: npm ci
      - run: npm test
      - run: npm run lint

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v2
        with:
          name: build
          path: dist/

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/download-artifact@v2
      - run: npm run deploy:staging

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/download-artifact@v2
      - run: npm run deploy:production
      - run: npm run test:smoke -- --env=production
```

### GitLab CI Example

```yaml
stages:
  - test
  - build
  - deploy-staging
  - deploy-production

test:
  stage: test
  script:
    - npm ci
    - npm test
    - npm run lint

build:
  stage: build
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - dist/

deploy-staging:
  stage: deploy-staging
  script:
    - npm run deploy:staging
  environment:
    name: staging
    url: https://staging.example.com

deploy-production:
  stage: deploy-production
  script:
    - npm run deploy:production
  environment:
    name: production
    url: https://example.com
  when: manual  # Require manual approval
  only:
    - main
```

## Zero-Downtime Deployment

### Strategies

**1. Load Balancer Health Checks**
```bash
# Remove instance from LB before deploying
lb-remove instance-1
deploy instance-1
health-check instance-1
lb-add instance-1
```

**2. Database Migrations**
```sql
-- Bad: Breaking change
ALTER TABLE users DROP COLUMN old_field;

-- Good: Multi-phase migration
-- Phase 1 (deploy with code reading both fields)
ALTER TABLE users ADD COLUMN new_field VARCHAR(255);

-- Phase 2 (backfill data)
UPDATE users SET new_field = old_field WHERE new_field IS NULL;

-- Phase 3 (deploy code using only new_field)

-- Phase 4 (remove old field in next release)
ALTER TABLE users DROP COLUMN old_field;
```

**3. Feature Flags**
```javascript
// Deploy new code behind flag (disabled)
if (featureFlags.newCheckout) {
  return <NewCheckout />;
}
return <OldCheckout />;

// Enable gradually
// 1% -> 10% -> 50% -> 100%
```

## Monitoring & Observability

### Key Metrics

**Golden Signals:**
```bash
# 1. Latency - Response times
avg_response_time_ms

# 2. Traffic - Requests per second
requests_per_second

# 3. Errors - Error rate
error_rate_percent

# 4. Saturation - Resource usage
cpu_usage_percent
memory_usage_percent
```

### Logs

```bash
# Structured logging
{
  "timestamp": "2025-01-23T10:30:00Z",
  "level": "error",
  "message": "Payment processing failed",
  "userId": "12345",
  "orderId": "67890",
  "error": "Gateway timeout",
  "duration_ms": 5000
}

# Query logs
grep "error" app.log | tail -100
grep "userId.*12345" app.log
```

### Alerts

**Critical Alerts (page immediately):**
- Error rate > 5%
- Response time > 5s (p99)
- Service down
- Database connection failures

**Warning Alerts (investigate soon):**
- Error rate > 1%
- Response time > 1s (p95)
- High CPU/memory usage
- Disk space low

## Common Deployment Mistakes

**DON'T:**
- Deploy on Friday afternoons
- Deploy without testing on staging
- Deploy multiple changes at once
- Skip database backups
- Deploy without monitoring
- Use master database credentials in app
- Test in production
- Deploy breaking API changes without versioning

**DO:**
- Deploy early in the week
- Test thoroughly on staging first
- Deploy small, incremental changes
- Always backup before migrations
- Monitor during and after deployment
- Use read-only database users where possible
- Test in staging environment
- Version your APIs (v1, v2)

## Best Practices

✅ **Automate everything** - Manual steps lead to errors
✅ **Deploy frequently** - Small, low-risk changes
✅ **Monitor actively** - Watch metrics during deployment
✅ **Document rollback** - Know how to undo changes
✅ **Use feature flags** - Enable/disable without deploying
✅ **Test in production-like environment** - Staging should mirror prod
✅ **Communicate** - Tell team about deployments
✅ **Version everything** - Tag releases, version APIs
✅ **Keep rollback simple** - One command to revert
✅ **Practice rollbacks** - Test your rollback procedure

## Deployment Checklist

**Pre-Deployment:**
- [ ] All tests passing
- [ ] Code reviewed
- [ ] Tested on staging
- [ ] Database backup created
- [ ] Rollback plan ready
- [ ] Team notified
- [ ] Monitoring dashboards open

**During Deployment:**
- [ ] Follow deployment runbook
- [ ] Monitor error rates
- [ ] Watch resource usage
- [ ] Check health endpoints
- [ ] Verify key features work

**Post-Deployment:**
- [ ] Smoke tests passing
- [ ] Error rates normal
- [ ] Performance within SLA
- [ ] Database migrations applied
- [ ] Team notified of success
- [ ] Tag release in git
- [ ] Update changelog

**If Issues:**
- [ ] Identify issue immediately
- [ ] Rollback if critical
- [ ] Investigate root cause
- [ ] Document incident
- [ ] Plan fix and re-deploy
