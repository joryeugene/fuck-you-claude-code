---
name: mcp-debug
description: Debug and troubleshoot MCP server connection issues, configuration problems, and integration errors. Use when MCPs fail to connect or behave unexpectedly.
---

# MCP Debug Skill

This skill helps diagnose and fix MCP (Model Context Protocol) server issues.

## When to Use

Use this skill when:

- **MCP fails to connect** - Server shows ✗ in `claude mcp list`
- **MCP behaves unexpectedly** - Tools not working as expected
- **Adding new MCP** - Verify it's configured correctly
- **Configuration errors** - Fix MCP setup issues
- **Tool errors** - Debug MCP tool invocation problems

## Diagnostic Checklist

### 1. Check MCP Server Status

```bash
claude mcp list
```

**Look for:**
- ✓ Connected - Server is working
- ✗ Failed to connect - Server has issues

### 2. Common Connection Issues

#### Issue: "Failed to connect"

**Possible causes:**
1. **Command not found** - MCP executable not installed
2. **Wrong command** - Typo or incorrect path
3. **Missing dependencies** - npm packages not installed
4. **Permissions** - Script not executable
5. **Environment vars** - Missing required env variables

**Debugging steps:**
```bash
# Test the command directly
npx -y <package-name>

# Check if it's installed globally
which <command-name>

# Verify npm package exists
npm info <package-name>

# Check file permissions (for local scripts)
ls -la <script-path>
```

#### Issue: "Package not found"

**Solution:**
1. Verify package name is correct
2. Install manually first: `npm install -g <package>`
3. Clone and build from source if needed
4. Check if package is on npm registry

### 3. Configuration Problems

#### Stdio MCPs (most common)

**Correct format:**
```bash
claude mcp add --scope user <name> -- npx -y <package-name>
claude mcp add --scope user <name> -- node /path/to/script.js
claude mcp add --scope user <name> -- <executable-command>
```

**Common mistakes:**
```bash
# ❌ Missing -- separator
claude mcp add --scope user name npx package

# ❌ Wrong command format
claude mcp add --scope user name "npx -y package"

# ✅ Correct
claude mcp add --scope user name -- npx -y package
```

#### HTTP MCPs

**Correct format:**
```bash
claude mcp add --scope user --transport http <name> <url>
```

**With headers:**
```bash
claude mcp add --scope user --transport http \
  --header "Authorization: Bearer token" \
  <name> <url>
```

#### Environment Variables

**Add with -e flag:**
```bash
claude mcp add --scope user <name> \
  -e API_KEY=your_key \
  -e DEBUG=true \
  -- npx -y <package>
```

### 4. Verify MCP Configuration

**Check the config:**
```bash
claude mcp get <name>
```

**Look for:**
- Correct command/URL
- Proper environment variables
- Right transport type
- No typos

### 5. Test MCP Functionality

After fixing connection:

1. **List tools available:**
   - MCP should appear in available tools
   - Check tool descriptions make sense

2. **Try a simple operation:**
   - Test basic MCP functionality
   - Verify it responds correctly

3. **Check for errors:**
   - Watch for timeout errors
   - Look for authentication failures
   - Monitor for unexpected responses

## Common MCP Configurations

### simple-memory

```bash
# Install from source
cd /tmp
git clone https://github.com/chrisribe/simple-memory-mcp.git
cd simple-memory-mcp
npm run setup

# Add to Claude Code
claude mcp remove simple-memory  # if exists
claude mcp add --scope user simple-memory -- simple-memory
```

### sequentialthinking-tools

```bash
claude mcp add --scope user sequentialthinking-tools \
  -- npx -y mcp-sequentialthinking-tools
```

### gitmcp

```bash
claude mcp add --scope user gitmcp \
  -- npx mcp-remote https://gitmcp.io/docs
```

### Context7

```bash
claude mcp add --scope user Context7 \
  -- npx -y @upstash/context7-mcp@latest
```

### GitHub (with token)

```bash
claude mcp add --scope user github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=your_token \
  -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN \
     ghcr.io/github/github-mcp-server
```

## Troubleshooting Workflow

### Step 1: Identify the Problem
```bash
# Check which MCPs are failing
claude mcp list

# Get details on specific MCP
claude mcp get <name>
```

### Step 2: Test Command Directly
```bash
# Try running the MCP command manually
<command-from-config>

# Example:
npx -y mcp-sequentialthinking-tools
```

### Step 3: Fix Configuration
```bash
# Remove broken MCP
claude mcp remove <name>

# Re-add with correct configuration
claude mcp add --scope user <name> -- <correct-command>
```

### Step 4: Verify Fix
```bash
# Check status
claude mcp list

# Should show ✓ Connected
```

### Step 5: Test Functionality
- Restart Claude Code (if needed)
- Try using the MCP tools
- Verify expected behavior

## Quick Reference

### MCP Management Commands

```bash
# List all MCPs and their status
claude mcp list

# Get details about specific MCP
claude mcp get <name>

# Add MCP at user level (available everywhere)
claude mcp add --scope user <name> -- <command>

# Remove MCP
claude mcp remove <name>

# Reset all project-level MCP approvals
claude mcp reset-project-choices
```

### Scope Options

- `--scope user` - Available in all projects (RECOMMENDED)
- `--scope local` - Only in current directory
- `--scope project` - In current git repository

## Common Error Messages

### "No versions available for <package>"
**Problem**: Package doesn't exist on npm
**Solution**: Install from source or verify package name

### "Command not found"
**Problem**: Executable not in PATH
**Solution**: Use full path or install globally

### "Permission denied"
**Problem**: Script not executable
**Solution**: `chmod +x <script-path>`

### "Module not found"
**Problem**: Missing dependencies
**Solution**: `npm install` in package directory

## Best Practices

1. **Always use `--scope user`** for global availability
2. **Test commands manually first** before adding to config
3. **Use `--` separator** for stdio MCPs with npx
4. **Check `claude mcp list` regularly** to catch failures early
5. **Keep MCP configs simple** - easier to debug
6. **Document custom MCPs** - remember what they do

## Getting Help

If stuck:
1. Check MCP's GitHub repo for issues
2. Verify you're using latest version
3. Look for similar configurations online
4. Test with minimal config first
5. Check Claude Code documentation
