---
name: doc-search
description: Search documentation using gitmcp and Context7 when researching libraries, APIs, frameworks, or technical concepts. Get latest docs and GitHub resources.
---

# Documentation Search Skill

This skill orchestrates multiple documentation MCPs to provide comprehensive research results.

## When to Use

Use this skill when you need to:

- **Research libraries or frameworks** - Find docs for libraries you're using
- **Learn APIs** - Understand how to use external APIs
- **Investigate technical concepts** - Deep dive into technologies
- **Find code examples** - Locate real-world usage patterns
- **Check latest versions** - Get most up-to-date documentation

## Documentation Sources

### 1. Context7 MCP
- **Purpose**: Latest library documentation
- **Best for**: Official docs, API references, guides
- **Coverage**: Popular libraries and frameworks
- **Use when**: You need authoritative, up-to-date library docs

### 2. gitmcp
- **Purpose**: GitHub repository search and documentation
- **Best for**: README files, code examples, repo docs
- **Coverage**: Any GitHub repository
- **Use when**: You need code examples or repo-specific docs

## Search Strategy

### Step 1: Identify the Query
- What library/framework/concept?
- What specific feature or question?
- Need code examples or conceptual understanding?

### Step 2: Choose Sources
- **Context7 first** for official library docs
- **gitmcp** for code examples and repo-level docs
- **Use both** for comprehensive coverage

### Step 3: Synthesize Results
- Combine information from both sources
- Provide complete answer with examples
- Link to authoritative sources

## Examples

### Example 1: React Hook Usage
```
User: "How do I use useEffect with cleanup?"

Search Strategy:
1. Query Context7 for React documentation on useEffect
2. Search gitmcp for React repo examples
3. Synthesize: Official docs + real examples
4. Provide complete answer with code samples
```

### Example 2: Library Comparison
```
User: "What's the difference between Zustand and Redux?"

Search Strategy:
1. Query Context7 for both Zustand and Redux docs
2. Search gitmcp for READMEs and comparisons
3. Compare features, use cases, complexity
4. Provide informed recommendation
```

### Example 3: New Library Research
```
User: "How do I get started with Drizzle ORM?"

Search Strategy:
1. Query Context7 for Drizzle documentation
2. Search gitmcp for Drizzle repo (installation, quickstart)
3. Find code examples and common patterns
4. Provide setup guide with examples
```

## Tool Integration

This skill uses:
- `Context7` MCP - For latest library documentation
- `gitmcp` MCP - For GitHub repository documentation and examples

## Guidelines

- **Start with Context7** for official docs
- **Add gitmcp** for practical examples
- **Cite sources** when providing information
- **Provide code examples** when relevant
- **Check versions** to ensure up-to-date info
- **Synthesize clearly** - don't just dump raw results
