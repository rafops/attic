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

## 5. Eliminating Toil

- Overhead: Meetings, setting and grading goals, snippets (journal), and HR paperwork.
- Grungy (dirty) work: Can sometimes have long-term value.
- Toil: Work tied to running a production service that tends to be manual, repetitive. Toil becomes toxic when experienced in large quantities. Consequences: Career stagnation, burnout, boredom, and discontent.
- Engineering work: Is novel and intrinsically requires human judgment. It produces a permanent improvement in your service, and is guided by a strategy. It is frequently creative and innovative, taking a design-driven approach to solving a problem—the more generalized, the better.
- Software Engineering: Writing automation scripts, creating tools or frameworks, adding service features for scalability and reliability, or modifying infrastructure code to make it more robust.
- Systems Engineering: Monitoring setup and updates, load balancing configuration, server configuration, tuning of OS parameters.

## 6. Monitoring Distributed Systems

- What issues should interrupt a human via a page?
- Monitoring: Collecting, processing, aggregating, and displaying real-time quantitative data.
- Collect symptoms, not causes.
- Basic collection and aggregation of metrics, paired with alerting and dashboards.
- White box/Black box monitoring.
- When collecting telemetry for debugging, white-box monitoring is essential.
- Dashboard: Provides a summary of a service's core metrics.
- Alerts: Tickets, email alerts, and pages.
- Why monitor?
  - Analyzing long-term trends.
  - Conducting ad hoc retrospective analysis (debugging).
- Paging a human is a quite expensive use of an employee’s time.
- Effective alerting systems have good signal and very low noise.
- It’s important that monitoring systems be kept simple and comprehensible by everyone on the team.
- The Four Golden Signals: 
  - **Latency**: The time it takes to service a request. It’s important to distinguish between the latency of successful requests and the latency of failed requests.
  - **Traffic**: HTTP requests per second, network I/O rate, transactions per second.
  - **Errors**: Explicitly (500s), implicitly (200s with wrong content), or by policy (>1s response times).
  - **Saturation**: Memory, IO, CPU. Saturation is also concerned with predictions of impending saturation.
- The simplest way to differentiate between a slow average and a very slow "tail" of requests is to collect request counts bucketed by latencies:
  - How many requests took between 0 ms and 10 ms
  - between 10 ms and 100ms
  - between 100ms and 1s…
  - Distributing the histogram boundaries exponentially.
  - See NewRelic.
- Choosing appropriate resolution (**aggregation**):
  - Observing CPU load over the time span of a minute won’t reveal high tail latencies.
  - For a web service targeting 99.9% annual uptime, probing for a 200 twice a minute is unnecessarily frequent.
  - Checking hard drive fullness once every 1–2 minutes is probably unnecessary.
- The sources of potential complexity are never-ending. Like all software systems, monitoring can become so complex that it’s fragile, complicated to change, and a maintenance burden.
- The rules that catch real incidents most often should be as simple, predictable, and reliable as possible.
- When creating rules for monitoring and alerting, asking the following questions can help you avoid false positives and pager burnout:
  - Does this rule detect an otherwise undetected condition that is urgent, actionable, and actively or imminently user-visible?
  - Will I ever be able to ignore this alert, knowing it’s benign? When and why will I be able to ignore this alert, and how can I avoid this scenario?
  - Does this alert definitely indicate that users are being negatively affected? Are there detectable cases in which users aren’t being negatively impacted, such as drained traffic or test deployments, that should be filtered out?
  - Can I take action in response to this alert? Is that action urgent, or could it wait until morning? Could the action be safely automated? Will that action be a long-term fix, or just a short-term workaround?
  - Are other people getting paged for this issue, therefore rendering at least one of the pages unnecessary?
- These questions reflect a fundamental philosophy on pages and pagers:
  - Every time the pager goes off, I should be able to react with a sense of urgency.
  - Every page should be actionable.
  - Pages should be about a novel problem or an event that hasn’t been seen before.
- Monitoring for the Long Term
  - It’s important that decisions about monitoring be made with long-term goals in mind.
  - Every page that happens today distracts a human from improving the system for tomorrow.
  - Someone should find and eliminate the root causes of the problem.
  - If such resolution isn’t possible, the alert response deserves to be fully automated.
 - Pages with algorithmic responses should be a red flag. Automating such pages covers the technical debt.
 
## 7. The Evolution of Automation at Google

- Common manual tasks: Creating user accounts, making sure backups happen, managing server failover, DNS updates, etc.
- Very few of us will be consistent as a machine, leading to mistakes and reliability problems.
- Automation provides a platform.
- A platform also centralizes mistakes, a bug fix will be done once.
- Google has a large amount of automation; in many cases, the services could no longer survive without this automation because they crossed the threshold of manageable manual operations a long ago.
- Decoupling operator from operation is very powerful.
- Google automation is often to manage lifecycle of systems, not their data.