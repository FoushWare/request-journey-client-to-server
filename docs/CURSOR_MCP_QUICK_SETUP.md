# Quick Setup: GitHub MCP in Cursor

## Your Token
```
YOUR_GITHUB_TOKEN_HERE
```
*(Get your token from: https://github.com/settings/tokens)*

## Quick Steps

### 1. Open Cursor Settings
- Press `Cmd + ,` (Mac) or `Ctrl + ,` (Windows/Linux)

### 2. Search for MCP
- In the search bar at the top, type: **`MCP`**
- Or type: **`github`**

### 3. Find GitHub MCP Configuration
Look for one of these:
- "MCP Servers"
- "GitHub MCP"
- "Model Context Protocol"

### 4. Add Token
Find a field labeled:
- `token`
- `github_token` 
- `authentication`
- `api_key`

Paste your token there.

### 5. Save & Restart
- Click "Save" or close settings
- **Completely quit Cursor** (Cmd+Q on Mac)
- Reopen Cursor

### 6. Test
After restarting, ask the AI:
- "List GitHub issues"
- "Check for new issues"

---

## Alternative: Command Palette

1. Press `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows/Linux)
2. Type: **`MCP`** or **`GitHub`**
3. Look for commands like:
   - "MCP: Configure Server"
   - "GitHub: Set Token"
   - "MCP: Settings"

---

## If You Can't Find It

MCP might be configured through:
- Cursor's extension settings
- A separate MCP configuration panel
- Workspace-specific settings

Try:
1. Check the bottom-right corner for MCP status
2. Look in `Cursor` → `Preferences` → `Extensions` → `MCP`
3. Check if there's an MCP icon in the status bar

---

## After Configuration

Once configured, the AI assistant will be able to:
- ✅ List GitHub issues
- ✅ Get issue details
- ✅ Search issues
- ✅ Create/update issues
- ✅ Manage pull requests

---

## ⚠️ Security Reminder

**Never commit tokens to git! Always use placeholders in documentation.**

1. Go to: https://github.com/settings/tokens
2. Generate a token with `repo` scope
3. Configure it in Cursor (not in files)
4. Never share tokens in code or documentation

