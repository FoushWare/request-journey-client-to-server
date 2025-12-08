# Task Template

Use this template when creating new tasks. Copy this structure and fill in the details specific to your task.

```markdown
# Task: [Category] - [Task Name for Notes App]

**Related Issue:** #XX  
**Prerequisites:** [List prerequisite tasks, e.g., "task-001", "task-002"]  
**Estimated Time:** [X hours/days]  
**Notes App Context:** [Brief description of how this applies to Notes App]

---

## Learning Objectives

By the end of this task, you will be able to:

- [Objective 1: e.g., "Understand what Dockerfiles are and how they work"]
- [Objective 2: e.g., "Create a multi-stage Dockerfile for Next.js applications"]
- [Objective 3: e.g., "Optimize Docker images for production use"]
- [Add more objectives as needed]

---

## Theory Section

### What is [Topic]?

[Comprehensive explanation of the topic, concepts, and why it matters]

**Key Concepts:**
- [Concept 1]: [Explanation]
- [Concept 2]: [Explanation]
- [Concept 3]: [Explanation]

**Why This Matters for Notes App:**
[Explain how this concept applies specifically to the Notes App]

**Real-World Context:**
[Explain how this is used in production environments]

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed prerequisite tasks: [list tasks]
- [ ] [Prerequisite 1: e.g., "Notes App codebase available"]
- [ ] [Prerequisite 2: e.g., "Docker installed and running"]
- [ ] [Prerequisite 3: e.g., "Basic understanding of [concept]"]

---

## Step-by-Step Instructions

### Step 1: [Action Name]

**Objective:** [What this step accomplishes]

**Instructions:**
1. [Detailed instruction 1]
2. [Detailed instruction 2]
3. [Detailed instruction 3]

**Commands/Code:**
\`\`\`bash
# Example command
command --option value
\`\`\`

**Expected Output:**
[What you should see]

**Troubleshooting:**
- **Issue**: [Common problem]
  - **Solution**: [How to fix it]

---

### Step 2: [Action Name]

[Repeat structure from Step 1]

---

### Step 3: [Action Name]

[Repeat structure from Step 1]

---

[Continue with additional steps as needed]

---

## Notes App Specifics

### How This Applies to Notes App

**Frontend (Next.js):**
- [How this applies to Notes App frontend]
- [Specific configuration or changes needed]

**Backend (Express):**
- [How this applies to Notes App backend]
- [Specific configuration or changes needed]

**Database:**
- [How this applies to Notes App database]
- [Specific configuration or changes needed]

**Integration:**
- [How components work together]
- [What needs to be tested]

---

## OpenShift Notes (if applicable)

### OpenShift-Specific Instructions

**Differences from Kubernetes:**
- [Difference 1]: [Explanation]
- [Difference 2]: [Explanation]

**OpenShift Commands:**
\`\`\`bash
# Instead of: kubectl [command]
# Use: oc [command]

oc get pods
oc create deployment notes-app-backend --image=notes-app-backend:latest
\`\`\`

**OpenShift-Specific Concepts:**
- [Concept 1]: [Explanation and how to use it]
- [Concept 2]: [Explanation and how to use it]

**When to Use OpenShift vs Kubernetes:**
[Guidance on when each is appropriate]

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. [Test 1: e.g., "Start the Notes App and verify it loads"]
2. [Test 2: e.g., "Log in and create a note"]
3. [Test 3: e.g., "Verify the note is saved and displayed"]

**Technical Verification:**
1. [Check 1: e.g., "Run `docker ps` and verify containers are running"]
2. [Check 2: e.g., "Check logs for errors"]
3. [Check 3: e.g., "Verify configuration is correct"]

**Commands to Run:**
\`\`\`bash
# Verification commands
docker ps
docker logs notes-app-frontend
curl http://localhost:3000
\`\`\`

**Expected Results:**
- [Expected result 1]
- [Expected result 2]
- [Expected result 3]

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: [Problem Description]**

**Symptoms:**
- [Symptom 1]
- [Symptom 2]

**Causes:**
- [Possible cause 1]
- [Possible cause 2]

**Solutions:**
1. [Solution 1 with steps]
2. [Solution 2 with steps]

**Prevention:**
- [How to avoid this issue]

---

**Issue 2: [Problem Description]**

[Repeat structure from Issue 1]

---

## Best Practices

### Security Best Practices
- [Security practice 1]: [Explanation]
- [Security practice 2]: [Explanation]

### Performance Best Practices
- [Performance practice 1]: [Explanation]
- [Performance practice 2]: [Explanation]

### Operational Best Practices
- [Operational practice 1]: [Explanation]
- [Operational practice 2]: [Explanation]

### Code Quality Best Practices
- [Code quality practice 1]: [Explanation]
- [Code quality practice 2]: [Explanation]

---

## Additional Resources

### Documentation
- [Official documentation link 1]
- [Official documentation link 2]
- [Tutorial or guide link]

### Learning Resources
- [Video tutorial or course]
- [Blog post or article]
- [Community resource]

### Tools
- [Tool 1]: [Description and link]
- [Tool 2]: [Description and link]

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: [Link to next task, e.g., `task-002-create-notes-app-backend-dockerfile.md`]
2. **Related Tasks**: 
   - [Related task 1]
   - [Related task 2]
3. **Future Learning**: [What concepts to explore next]

---

## Reflection Questions

Take a moment to reflect on what you learned:

1. [Question 1: e.g., "What is the purpose of multi-stage builds?"]
2. [Question 2: e.g., "How does layer caching improve build performance?"]
3. [Question 3: e.g., "What security considerations are important for Docker images?"]

**Document Your Learning:**
- Write down key concepts you learned
- Note any challenges you faced
- Document solutions you discovered
- Record questions for your mentor

---

## Task Checklist

Use this checklist to track your progress:

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Completed Step 1
- [ ] Completed Step 2
- [ ] Completed Step 3
- [ ] [Add more steps as needed]
- [ ] Verified Notes App functionality
- [ ] Completed all verification steps
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Documented learnings
- [ ] Ready to move to next task

---

## Notes

[Space for mentee to add their own notes, observations, or questions]

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]
