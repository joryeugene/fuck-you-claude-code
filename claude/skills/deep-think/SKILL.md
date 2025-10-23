---
name: deep-think
description: Use for complex problem-solving, debugging, architecture decisions, performance optimization, or any task requiring >2 steps. Mandatory for non-trivial problems.
---

# Deep Think Skill

This skill enforces the use of `sequentialthinking-tools` MCP for complex reasoning and problem decomposition.

## When to Use

YOU MUST use this skill (and sequentialthinking-tools) for:

- **Complex problems** requiring multiple steps or approaches
- **Debugging** issues that aren't immediately obvious
- **Architecture decisions** involving trade-offs
- **Performance optimization** requiring systematic analysis
- **Code exploration** in unfamiliar codebases
- **Multiple possible solutions** needing evaluation
- **Uncertainty** about the best approach

## How It Works

1. **Problem Decomposition**: Break complex problems into manageable steps
2. **Hypothesis Generation**: Create multiple solution approaches
3. **Systematic Evaluation**: Analyze trade-offs and implications
4. **Verification**: Validate assumptions and test solutions
5. **Recommendation**: Provide well-reasoned final answer

## Examples

### Example 1: Debugging Performance Issue
```
User: "The app is slow when loading the dashboard"

Deep Think Process:
1. Identify what "slow" means (network, render, data processing?)
2. Form hypotheses (too many API calls, large data sets, inefficient rendering)
3. Plan investigation (check network tab, profile render, analyze queries)
4. Test each hypothesis systematically
5. Recommend specific optimizations based on findings
```

### Example 2: Architecture Decision
```
User: "Should we use REST or GraphQL for our API?"

Deep Think Process:
1. Understand requirements (data complexity, client needs, team expertise)
2. List pros/cons of each approach
3. Consider long-term implications
4. Evaluate based on specific project context
5. Recommend with clear reasoning
```

## Tool Integration

This skill primarily uses:
- `sequentialthinking-tools` - For structured reasoning and problem decomposition

## Guidelines

- **Always think before acting** - Don't jump to solutions
- **Be thorough** - Explore multiple angles
- **Show your work** - Make reasoning transparent
- **Verify assumptions** - Test before concluding
- **Provide clear recommendations** - End with actionable advice
