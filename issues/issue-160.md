# Issue #160: Microservices Decomposition Strategies

**State:** Open  
**Created:** 2026-03-29T11:43:41Z  
**Updated:** 2026-03-29T11:43:41Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/160

**Labels:** None

---

## Description

One of the hardest problems in microservices adoption is deciding **how to split** an application into services. Decomposing incorrectly leads to chatty services (too many inter-service calls), poor cohesion (unrelated logic bundled together), or tight coupling (services that cannot be deployed independently). This issue explores four decomposition strategies and the criteria that determine a successful split.

**Strategy 1 — Business Capabilities (Business/Customer Lens)**  
Decompose based on what the business *does* — the stable, high-level activities of the organisation. A Notes App has capabilities such as *Authentication*, *Note Management*, *Search*, *Notifications*, and *Billing*. Services mirror org chart responsibilities. This is Martin Fowler's recommended starting point because business capabilities rarely change even when technology does.

**Strategy 2 — Sub-Domain Separation (DDD Lens)**  
Using Domain-Driven Design (DDD), identify **bounded contexts**: Core Domain (the primary revenue driver — e.g., Notes Management), Supporting Subdomain (e.g., User Auth, Search), and Generic Subdomain (e.g., Email, Payments handled by third parties). Each bounded context maps to one or more microservices. This is the most rigorous approach and naturally prevents coupling by enforcing explicit context boundaries and anti-corruption layers.

**Strategy 3 — Entity Separation**  
Group service responsibilities around primary domain entities: a `User Service` owns everything about users, a `Note Service` owns everything about notes. Clean and intuitive, but risks creating anemic CRUD services with no encapsulated business logic. Works best for data-centric domains.

**Strategy 4 — Action/Verb Separation**  
Decompose by actions: `CreateNoteService`, `SearchService`, `ExportService`. This maps well to command-query responsibility segregation (CQRS) and event-sourced systems where write and read sides are different services. Most granular — risks over-decomposition.

**The Goal of Any Strategy**  
Regardless of approach, every valid decomposition should achieve: **high cohesion** (things that change together live together), **loose coupling** (services communicate via stable APIs not shared databases), **single responsibility** (one clear purpose per service), and **independent deployability** (each service ships without coordinating with others).

---

## Why This Matters

- Decomposition is a **one-way door** — poor initial boundaries require expensive refactoring later
- Wrong splits produce **distributed monoliths**: microservices in name, coupled monolith in practice
- Different strategies suit different team structures (Conway's Law: architecture mirrors org design)
- DDD sub-domain separation is the dominant industry approach for complex domains
- Understanding decomposition prevents the most common microservices anti-patterns

---

## Key Concepts

### Business Capabilities
Stable, high-level activities the organisation performs. Map services to capabilities, not to data or technology.

### Bounded Context (DDD)
A logical boundary within which a domain model is consistent and self-contained. Different bounded contexts can use the same word ("user") with different meanings.

### Cohesion
The degree to which elements inside a service belong together. High cohesion = the service has one clear purpose and all its code relates to that purpose.

### Coupling
The degree of interdependence between services. Loose coupling = a service can be deployed, scaled, and changed without affecting other services.

### Conway's Law
"Any organisation that designs a system will produce a design whose structure is a copy of the organisation's communication structure." — Plan your service boundaries around your team boundaries.

### Anti-Corruption Layer (ACL)
A translation layer between two bounded contexts that ensures changes in one context do not bleed into another.

---

## Learning Objectives

- [ ] Understand and apply all four decomposition strategies
- [ ] Identify bounded contexts in the Notes App domain using DDD
- [ ] Evaluate a proposed decomposition against cohesion and coupling metrics
- [ ] Recognise the distributed monolith anti-pattern and how to avoid it
- [ ] Apply Conway's Law when designing service boundaries for a team structure
- [ ] Produce a decomposition diagram for the Notes App microservices

---

## Tasks to Create

- `tasks/microservices/task-010-microservices-decomposition.md`

---

## Notes App Integration

The Notes App currently runs as a monolith or loosely separated services. Applying decomposition strategies reveals the natural service boundaries:

- **Business Capability split**: Auth Service, Notes Service, Search Service, Notification Service, Email Service
- **Sub-Domain split**: Core = Notes Management; Supporting = Auth, Search; Generic = Email (SendGrid), Payments
- **Entity split**: User Service, Note Service, Tag Service
- **Action split**: Write API (create/update/delete notes), Read API (list/get notes), Export Service

This task teaches learners to evaluate each split and choose the right boundaries before writing any code — the highest-leverage decision in microservices design.
