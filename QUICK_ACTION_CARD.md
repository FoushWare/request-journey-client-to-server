# 🚀 QUICK ACTION CARD

**Print this or bookmark it!**

---

## ⚡ 5-Minute Quick Start

```bash
# 1. Read overview (1 min)
cat START_HERE.md

# 2. Sync GitHub issues (2 min)
./sync-github-issues.sh

# 3. Generate tasks (1 min)
./create-from-issues.sh all

# 4. Create feature branch (1 min)
git checkout develop
git checkout -b feature/issue-1-my-feature

# START CODING! 🎯
```

---

## 🔑 Essential Commands

### GitHub Sync
```bash
./sync-github-issues.sh                    # Sync all
./sync-github-issues.sh owner/repo         # Specific repo
export GITHUB_TOKEN=ghp_xxxxx
./sync-github-issues.sh                    # With token
```

### Generate Tasks
```bash
./create-from-issues.sh all                # All issues
./create-from-issues.sh 42                 # Issue #42
```

### Git Flow - Features
```bash
git checkout develop                       # Go to develop
git pull origin develop                    # Update
git checkout -b feature/issue-123-name     # New branch
git add .
git commit -m "feat: description"          # Commit
git push origin feature/issue-123-name     # Push
# Create PR on GitHub
```

### Git Flow - Release
```bash
git checkout -b release/1.1.0              # New release
# Edit version files
git commit -am "chore: bump to 1.1.0"      # Commit
git push origin release/1.1.0              # Push
# Create PR to master
# After merge:
git checkout master
git tag -a v1.1.0 -m "Release v1.1.0"     # Tag
git push origin v1.1.0                     # Push tag
```

### Git Flow - Hotfix
```bash
git checkout master                        # From master
git checkout -b hotfix/critical-issue      # New hotfix
# Fix issue
git commit -am "fix: critical issue"       # Commit
git push origin hotfix/critical-issue      # Push
# After merge to master:
git tag -a v1.0.1 -m "Hotfix v1.0.1"      # Tag
git push origin v1.0.1                     # Push tag
# Also merge to develop
```

---

## 📚 Documentation Quick Links

| Document | Time | Purpose |
|----------|------|---------|
| [START_HERE.md](START_HERE.md) | 5 min | Welcome & overview |
| [VISUAL_GUIDE.md](VISUAL_GUIDE.md) | 5 min | Visual guide |
| [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) | 30 min | Complete how-to |
| [GITFLOW_STRATEGY.md](GITFLOW_STRATEGY.md) | 20 min | Branching |
| [SCRIPT_USAGE_EXAMPLES.md](SCRIPT_USAGE_EXAMPLES.md) | 15 min | Examples |

---

## 🎯 Common Tasks

### I want to work on an issue
```bash
./sync-github-issues.sh          # Sync
./create-from-issues.sh 123      # Generate task
git checkout develop
git checkout -b feature/issue-123-name
# Follow task checklist in tasks/*/task-123.md
```

### I want to create a release
```bash
# Read: WORKFLOW_GUIDE.md → Release Process
git checkout -b release/1.1.0
# Update versions
git commit -am "chore: bump to 1.1.0"
git push origin release/1.1.0
# Create PR to master
```

### I want to fix a production bug
```bash
# Read: WORKFLOW_GUIDE.md → Hotfix Process
git checkout master
git checkout -b hotfix/issue-name
# Fix and commit
git push origin hotfix/issue-name
# Create PR to master
```

### I want to understand the workflow
```bash
cat WORKFLOW_GUIDE.md        # 30 min complete guide
cat GITFLOW_STRATEGY.md      # 20 min branching guide
```

---

## 🚨 Troubleshooting Quick Fixes

### "Too many commits in feature PR"
```bash
git rebase -i develop      # Squash commits
git push -f origin feature/branch-name
```

### "Branch out of sync"
```bash
git fetch origin
git rebase origin/develop
git push -f origin feature/branch-name
```

### "GitHub API rate limit"
```bash
export GITHUB_TOKEN=ghp_xxxxx
./sync-github-issues.sh
```

### "Script permission denied"
```bash
chmod +x sync-github-issues.sh
chmod +x create-from-issues.sh
```

---

## 📞 Need Help?

| Issue | Resource |
|-------|----------|
| Getting started | [START_HERE.md](START_HERE.md) |
| How to workflow | [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) |
| How to branch | [GITFLOW_STRATEGY.md](GITFLOW_STRATEGY.md) |
| Script help | [SCRIPT_USAGE_EXAMPLES.md](SCRIPT_USAGE_EXAMPLES.md) |
| Quick reference | [SETUP_COMPLETE.md](SETUP_COMPLETE.md) |
| Verify setup | [VERIFICATION_CHECKLIST.md](VERIFICATION_CHECKLIST.md) |
| Find anything | [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) |

---

## ✅ Setup Status

- ✅ Git Flow branches created
- ✅ GitHub sync script ready
- ✅ Task generation ready
- ✅ 9 comprehensive guides
- ✅ All scripts executable
- ✅ Ready for development

---

## 🎊 YOU'RE ALL SET!

Everything is ready. Start with:

```bash
cat START_HERE.md
./sync-github-issues.sh
./create-from-issues.sh all
git checkout develop
git checkout -b feature/issue-1-first-feature
# CODE! 🚀
```

---

## 💾 Save This File!

Print or bookmark this quick action card for easy reference.

**Date**: January 17, 2026  
**Status**: ✅ Complete  

---

**HAPPY CODING!** 🎉

*All documentation is in the project root.*  
*All scripts are ready to use.*  
*You've got everything you need.*  

---
