# Task: Durable Execution with Restate

**Related Issue:** #151  
**Category:** Distributed Systems  
**Prerequisites:** Microservices basics, Docker, basic Kafka or async patterns helpful  
**Estimated Time:** 4–5 hours  
**Languages:** TypeScript (primary), Go (alternative)  
**Notes App Context:** Make the Notes App note-creation workflow durable using Restate

---

## Learning Objectives

- Understand what durable execution means and the problem it solves
- Compare durable execution to sagas, retries, and message queues
- Set up Restate server locally
- Build a durable workflow using the Restate SDK
- Handle failures and observe automatic recovery

---

## Theory Section

### The Problem: Unreliable Workflows

Consider the Notes App note-creation flow:
1. Validate user
2. Save note to database
3. Send welcome email (if first note)
4. Update search index

If step 3 fails, do you re-run step 2? What if it causes a duplicate?

Solutions without durable execution:
- **Try/catch + retry**: Manual, error-prone, duplicates possible
- **Sagas**: Complex to implement, error handling is explicit
- **Message queues**: Decoupled but hard to reason about state

### Durable Execution

Restate records every step your code takes. On crash/restart:
- It knows which steps completed
- It replays them without side effects
- It resumes from the first incomplete step

Your code looks like normal sequential code — Restate handles the durability.

```typescript
// This looks synchronous, but each step is automatically durable
const workflow = restate.workflow({
  name: "create-note",
  run: async (ctx, { userId, content }) => {
    await ctx.run("validate-user", () => validateUser(userId));
    const note = await ctx.run("save-note", () => saveNote(userId, content));
    await ctx.run("send-email", () => sendEmail(userId, note.id));
    await ctx.run("update-index", () => updateSearchIndex(note));
    return note;
  }
});
```

---

## Step-by-Step Instructions

### Step 1: Understand the Problem

**Objective:** Feel the pain before applying the solution

**Instructions:**
1. Read the official explainer: https://www.restate.dev/what-is-durable-execution
2. Watch the reference video (Arabic): https://www.youtube.com/watch?v=4nLqYtOffHg
3. Think about the Notes App workflow: what happens if the email step crashes after saving the note?

### Step 2: Set Up Restate Locally

**Instructions:**
```bash
docker run --name restate -d \
  -p 8080:8080 \
  -p 9070:9070 \
  docker.restate.dev/restatedev/restate:latest
```

Verify it's running: `curl http://localhost:9070/health`

### Step 3: Build a Simple Durable Service

**Instructions:**
1. Create a new TypeScript project
2. Install Restate SDK: `npm install @restatedev/restate-sdk`
3. Build a simple counter service with durable state
4. Crash the process mid-execution and observe it resume

### Step 4: Build the Notes App Workflow

**Instructions:**
1. Implement a `create-note` durable workflow with all 4 steps
2. Simulate a crash after step 2 (save note)
3. Restart the service and observe Restate replay the workflow from step 3
4. Verify no duplicate note was created

### Step 5: Compare to Saga Pattern

**Instructions:**
1. Think about how the same workflow would be implemented with sagas
2. Count the number of compensating actions needed
3. Note how durable execution simplifies the code

---

## Verification

1. Restate server is running locally
2. Simple durable service deployed and tested
3. Notes App workflow implemented
4. Crash simulation works — workflow resumes from correct step
5. No duplicate data created after crash/recovery

---

## Task Checklist

- [ ] Read durable execution documentation
- [ ] Set up Restate with Docker
- [ ] Built simple durable service
- [ ] Built Notes App workflow
- [ ] Simulated crash and recovery
- [ ] Compared to Saga pattern

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed
