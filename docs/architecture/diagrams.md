# Architecture Diagrams

## High-Level Infrastructure

This diagram illustrates the high-level infrastructure components managed by this project on DigitalOcean.

```mermaid
C4Context
    title Infrastructure Architecture

    Person(admin, "DevOps Engineer", "Manages infrastructure via Terraform & GitOps")
    
    System_Ext(github, "GitHub", "Source Code & CI/CD")
    System_Ext(tfc, "Terraform Cloud", "State Management & Locking")
    System_Ext(doppler, "Doppler", "Secrets Management")

    Boundary(do, "DigitalOcean Cloud", "Environment: Dev / Stage / Prod") {
        System(vpc, "VPC", "Private Network (10.x.0.0/24)")
        
        Boundary(k8s, "Kubernetes Cluster (DOKS)", "Orchestration") {
            Container(app_pool, "Application Node Pool", "Worker Nodes", "Runs application workloads")
            Container(mon_pool, "Monitoring Node Pool", "Worker Nodes", "Runs Prometheus, Grafana, etc.")
        }
    }

    Rel(admin, github, "Pushes code, triggers actions")
    Rel(github, tfc, "Triggers runs via API")
    Rel(tfc, do, "Provisions resources")
    Rel(tfc, doppler, "Fetches secrets")
    Rel(k8s, vpc, "Resides in")
```

## Kubernetes Node Pools Strategy

We use a dedicated node pool strategy to isolate monitoring workloads from application workloads to ensure observability stability during high load.

```mermaid
graph TD
    subgraph Cluster[DOKS Cluster]
        
        subgraph AppPool[Application Pool]
            style AppPool fill:#e1f5fe,stroke:#01579b
            N1[Node 1]
            N2[Node 2]
            AS[Auto-Scaler] -.-> AppPool
        end
        
        subgraph MonPool[Monitoring Pool]
            style MonPool fill:#fff3e0,stroke:#e65100
            M1[Mon Node 1]
            M2[Mon Node 2]
        end
        
        Taint[Taint: service=monitoring] --> MonPool
        TaintApp[Taint: service=app] --> AppPool
        
        Prom[Prometheus] --> M1
        Graf[Grafana] --> M2
        App[Web App] --> N1
        Worker[Worker] --> N2
        
    end
```
