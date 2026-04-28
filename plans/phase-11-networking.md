# Phase 11 — Networking & Protocols

## Overview

Every request the Notes App handles travels through layers of the network stack. This phase builds deep understanding of what happens at each layer — from the physical signal to the HTTP/2 response. You will also integrate **gRPC** for high-performance service-to-service communication inside the cluster, replacing REST for internal calls between microservices.

## Prerequisites

- **Phase 03 complete** — Notes App running in Kubernetes (you will inspect live network flows)
- **Phase 10 complete** — App running on AWS (Route 53, VPC, security groups are live examples)
- Packet capture tools: `tcpdump`, Wireshark (optional)

## Learning Objectives

- Walk through all 7 OSI model layers and map them to the Notes App request journey
- Understand IP addressing, subnetting, CIDR notation, and AWS VPC network layout
- Trace a DNS resolution: browser → Route 53 → CloudFront → ELB → NGINX → backend
- Observe the TCP three-way handshake and TLS 1.3 handshake with `openssl s_client`
- Understand HTTP/1.1 vs HTTP/2 multiplexing and how it improves MFE loading
- Implement a gRPC service between Notes Service and Search Service
- Configure CORS policies across MFEs and the backend
- Understand BGP (conceptual), VPC peering, and AWS PrivateLink

## Task Sequence

Complete the following tasks **in order**:

### OSI Model Deep Dive (tasks 1–9)

1. `tasks/networking/task-001-study-osi-model-overview.md`
   > Draw the 7-layer OSI model. Map each layer to a component in the Notes App: Layer 7 → HTTP/REST, Layer 4 → TCP, Layer 3 → IP/VPC, Layer 2 → Ethernet (VPC ENI), Layer 1 → fibre (AWS data centre).

2. `tasks/networking/task-002-layer-1-physical-layer.md`
   > Understand bits, signals, and physical media. AWS context: fibre between AZs, 100 Gbps inter-AZ bandwidth.

3. `tasks/networking/task-003-layer-2-data-link-layer.md`
   > Understand MAC addresses, frames, and ARP. AWS context: VPC ENI (Elastic Network Interface) per EC2 instance.

4. `tasks/networking/task-004-layer-3-network-layer.md`
   > Understand IP packets, routing tables, CIDR, and subnetting. Design the Notes App VPC: `10.0.0.0/16`, public subnets `10.0.1.0/24`, private subnets `10.0.2.0/24`.

5. `tasks/networking/task-005-layer-4-transport-layer.md`
   > Understand TCP vs UDP, ports, the three-way handshake, connection states, and TCP flow control. Use `netstat` / `ss` to observe Notes App connections.

6. `tasks/networking/task-006-layer-5-session-layer.md`
   > Understand session management, TLS sessions, and session resumption. Map to JWT session handling in the Notes App.

7. `tasks/networking/task-007-layer-6-presentation-layer.md`
   > Understand data encoding: JSON serialisation, Gzip compression, Base64. Map to the Notes App API response format and NGINX compression.

8. `tasks/networking/task-008-layer-7-application-layer.md`
   > Deep-dive into HTTP/1.1, HTTP/2 (multiplexing, server push, header compression), DNS resolution flow, and HTTPS handshake.

9. `tasks/networking/task-009-draw-full-osi-model-diagram.md`
   > Create a complete annotated diagram showing a Notes App request (`GET /api/notes`) traversing all 7 layers from browser to PostgreSQL and back.

### Application Protocol Implementation (tasks 10–11)

10. `tasks/networking/task-010-implement-http-requests-polyfill.md`
    > Add retry logic, exponential backoff, and CORS headers to the Notes App frontend `fetch` calls. Handle network errors gracefully.

11. `tasks/networking/task-011-integrate-grpc.md`
    > Replace the REST call between Notes Service and Search Service with a gRPC call. Define a `.proto` file. Generate TypeScript stubs. Test with `grpcurl`.

## Key Networking Concepts by Phase Dependency

| Concept | Where you first encountered it | Deepened in Phase 11 |
|---------|-------------------------------|----------------------|
| DNS | Phase 10 (Route 53) | OSI Layer 7 task |
| TLS | Phase 05 (cert-manager) | Layer 6 / handshake detail |
| TCP | Phase 02 (Docker networking) | Layer 4 three-way handshake |
| VPC subnets | Phase 09 (Terraform vpc module) | Layer 3 IP routing |
| gRPC | Phase 14 (Microservices preview) | Full implementation here |

## Success Criteria

Before moving to Phase 12, verify:

- [ ] You can explain what happens at each OSI layer for a Notes App login request
- [ ] `openssl s_client -connect notes-app.com:443` shows TLS 1.3 negotiation details
- [ ] `curl --http2 -I https://notes-app.com` returns `HTTP/2 200`
- [ ] gRPC service between Notes and Search is working — `grpcurl` returns search results
- [ ] Diagram shows the full request journey from browser DNS lookup to PostgreSQL query
- [ ] CORS is correctly configured — cross-origin requests from `notes-app.com` work; requests from `evil.com` are blocked

---

## ➡️ Next Phase

**[Phase 12 — GitOps](./phase-12-gitops.md)**

Phase 12 eliminates manual `kubectl apply` commands. With GitOps, the cluster's desired state is stored in Git. **Argo CD** watches the Git repository and automatically syncs any changes to the EKS cluster — making Git the single source of truth for all infrastructure.
