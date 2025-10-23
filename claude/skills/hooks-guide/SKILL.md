---
name: hooks-guide
description: Event-driven automation with Claude Code hooks. Configure deterministic workflows without context overhead. THE BIGGEST WIN for productivity.
---

# Claude Code Hooks Guide

Hooks enable event-driven automation in Claude Code. They execute shell commands in response to events like tool calls, providing deterministic automation without consuming context.

## Why Hooks are THE BIGGEST WIN

**Hooks > Skills > MCPs** for automation:

1. **Zero context overhead** - Runs outside conversation
2. **Deterministic** - Same trigger = same action, every time
3. **Event-driven** - React to tool use automatically
4. **Fast** - No LLM reasoning required
5. **Reliable** - Shell commands, not probabilistic behavior

**Use hooks for:**
- Auto-formatting code
- Running tests after changes
- Safety checks before destructive operations
- Auto-commit patterns
- Build verification
- Logging and auditing

## Available Hook Types

```
PreToolUse          Runs BEFORE a tool is called
PostToolUse         Runs AFTER a tool is called (success or failure)
UserPromptSubmit    Runs when user submits a message
SessionStart        Runs when Claude Code session starts
SessionEnd          Runs when Claude Code session ends
```

## Hook Configuration Format

Hooks are configured in `~/.claude/settings.json` or `.claude/project.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} 2>/dev/null || true"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '[{{timestamp}}] {{tool_name}}' >> ~/.claude/activity.log"
          }
        ]
      }
    ]
  }
}
```

### Format Breakdown

- **Hook Type** (PreToolUse, PostToolUse, etc.) - Array of matcher objects
- **matcher** - Pattern to match (tool name like "Write", "Edit", or "*" for all)
- **hooks** - Array of command objects to execute
  - **type** - Always "command"
  - **command** - Shell command to run
  - **timeout** (optional) - Timeout in seconds

### Template Variables

Available in hook commands:

- `{{file_path}}` - File path from tool parameters (Write, Edit, Read)
- `{{tool_name}}` - Name of the tool being called
- `{{timestamp}}` - Current timestamp (ISO 8601)
- `{{prompt}}` - User's message (UserPromptSubmit only)
- `{{command}}` - Bash command being executed (Bash tool only)
- `{{cwd}}` - Current working directory

## Common Hook Patterns

### 1. Auto-Format on Write/Edit

**Problem:** Code not formatted consistently
**Solution:** Run formatter before writing files

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

**Advanced - Language-specific formatting:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "case '{{file_path}}' in *.js|*.jsx|*.ts|*.tsx) prettier --write {{file_path}};; *.py) black {{file_path}};; *.go) gofmt -w {{file_path}};; esac || true"
          }
        ]
      }
    ]
  }
}
```

### 2. Run Tests After Changes

**Problem:** Tests broken after file changes
**Solution:** Auto-run relevant tests after Edit/Write

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm test -- --findRelatedTests {{file_path}} --passWithNoTests || true"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "npm test -- --findRelatedTests {{file_path}} --passWithNoTests || true"
          }
        ]
      }
    ]
  }
}
```

**Only run in CI or on demand:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "[ \"$RUN_TESTS\" = \"1\" ] && npm test -- {{file_path}} || true"
          }
        ]
      }
    ]
  }
}
```

### 3. Safety Checks Before Destructive Operations

**Problem:** Accidentally delete important files
**Solution:** Warn before running dangerous bash commands

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{{command}}' | grep -qE 'rm -rf|DROP TABLE|DELETE FROM' && echo '⚠️  WARNING: Destructive command detected' || true"
          }
        ]
      }
    ]
  }
}
```

**Block dangerous operations:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo '{{command}}' | grep -q 'rm -rf /'; then echo 'BLOCKED: Dangerous command'; exit 1; fi"
          }
        ]
      }
    ]
  }
}
```

### 4. Auto-Commit Pattern

**Problem:** Want to track every change automatically
**Solution:** Git add + commit after Write/Edit

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "git add {{file_path}} && git commit -m 'Add {{file_path}}' || true"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "git add {{file_path}} && git commit -m 'Edit {{file_path}}' || true"
          }
        ]
      }
    ]
  }
}
```

**More descriptive commits:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "git add {{file_path}} && git commit -m 'Claude: Modified {{file_path}} at {{timestamp}}' || true"
          }
        ]
      }
    ]
  }
}
```

### 5. Logging and Auditing

**Problem:** Want to track all Claude Code activity
**Solution:** Log all tool use to file

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '[{{timestamp}}] {{tool_name}} {{file_path}}' >> ~/.claude/activity.log"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '[{{timestamp}}] USER: {{prompt}}' >> ~/.claude/conversation.log"
          }
        ]
      }
    ]
  }
}
```

### 6. Build Verification

**Problem:** Changes break build
**Solution:** Run build after file changes

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm run build --silent || echo 'Build failed after editing {{file_path}}'"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "npm run build --silent || echo 'Build failed after writing {{file_path}}'"
          }
        ]
      }
    ]
  }
}
```

**Only build on specific files:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "case '{{file_path}}' in src/*) npm run build;; esac || true"
          }
        ]
      }
    ]
  }
}
```

### 7. Lint on Save

**Problem:** Linting errors not caught early
**Solution:** Run linter after file changes

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "eslint {{file_path}} --fix || true"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "eslint {{file_path}} --fix || true"
          }
        ]
      }
    ]
  }
}
```

### 8. File Backup

**Problem:** Want backup before editing
**Solution:** Copy file before Edit

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "cp {{file_path}} {{file_path}}.backup-$(date +%s) || true"
          }
        ]
      }
    ]
  }
}
```

**Clean old backups:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "find . -name '*.backup-*' -mtime +7 -delete || true"
          }
        ]
      }
    ]
  }
}
```

### 9. Dependency Sync

**Problem:** package.json changed but dependencies not installed
**Solution:** Auto-install after package.json changes

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "[ '{{file_path}}' = 'package.json' ] && npm install || true"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "[ '{{file_path}}' = 'package.json' ] && npm install || true"
          }
        ]
      }
    ]
  }
}
```

### 10. Type Checking

**Problem:** TypeScript errors not caught early
**Solution:** Run type checker after changes

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "tsc --noEmit --pretty {{file_path}} || true"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "tsc --noEmit --pretty {{file_path}} || true"
          }
        ]
      }
    ]
  }
}
```

## Advanced Hook Patterns

### Multiple Commands Per Hook

**Run multiple commands in sequence:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} || true"
          },
          {
            "type": "command",
            "command": "eslint --fix {{file_path}} || true"
          },
          {
            "type": "command",
            "command": "git add {{file_path}} || true"
          }
        ]
      }
    ]
  }
}
```

### Conditional Execution

**Only in production environment:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "[ \"$ENV\" = \"production\" ] && echo 'WARNING: Production environment' || true"
          }
        ]
      }
    ]
  }
}
```

### Tool-Specific Hooks

**Different actions for different tools:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'File written: {{file_path}}' >> ~/.claude/activity.log"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'File edited: {{file_path}}' >> ~/.claude/activity.log"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Command executed: {{command}}' >> ~/.claude/activity.log"
          }
        ]
      }
    ]
  }
}
```

## Best Practices

### DO:
✅ Use `|| true` to prevent hook failures from blocking
✅ Keep hooks fast (<1s) for responsive UX
✅ Log hook activity for debugging
✅ Test hooks before deploying
✅ Use conditional execution for environment-specific hooks
✅ Document what each hook does

### DON'T:
❌ Run expensive operations (long builds, heavy tests)
❌ Fail without good reason (use `|| true`)
❌ Modify files unexpectedly (breaks user expectations)
❌ Use hooks for complex logic (use skills instead)
❌ Forget to handle errors gracefully
❌ Run interactive commands (hooks are non-interactive)

## Debugging Hooks

**Check hook output:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '[{{timestamp}}] {{tool_name}} triggered' >> /tmp/claude-hooks.log"
          }
        ]
      }
    ]
  }
}
```

**Verbose logging:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "set -x; echo 'Tool: {{tool_name}}' && set +x"
          }
        ]
      }
    ]
  }
}
```

**Test hook command directly:**
```bash
# Replace template variables manually
file_path="src/app.js"
prettier --write $file_path
```

## Example Configurations

### Minimal (Format + Lint)
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} || true"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} || true"
          }
        ]
      }
    ]
  }
}
```

### Moderate (Format + Lint + Test)
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} 2>/dev/null || true"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "eslint --fix {{file_path}} || true"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "eslint --fix {{file_path}} || true"
          },
          {
            "type": "command",
            "command": "npm test -- --findRelatedTests {{file_path}} --passWithNoTests || true"
          }
        ]
      }
    ]
  }
}
```

### Advanced (Full Automation)
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write {{file_path}} 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{{command}}' | grep -qE 'rm -rf|DROP TABLE|DELETE FROM' && echo '⚠️  WARNING: Destructive command' || true"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "eslint --fix {{file_path}} || true"
          },
          {
            "type": "command",
            "command": "git add {{file_path}} || true"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "eslint --fix {{file_path}} || true"
          },
          {
            "type": "command",
            "command": "npm test -- --findRelatedTests {{file_path}} --passWithNoTests || true"
          },
          {
            "type": "command",
            "command": "git add {{file_path}} || true"
          }
        ]
      },
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '[{{timestamp}}] {{tool_name}} {{file_path}}' >> ~/.claude/activity.log"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '[{{timestamp}}] {{prompt}}' >> ~/.claude/conversation.log"
          }
        ]
      }
    ]
  }
}
```

## Project-Specific vs Global Hooks

### Global Hooks (~/.claude/settings.json)
Use for universal patterns across all projects:
- Auto-formatting
- Activity logging
- Safety checks

### Project Hooks (.claude/project.json)
Use for project-specific workflows:
- Project-specific test commands
- Build processes
- Deployment hooks

## Troubleshooting

**Hook not running:**
- Check syntax in settings.json (valid JSON?)
- Verify matcher matches tool name exactly (case-sensitive)
- Check template variable usage
- Test command manually first

**Hook failing:**
- Add `|| true` to prevent blocking
- Check command has proper error handling
- Verify required tools are installed
- Check file permissions

**Hook too slow:**
- Move expensive operations to background
- Use conditional execution
- Consider async alternatives
- Profile hook execution time

## Summary

Hooks provide **event-driven deterministic automation** without context overhead. They're the most powerful way to enhance Claude Code because they:

1. Run automatically on events
2. Execute reliably (shell commands)
3. Don't consume conversation context
4. Work across all projects (global hooks)
5. Can be project-specific when needed

**Start simple** (auto-format) then add more hooks as needed. The combination of hooks + skills + selective MCPs creates the most powerful Claude Code setup.
