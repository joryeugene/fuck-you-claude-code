---
name: database-ops
description: Best practices for database CLI tools (psql, mysql). Use when working with databases to ensure safe operations and optimal queries.
---

# Database Operations Skill

Guide for using database CLI tools safely and effectively. NO MCP needed - just encode best practices.

## When to Use

Use this skill when:
- Working with PostgreSQL, MySQL, or other databases
- Running queries or migrations
- Debugging database issues
- Optimizing performance

## Philosophy

**Use CLI tools directly** (psql, mysql) instead of database MCPs:
- Less context overhead
- More direct control
- Standard tools, well-documented
- No abstraction layer

## PostgreSQL (psql)

### Safe Patterns

```bash
# ALWAYS backup before destructive ops
pg_dump dbname > backup_$(date +%Y%m%d_%H%M%S).sql

# Safe transaction pattern
psql dbname -c "BEGIN; UPDATE users SET status='active' WHERE id=123; COMMIT;"

# Rollback on error
psql dbname -c "BEGIN; UPDATE ...; ROLLBACK;"  # Test first

# Read-only mode
psql dbname --set=ON_ERROR_STOP=on --set=AUTOCOMMIT=off

# Query with explanation
psql dbname -c "EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%@example.com';"
```

### Common psql Commands

```bash
# Connect to database
psql -U username -d dbname -h localhost -p 5432

# List databases
psql -l

# List tables in database
psql dbname -c "\dt"

# Describe table structure
psql dbname -c "\d table_name"

# Execute SQL file
psql dbname -f migration.sql

# Get table sizes
psql dbname -c "
  SELECT
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
  FROM pg_tables
  WHERE schemaname = 'public'
  ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
"

# Check active connections
psql dbname -c "SELECT * FROM pg_stat_activity;"

# Kill stuck query
psql dbname -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid = 12345;"
```

### Query Optimization

```bash
# Analyze query performance
psql dbname -c "EXPLAIN ANALYZE
  SELECT u.*, o.total
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  WHERE u.created_at > '2025-01-01';"

# Check if index is being used
psql dbname -c "EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM users WHERE email = '[email protected]';"

# Find missing indexes
psql dbname -c "
  SELECT
    schemaname, tablename, attname, n_distinct, correlation
  FROM pg_stats
  WHERE schemaname = 'public' AND n_distinct > 100
  ORDER BY abs(correlation) DESC;
"
```

## MySQL

### Safe Patterns

```bash
# Backup before destructive ops
mysqldump -u root -p dbname > backup_$(date +%Y%m%d_%H%M%S).sql

# Safe transaction
mysql -u root -p -e "START TRANSACTION; UPDATE ...; COMMIT;" dbname

# Read-only session
mysql -u readonly_user -p dbname
```

### Common mysql Commands

```bash
# Connect
mysql -u username -p -h localhost dbname

# Show databases
mysql -u root -p -e "SHOW DATABASES;"

# Show tables
mysql -u root -p dbname -e "SHOW TABLES;"

# Describe table
mysql -u root -p dbname -e "DESCRIBE table_name;"

# Execute SQL file
mysql -u root -p dbname < migration.sql

# Query optimization
mysql -u root -p dbname -e "EXPLAIN SELECT * FROM users WHERE email = '[email protected]';"
```

## Safety Checklist

Before ANY database operation:

- [ ] **Backup exists** for destructive operations (ALTER, DROP, DELETE, UPDATE)
- [ ] **Correct database/schema** - verify with `SELECT current_database();` or `\c` in psql
- [ ] **Test on dev first** - never test in production
- [ ] **Use transactions** for multi-step operations
- [ ] **EXPLAIN first** for complex queries to check performance
- [ ] **Limit results** when exploring: `LIMIT 10`
- [ ] **Read-only user** for queries that don't need write access

## Migration Pattern

```bash
#!/bin/bash
# Safe migration workflow

DB="myapp_production"
MIGRATION="migrations/001_add_user_status.sql"
BACKUP="backups/pre_migration_$(date +%Y%m%d_%H%M%S).sql"

echo "1. Creating backup..."
pg_dump $DB > $BACKUP

echo "2. Testing migration on copy..."
createdb ${DB}_test
pg_dump $DB | psql ${DB}_test
psql ${DB}_test -f $MIGRATION

if [ $? -eq 0 ]; then
  echo "3. Migration test successful. Apply to production? (y/n)"
  read answer
  if [ "$answer" = "y" ]; then
    psql $DB -f $MIGRATION
    echo "Migration complete!"
  fi
else
  echo "Migration test failed. Check ${DB}_test database."
fi

# Cleanup test db
dropdb ${DB}_test
```

## Performance Debugging

### Find Slow Queries

```sql
-- PostgreSQL: Enable logging slow queries
ALTER DATABASE mydb SET log_min_duration_statement = 1000; -- Log queries >1s

-- Check current slow queries
SELECT pid, now() - query_start as duration, query
FROM pg_stat_activity
WHERE state = 'active'
  AND now() - query_start > interval '5 seconds';
```

### Index Usage

```sql
-- Find unused indexes (PostgreSQL)
SELECT
  schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
  AND indexname NOT LIKE '%_pkey'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Find tables without primary key
SELECT tablename
FROM pg_tables t
WHERE schemaname = 'public'
  AND NOT EXISTS (
    SELECT 1 FROM pg_indexes
    WHERE tablename = t.tablename
      AND indexdef LIKE '%PRIMARY KEY%'
  );
```

## Connection Management

```bash
# PostgreSQL: Check connection limits
psql dbname -c "SHOW max_connections;"
psql dbname -c "SELECT count(*) FROM pg_stat_activity;"

# Kill idle connections
psql dbname -c "
  SELECT pg_terminate_backend(pid)
  FROM pg_stat_activity
  WHERE state = 'idle'
    AND state_change < now() - interval '10 minutes';
"
```

## Guidelines

- **Always backup before destructive operations**
- **Use transactions** - BEGIN/COMMIT for safety, ROLLBACK to undo
- **Test queries on dev** - never experiment in production
- **EXPLAIN before executing** expensive queries
- **Use read-only users** when possible
- **Monitor performance** - check slow query logs
- **Index wisely** - analyze query patterns first
- **Avoid SELECT *** - specify columns needed
- **Use LIMIT** when exploring data
- **Connection pooling** for applications (pg_bouncer, etc.)

## Common Mistakes

**DON'T:**
- Run UPDATE/DELETE without WHERE clause
- Test queries directly in production
- Use SELECT * in application code
- Create indexes on every column
- Leave connections open
- Use root/superuser for application
- Store sensitive data unencrypted

**DO:**
- Always use WHERE in UPDATE/DELETE
- Test on dev/staging first
- Specify needed columns
- Analyze before indexing
- Close connections properly
- Use least-privilege users
- Encrypt sensitive data
