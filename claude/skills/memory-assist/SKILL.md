---
name: memory-assist
description: Store and retrieve project knowledge, user preferences, architectural decisions, and solutions using simple-memory MCP. Use after solving complex problems or learning new information.
---

# Memory Assist Skill

This skill helps you use `simple-memory` MCP to build persistent knowledge across conversations.

## When to Use

YOU MUST use this skill to store:

- **Solutions to complex problems** - So they're not lost
- **User preferences** - Remember choices and patterns
- **Architectural decisions** - Document why things were done
- **Project knowledge** - Build understanding of codebases
- **Patterns and learnings** - Capture insights for reuse
- **Mistakes and fixes** - Remember what didn't work and why

## Core Operations

### 1. Store Memory
```javascript
// After solving a complex problem
store-memory(
  content: "Solution for X performance issue: Used Y approach because Z",
  tags: ["performance", "optimization", "project-name"]
)
```

### 2. Search Memory
```javascript
// When encountering similar problems
search-memory(
  query: "performance optimization",
  tags: ["project-name"],
  limit: 5
)
```

### 3. Memory Stats
```javascript
// Check what's stored
memory-stats()
```

## Tagging Strategy

**Use descriptive, consistent tags:**

- **Project tags**: `project-name`, `feature-name`
- **Type tags**: `preference`, `decision`, `solution`, `learning`, `bug-fix`
- **Technology tags**: `typescript`, `react`, `postgres`, `etc`
- **Domain tags**: `performance`, `security`, `testing`, `architecture`

## Examples

### Example 1: Store Solution
```
After fixing a complex bug:

Content: "Fixed infinite re-render in UserProfile by moving useState
         outside useEffect. The issue was caused by state updates
         triggering effect re-runs."
Tags: ["bug-fix", "react", "hooks", "project-x"]
```

### Example 2: Store Preference
```
User mentions they prefer TypeScript strict mode:

Content: "User prefers TypeScript strict mode enabled for all projects.
         Helps catch bugs early and enforces better typing."
Tags: ["preference", "typescript", "coding-standards"]
```

### Example 3: Store Architecture Decision
```
After choosing database:

Content: "Chose PostgreSQL over MongoDB for user management system
         because: 1) Complex relational data, 2) ACID compliance needed,
         3) Team has more Postgres experience"
Tags: ["architecture", "decision", "database", "postgres", "project-y"]
```

### Example 4: Search and Recall
```
User asks about previous performance work:

1. search-memory(query: "performance", tags: ["project-x"])
2. Retrieve past optimizations
3. Apply similar patterns to new problem
```

## Auto-Capture Guidelines

**Automatically store WITHOUT asking:**
- Solutions to non-trivial problems
- User-stated preferences
- Architectural decisions made during conversation
- Learnings and insights
- Bug fixes and their causes

**DO NOT store:**
- Casual conversation
- Temporary information
- Sensitive data (unless user explicitly requests)

## Tool Integration

This skill uses:
- `simple-memory` MCP - For persistent knowledge storage

## Memory Hygiene

- **Be specific** - Vague memories aren't useful later
- **Include context** - Why something was done matters
- **Use consistent tags** - Makes searching easier
- **Link related concepts** - Use autoLink feature
- **Review periodically** - Check memory-stats to see what's stored

## Silent Operation

Store memories **silently** during conversations. Don't announce "I'm storing this to memory" - just do it when appropriate. The goal is seamless knowledge persistence.
