#!/usr/bin/env python3

"""
GitHub Issues Sync & Task/Plan Generation Tool
Analyzes local issues and generates/updates tasks and plans
"""

import os
import re
from pathlib import Path
from datetime import datetime

class IssuesAnalyzer:
    def __init__(self, workspace_path):
        self.workspace = Path(workspace_path)
        self.issues_dir = self.workspace / "issues"
        self.plans_dir = self.workspace / "plans"
        self.tasks_dir = self.workspace / "tasks"
        self.docs_dir = self.workspace / "docs"
        
    def analyze_issues(self):
        """Analyze local issues and count them"""
        issues = []
        if self.issues_dir.exists():
            issues = sorted([f.stem.replace("issue-", "") for f in self.issues_dir.glob("issue-*.md")])
        return issues
    
    def analyze_plans(self):
        """Count existing plans"""
        if self.plans_dir.exists():
            return len(list(self.plans_dir.glob("plan-*.md")))
        return 0
    
    def analyze_tasks(self):
        """Count existing tasks"""
        task_count = 0
        if self.tasks_dir.exists():
            for category_dir in self.tasks_dir.iterdir():
                if category_dir.is_dir():
                    task_count += len(list(category_dir.glob("task-*.md")))
        return task_count
    
    def analyze_docs(self):
        """Count existing implementation docs"""
        if self.docs_dir.exists():
            return len(list(self.docs_dir.glob("issue-*-implementation.md")))
        return 0
    
    def get_missing_artifacts(self, issues, max_check=50):
        """Find which issues are missing plans/tasks"""
        missing_plans = []
        missing_tasks = []
        
        check_issues = issues[:max_check] if len(issues) > max_check else issues
        
        for issue_num in check_issues:
            # Check plans
            plan_file = self.plans_dir / f"plan-issue-{issue_num}.md"
            if not plan_file.exists():
                missing_plans.append(issue_num)
            
            # Check tasks
            task_found = False
            if self.tasks_dir.exists():
                for category_dir in self.tasks_dir.iterdir():
                    if category_dir.is_dir():
                        if (category_dir / f"task-{issue_num}.md").exists():
                            task_found = True
                            break
            if not task_found:
                missing_tasks.append(issue_num)
        
        return missing_plans, missing_tasks
    
    def print_report(self):
        """Print analysis report"""
        print("\n╔════════════════════════════════════════════════════════════════╗")
        print("║       GitHub Issues Sync & Analysis Report                     ║")
        print("╚════════════════════════════════════════════════════════════════╝\n")
        
        # Analyze current state
        issues = self.analyze_issues()
        plans_count = self.analyze_plans()
        tasks_count = self.analyze_tasks()
        docs_count = self.analyze_docs()
        
        print(f"📊 CURRENT STATUS")
        print(f"   Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"   Workspace: {self.workspace}")
        print()
        
        print(f"📋 ISSUES")
        print(f"   Total Local Issues: {len(issues)}")
        if issues:
            print(f"   Issue Range: #{issues[0]} to #{issues[-1]}")
            print(f"   First 10: {', '.join(f'#{i}' for i in issues[:10])}")
            if len(issues) > 10:
                print(f"   Last 10: {', '.join(f'#{i}' for i in issues[-10:])}")
        print()
        
        print(f"📂 ARTIFACTS")
        print(f"   Plans: {plans_count} files")
        print(f"   Tasks: {tasks_count} files (across all categories)")
        print(f"   Docs: {docs_count} files")
        print()
        
        if issues:
            missing_plans, missing_tasks = self.get_missing_artifacts(issues)
            print(f"⚠️  MISSING ARTIFACTS (first 50 issues)")
            print(f"   Issues without plans: {len(missing_plans)}")
            if missing_plans and len(missing_plans) <= 10:
                print(f"      {', '.join(f'#{i}' for i in missing_plans[:10])}")
            print(f"   Issues without tasks: {len(missing_tasks)}")
            if missing_tasks and len(missing_tasks) <= 10:
                print(f"      {', '.join(f'#{i}' for i in missing_tasks[:10])}")
            print()
        
        print("╔════════════════════════════════════════════════════════════════╗")
        print("║               SYNCHRONIZATION WORKFLOW                         ║")
        print("╚════════════════════════════════════════════════════════════════╝\n")
        
        print("Step 1️⃣: SYNC Issues from GitHub")
        print("   Command: ./sync-github-issues.sh")
        print("   Purpose: Fetch latest issues, updates, and new issues from GitHub")
        print("   Output: Updates issues/ directory")
        print()
        
        print("Step 2️⃣: GENERATE Tasks & Plans")
        print("   Command: ./create-from-issues.sh all")
        print("   Purpose: Create/update tasks and plans for all issues")
        print("   Output: Updates tasks/, plans/, docs/ directories")
        print()
        
        print("Step 3️⃣: VERIFY Changes")
        print("   Commands:")
        print("      ls -la tasks/")
        print("      ls -la plans/")
        print("      ls -la docs/")
        print()
        
        print("Step 4️⃣: CREATE Feature Branch")
        print("   Commands:")
        print("      git checkout develop")
        print("      git pull origin develop")
        print("      git checkout -b feature/issue-XXX-description")
        print()
        
        print("Step 5️⃣: IMPLEMENT")
        print("   Follow task checklist: tasks/<category>/task-XXX.md")
        print("   Reference plan: plans/plan-issue-XXX.md")
        print("   Reference docs: docs/issue-XXX-implementation.md")
        print()
        
        print("Step 6️⃣: COMMIT")
        print("   Command: git add . && git commit -m 'feat: implement issue #XXX'")
        print("   Use semantic commit messages:")
        print("      feat: new feature")
        print("      fix: bug fix")
        print("      docs: documentation")
        print()
        
        print("Step 7️⃣: PUSH & CREATE PR")
        print("   Commands:")
        print("      git push origin feature/issue-XXX-description")
        print("      # Create PR on GitHub to develop branch")
        print()
        
        print("Step 8️⃣: MERGE to Develop")
        print("   After code review and approval")
        print("   Merge feature branch to develop")
        print()
        
        print("╔════════════════════════════════════════════════════════════════╗")
        print("║                 GIT FLOW STRATEGY                              ║")
        print("╚════════════════════════════════════════════════════════════════╝\n")
        
        print("Branch Hierarchy:")
        print("   master (production)")
        print("    ├── release/X.Y.Z (release branches)")
        print("    │    └── Merge back to master + develop")
        print("    │")
        print("    └── develop (integration)")
        print("         ├── feature/issue-XXX-name (your branches)")
        print("         ├── bugfix/issue-XXX-name")
        print("         └── ... (other features)")
        print()
        
        print("Workflow:")
        print("   1. Create feature branch FROM develop")
        print("   2. Implement feature")
        print("   3. Commit with semantic messages")
        print("   4. Push to remote")
        print("   5. Create PR to develop")
        print("   6. Get code review")
        print("   7. Merge to develop")
        print("   8. When ready: Create release/X.Y.Z from develop")
        print("   9. Create PR release/ → master")
        print("   10. Tag version on master")
        print()
        
        print("╔════════════════════════════════════════════════════════════════╗")
        print("║                  READY TO SYNC & GENERATE                      ║")
        print("╚════════════════════════════════════════════════════════════════╝\n")

if __name__ == "__main__":
    workspace = "/Users/a.fouad/SideProjects/Request-journey/request-journey-client-to-server"
    analyzer = IssuesAnalyzer(workspace)
    analyzer.print_report()
