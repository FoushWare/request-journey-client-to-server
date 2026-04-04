# Notes App — Ansible Automation

Ansible playbooks to **fully automate** the configuration, deployment, and hardening of the Notes App on any target environment.

## What This Automates

| Playbook | What It Does |
|---------|-------------|
| `site.yml` | Master playbook — runs all roles in the correct order |
| `playbooks/docker.yml` | Install Docker + Docker Compose, configure daemon |
| `playbooks/kubernetes.yml` | Install kubectl, helm, configure kubeconfig |
| `playbooks/notes-app.yml` | Deploy all Notes App services to K8s |
| `playbooks/monitoring.yml` | Deploy Prometheus + Grafana + Alertmanager via Helm |
| `playbooks/logging.yml` | Deploy ELK Stack (Elasticsearch + Kibana + Filebeat) |
| `playbooks/security.yml` | Harden servers, configure firewall, enable audit logging |

## Prerequisites

```bash
# Install Ansible
pip install ansible ansible-lint

# Install required collections
ansible-galaxy collection install community.docker community.kubernetes amazon.aws

# Test connection to hosts
ansible all -m ping -i inventory/hosts.ini
```

## Usage

```bash
# Full deployment (all roles)
ansible-playbook site.yml -i inventory/hosts.ini

# Single playbook
ansible-playbook playbooks/docker.yml -i inventory/hosts.ini

# Dry run (check mode)
ansible-playbook site.yml -i inventory/hosts.ini --check

# Deploy only to staging
ansible-playbook site.yml -i inventory/staging.ini

# Run specific tags
ansible-playbook site.yml -i inventory/hosts.ini --tags security
ansible-playbook site.yml -i inventory/hosts.ini --tags monitoring

# With verbose output
ansible-playbook site.yml -i inventory/hosts.ini -vv
```

## Directory Structure

```
automation/ansible/
├── site.yml                  # Master playbook
├── README.md                 # This file
├── ansible.cfg               # Ansible configuration
├── requirements.yml          # Galaxy collection dependencies
│
├── inventory/
│   ├── hosts.ini             # Development inventory
│   ├── staging.ini           # Staging inventory
│   └── group_vars/
│       ├── all.yml           # Variables for all hosts
│       ├── k8s_nodes.yml     # Variables for K8s nodes
│       └── monitoring.yml    # Monitoring configuration
│
└── roles/
    ├── docker/               # Install and configure Docker
    ├── kubernetes/           # K8s tools and configuration
    ├── notes-app/            # Notes App deployment
    ├── monitoring/           # Prometheus + Grafana
    └── security/             # Server hardening
```
