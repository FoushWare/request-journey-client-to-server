# Implementation Directory Structure

This directory contains implementation code for all tasks, organized by category and task number.

## Structure

Each task has the following structure:

```
implementation/
└── {category}/
    └── task-XXX-{task-name}/
        ├── starter/
        │   └── [Starting codebase for this task]
        ├── final-solution/
        │   └── [Complete solution for this task]
        └── README.md
```

## Dependency Chain

Tasks follow a dependency chain where:
- **Task 001 starter**: Base Notes App codebase (no Docker, no K8s, etc.)
- **Task 001 final-solution**: Complete solution for task 001
- **Task 002 starter**: Copy of Task 001 final-solution (if task 002 depends on task 001)
- **Task 002 final-solution**: Complete solution for task 002
- And so on...

## How to Use

### For Mentees (Learners)

1. **Read the task**: Go to `tasks/{category}/task-XXX.md` and read the full task description
2. **Copy starter code**: Copy the `starter/` directory to your working directory
3. **Implement the task**: Follow the task instructions to implement the solution
4. **Compare with final-solution**: After completing (or if stuck), review `final-solution/` to see the complete implementation
5. **Move to next task**: Use the final-solution as the starter for the next dependent task

### For Mentors

1. **Review task dependencies**: Check prerequisites in the task file
2. **Set up starter**: Copy the final-solution of prerequisite task(s) to the new task's starter/
3. **Create final-solution**: Implement the complete solution in final-solution/
4. **Update README**: Document what's in starter vs final-solution

## Categories

- **docker/**: Docker containerization tasks
- **kubernetes/**: Kubernetes orchestration tasks
- **ci-cd/**: CI/CD pipeline tasks
- **security/**: Security implementation tasks
- **logging/**: Logging and monitoring tasks
- **nginx/**: NGINX configuration tasks
- **ansible/**: Ansible automation tasks
- **aws/**: AWS cloud services tasks
- **terraform/**: Terraform infrastructure tasks
- **vault/**: HashiCorp Vault tasks
- **integration/**: Integration tasks
- **networking/**: Networking concepts tasks

## Base Starter

The base Notes App codebase is located at:
- `implementation/starter-notes-app/`

This is used as the starter for the first task in each category.






