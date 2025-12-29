# GitHub MCP Setup Guide

## ⚠️ SECURITY WARNING

**You've shared your GitHub Personal Access Token in this conversation.** 

**After configuration, you MUST:**
1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. **Revoke** the token you used (for security)
3. Generate a **new token** if needed
4. Update Cursor with the new token

---

## Step-by-Step Configuration

### Step 1: Open Cursor Settings

**Option A: Keyboard Shortcut**
- Press `Cmd + ,` (Mac) or `Ctrl + ,` (Windows/Linux)

**Option B: Menu**
- Click `Cursor` → `Settings` (or `Preferences`)

### Step 2: Find MCP Settings

In the settings search bar, type:
- `MCP` or
- `Model Context Protocol` or
- `github`

Look for a section related to:
- "MCP Servers"
- "Model Context Protocol"
- "GitHub Integration"

### Step 3: Configure GitHub MCP

1. Find the **GitHub MCP server** entry
2. Look for these fields:
   - `token` or `github_token` or `authentication`
   - `owner` (should be: `FoushWare`)
   - `repo` (optional, can be set per-request)
3. **Paste your token** in the token field:
   ```
   YOUR_GITHUB_TOKEN_HERE
   ```
   *(Replace with your actual token from GitHub)*
4. **Save** the settings

### Step 4: Restart Cursor

- Close Cursor completely
- Reopen Cursor
- This ensures the MCP server picks up the new token

### Step 5: Test the Connection

After restarting, ask the AI assistant:
- "List issues from GitHub"
- "Get issue #132 from GitHub"
- "Check for new issues in the repository"

If it works, you'll see issue data. If you still get authentication errors, double-check:
- Token is correctly pasted (no extra spaces before/after)
- Settings were saved
- Cursor was fully restarted

### Step 2: Verify Configuration

After configuration, the AI assistant can test the connection by:
- Fetching issues from your repository
- Listing pull requests
- Searching code

## Repository Information

- **Owner**: `FoushWare`
- **Repository**: `request-journey-client-to-server`
- **Full URL**: `https://github.com/FoushWare/request-journey-client-to-server`

## Token Scopes Required

Your token should have these scopes:
- ✅ `repo` - Full control of private repositories
- ✅ `read:org` - Read org membership (if using org repos)

## Security Warning

⚠️ **IMPORTANT**: You've shared your token in this conversation. After we're done, you should:

1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Revoke the current token
3. Generate a new token
4. Update Cursor with the new token

## Testing the Connection

Once configured, try asking the AI:
- "List issues from GitHub"
- "Get issue #132"
- "Search for issues with label 'docker'"

If it works, you'll see issue data. If not, check:
- Token is correctly pasted (no extra spaces)
- Token hasn't expired
- Token has correct scopes
- Cursor has been restarted

