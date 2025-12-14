# Architecture Diagrams

## High-Level Infrastructure

This diagram illustrates the high-level infrastructure components managed by this project on DigitalOcean.

```mermaid
graph TD
    classDef person fill:#08427b,color:white,stroke:#052e56,stroke-width:2px;
    classDef system fill:#1168bd,color:white,stroke:#0b4d8c,stroke-width:2px;
    classDef boundary fill:white,stroke:#444444,stroke-width:2px,stroke-dasharray: 5 5;
    classDef container fill:#438dd5,color:white,stroke:#336fa3,stroke-width:2px;

    Admin[DevOps Engineer]:::person
    GitHub[GitHub]:::system
    TFC[Terraform Cloud]:::system
    Doppler[Doppler]:::system

    subgraph DO[DigitalOcean Cloud]
        direction TB
        VPC[VPC - 10.x.0.0/24]:::system
        
        subgraph K8S[Kubernetes Cluster DOKS]
            AppPool[Application Node Pool]:::container
            MonPool[Monitoring Node Pool]:::container
        end
    end

    Admin -->|Pushes code| GitHub
    GitHub -->|Triggers| TFC
    TFC -->|Provisions| VPC
    TFC -->|Fetches secrets| Doppler
    K8S -.->|Resides in| VPC

    %% Styling for subgraph (simulating Boundary)
    style DO fill:#transparent,stroke:#000000,stroke-width:2px,stroke-dasharray: 5 5
    style K8S fill:#f0f0f0,stroke:#666666,stroke-width:2px
```

## Kubernetes Node Pools Strategy

We use a dedicated node pool strategy to isolate monitoring workloads from application workloads to ensure observability stability during high load.

```mermaid
graph TD
    subgraph Cluster[DOKS Cluster]
        
        subgraph App_Pool[Application Pool]
            style App_Pool fill:#e1f5fe,stroke:#01579b
            N1[Node 1]
            N2[Node 2]
            AS1[Auto-Scaler] -.-> N1
            AS1 -.-> N2
        end
        
        subgraph Mon_Pool[Monitoring Pool]
            style Mon_Pool fill:#fff3e0,stroke:#e65100
            M1[Mon Node 1]
            M2[Mon Node 2]
        end
        
        TaintMon[Taint: service=monitoring] -.-> M1
        TaintMon -.-> M2
        TaintApp[Taint: service=app] -.-> N1
        TaintApp -.-> N2
        
        Prom[Prometheus] --> M1
        Graf[Grafana] --> M2
        App[Web App] --> N1
        Worker[Worker] --> N2
        
    end
```
