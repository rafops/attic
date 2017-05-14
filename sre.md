# Site Reliability Engineering

## 1. Introduction

- Development and Operations
- Software Engineers to create systems to accomplish the work performed by sysadmins
- Software Engineer designing an operations team
- Software Engineers + UNIX system internals + Networking (Layer 1–3)
- Time spent: <=50% Tickets, On-call, manual tasks; 50% Development (automation)
- Specific implementation of DevOps with some idiosyncratic (peculiar) extensions
- Responsibilities: Availability, Latency, Performance, Efficiency, Change Management, Monitoring, Emergency response, and capacity planning of the services
- On call shift: Handle event accurately, clean up and restore normal service, conduct a postmortem.
- Postmortem: Find all root causes, assign actions to correct or improve how will be addressed next time.

- Service error budget => 1 - Availability. Example: (1 - 0.9999 = 0.0001 or 0.01%)
- 14min24sec == 0.01% of 24h
- How to spend error budget? Innovation

- Monitoring:
  - Monitoring should never require a human to interpret alerting. Instead, they should be notified only they need to take action.
  - Alerts: human needs to take action immediately
  - Tickets: Human needs to take action, but not immediately
  - Logging: Information is recorded for diagnostic or forensic purposes
  - Mean time to failure (MTTF)
  - Mean time to repair (MTTR)

- On-call engineer is armed with a playbook
- Engineers exercise “Wheel of Misfortune” (Disaster Role Playing) to prepare to react to on-call events
- 70% of outages are due to changes in a live system

- Changes best practices:
  - Progressive rollouts
  - Quickly and accurately detecting problems
  - Rolling back changes safely

- Capacity Planing:
  - Organic growth: Progressive product adoption
  - Inorganic growth: Feature launches, Marketing campaigns

- Provisioning: Change management + Capacity planning

- Efficiency and Performance:
  - Resource use is a function of demand (load), capacity, and software efficiency


## 2. The Production Environment at Google, from the Viewpoint of an SRE

- Google Borg (Cluster Operating System); Similar to Apache Mesos
- Google Borg descendant: Kubernetes (open source Container Cluster orchestration)
- Open source cluster filesystems: Lustre, Hadoop Distributed File System (HDFS)

- Colossus is the successor to GFS (Google File System):
  - Bigtable (A NoSQL database, eventually consistent, cross-datacenter replication)
  - Spanner (An SQL-like interface for real consistency)
  - Blobstore

- Networking:
  - OpenFlow and “dumb” switching components
  - Global Software Load Balancer (GSLB); Geographic, service (YouTube, Maps), and RPC level
  - gRPC (uses “protobuf”, similar to Apache's Thrift)
