# Phase 08 — Ansible Automation

## Overview

Everything configured manually in Phases 02–07 must be reproducible. **Ansible** is the configuration management tool that automates server setup: installing Docker, deploying the Notes App, configuring NGINX, setting up monitoring, and hardening the OS. A single `ansible-playbook site.yml` command should bring a brand-new server from zero to a fully running Notes App.

## Prerequisites

- **Phase 02 complete** — Docker setup understood
- **Phase 03 complete** — Kubernetes concepts understood (Ansible will also deploy to K8s)
- **Phase 05 complete** — Security hardening requirements known (Ansible will enforce them)
- **Phase 06 complete** — Monitoring tools to be deployed with Ansible
- **Phase 07 complete** — NGINX configuration to be automated with Ansible
- At least one target server (VM, EC2 instance, or Vagrant VM) reachable via SSH

## Learning Objectives

- Understand Infrastructure as Code principles: idempotency, declarative configuration, desired state
- Write Ansible inventory files (static and dynamic)
- Create playbooks: plays, tasks, handlers, variables, and conditionals
- Organise reusable Ansible roles (docker, kubernetes, notes-app, monitoring, security)
- Use `ansible-vault` to encrypt sensitive variables (passwords, API keys)
- Run the full Notes App deployment with one command on a clean server
- Automate Docker installation and container deployment
- Automate Kubernetes manifest application
- Automate NGINX installation and virtual host configuration
- Automate monitoring stack deployment (Prometheus + Grafana)

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/ansible/task-001-install-ansible.md`
   > Install Ansible on the control node. Understand the architecture: control node → managed nodes over SSH. Verify `ansible --version`.

2. `tasks/ansible/task-002-create-inventory.md`
   > Write a static inventory file grouping servers into `[web]`, `[app]`, `[db]`, `[k8s]`. Test connectivity with `ansible all -m ping`.

3. `tasks/ansible/task-003-write-package-install-playbook.md`
   > Write a playbook that installs `git`, `curl`, `htop`, `vim` on all servers. Run it twice — verify the second run makes zero changes (idempotency).

4. `tasks/ansible/task-004-write-backend-deploy-playbook.md`
   > Write a playbook that clones the Notes App backend repo, copies the `.env` file, runs `npm install`, starts the app with PM2 or as a systemd service. Test with `curl http://<server>/api/health`.

5. `tasks/ansible/task-005-write-frontend-deploy-playbook.md`
   > Write a playbook that builds the Next.js Shell App, copies the build output to the web server, and configures NGINX to serve it.

6. `tasks/ansible/task-006-use-ansible-vault.md`
   > Encrypt `vars/secrets.yml` containing `db_password`, `jwt_secret`, `aws_access_key` with `ansible-vault encrypt`. Decrypt at runtime with `--ask-vault-pass`. Never commit plaintext secrets to Git.

7. `tasks/ansible/task-007-automate-docker-deployment.md`
   > Write a role `docker` that installs Docker, starts the daemon, and runs `docker-compose up -d` for the Notes App stack. The role is idempotent — re-running it does not restart healthy containers.

8. `tasks/ansible/task-008-automate-kubernetes-deployment.md`
   > Write a role `kubernetes` that applies all manifests from the `k8s/` directory via `kubectl apply -f`. Verify pod status after each run.

9. `tasks/ansible/task-009-automate-nginx-configuration.md`
   > Write a role `nginx` that installs NGINX, templates the `nginx.conf` (using Jinja2), and reloads NGINX when the config changes (via a handler).

10. `tasks/ansible/task-010-automate-monitoring-setup.md`
    > Write a role `monitoring` that deploys Prometheus, Grafana, and Filebeat using Docker Compose. Grafana datasources are provisioned automatically.

## Master Playbook Structure

By the end of this phase you will have:

```
automation/ansible/
├── site.yml                  ← Master playbook (runs all roles)
├── inventory/
│   ├── hosts                 ← Static inventory
│   └── group_vars/
│       ├── all.yml           ← Shared variables
│       └── web.yml           ← Web-server-specific variables
├── vars/
│   └── secrets.yml           ← Encrypted with ansible-vault
└── roles/
    ├── docker/               ← Install Docker, run Compose
    ├── kubernetes/           ← Apply K8s manifests
    ├── notes-app/            ← Deploy Notes App (PM2 or Docker)
    ├── monitoring/           ← Prometheus + Grafana + Filebeat
    └── security/             ← OS hardening, firewall, fail2ban
```

## Success Criteria

Before moving to Phase 09, verify:

- [ ] `ansible all -m ping` returns `pong` for all target servers
- [ ] `ansible-playbook site.yml` runs to completion with `failed=0` on a clean server
- [ ] Notes App is accessible at `http://<server>` after running the playbook on a new server
- [ ] Re-running the playbook on an already-configured server produces `changed=0` (idempotent)
- [ ] Secrets in `vars/secrets.yml` are encrypted — the file shows `$ANSIBLE_VAULT;1.1;AES256` if opened in a text editor
- [ ] NGINX virtual host is configured correctly via the Jinja2 template
- [ ] Monitoring stack is deployed and Grafana is accessible at `http://<server>:3000`

---

## ➡️ Next Phase

**[Phase 09 — Terraform & Infrastructure as Code](./phase-09-terraform-iac.md)**

Ansible configures existing servers. **Terraform** creates the servers themselves — VPC, subnets, EC2 instances, EKS cluster, RDS, S3, IAM roles — on AWS. Phase 09 provisions the entire cloud infrastructure with code.
