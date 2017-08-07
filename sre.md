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

## 3. Embracing Risk

- Users don't notice the difference between high reliability and extreme reliability.
- Unplanned downtime.
- availability = uptime / (uptime + downtime)
- request success rate: agregate availability = successful requests / total requests. requests as viewed from the end-user perspective. useful for systems that doesn't run constantly (eg: batch system).
- Is the cost of improving availability exceed the projected increase in revenue?
- typical background error rate for ISPs between 0.01% and 1%
- Product development performance is largely evaluated on product velocity, while SRE performance is evaluated based upon reliability of a service, which implies an incentive to push back against a high rate of change.
- The error budget provides a clear metric that determines how unreliable the service is allowed to be, removing the politics from negotiation between SREs and product developers (how much risk to allow).
- SLO: Service Level Objectives, per quarter.
- As long there is error budget remaining, new releases can be pushed.

## 4. Service Level Objectives

- Service Level Indicators (SLI): Basic properties of metrics.
  - Request latency.
  - Error rate.
  - System throughput.
  - Availability.
- How data is aggregated (require a bit of statistics here). Examples:
  - 99% (averaged over 1 minute) of requests complete in less than 100 ms.
  - 90% requests in less than 1 ms.
  - 99.9% requests in less than 100 ms.
- Build SLI templates for each common metric.

- Service Level Objectives (SLO): What are metric values.
  - lower bound ≤ SLI ≤ upper bound.
  - What your users care about.
  - Working from desired objectives backward to specific indicators works better than choosing indicators and then coming up with targets.
  - Don't pick a target based on current performance.
  - Choose just enough SLOs to provide good coverage of your system's attributes.
  - Without SLO, you wouldn't know wether (or when) to take action.
  - SLO set expectations. Keep a safety margin.

- Service Level Agreements (SLA): How react if can't provide expected service.
  - SLAs are closely tied to business and product decisions.


