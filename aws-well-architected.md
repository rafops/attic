# AWS Well-Architected Framework

## Whitepapers

- [AWS Well-Architected Framework (June 2018)](https://d1.awsstatic.com/whitepapers/architecture/AWS_Well-Architected_Framework.pdf)
- [AWS Well-Architected Framework - Cost Optimization Pillar (July 2018)](https://d1.awsstatic.com/whitepapers/architecture/AWS-Cost-Optimization-Pillar.pdf)
- [AWS Well-Architected Framework - Operational Excellence Pillar (July 2018)](https://d1.awsstatic.com/whitepapers/architecture/AWS-Operational-Excellence-Pillar.pdf)
- [AWS Well-Architected Framework - Performance Efficiency Pillar (July 2018)](https://d1.awsstatic.com/whitepapers/architecture/AWS-Performance-Efficiency-Pillar.pdf)
- [AWS Well-Architected Framework - Reliability Pillar (September 2018)](https://d1.awsstatic.com/whitepapers/architecture/AWS-Reliability-Pillar.pdf)
- [AWS Well-Architected Framework - Security Pillar (July 2018)](https://d1.awsstatic.com/whitepapers/architecture/AWS-Security-Pillar.pdf)
- [AWS Well-Architected Framework - HPC Lens (November 2017)](https://d1.awsstatic.com/whitepapers/architecture/AWS-HPC-Lens.pdf)
- [AWS Well-Architected Framework - Serverless Applications Lens (November 2017)](https://d1.awsstatic.com/whitepapers/architecture/AWS-Serverless-Applications-Lens.pdf)

## AWS Well-Architected Framework

### Design Principles
- **Stop guessing your capacity needs**. Scale up/down automatically.
- Create test systems on demand, and decommission the resources when the test is done.
- **Automate to make architectural experimentation easier** (CloudFormation, Terraform, etc.).
- **Allow for evolutionary architectures**. This allows systems to evolve over time so that businesses can take advantage of innovations as a standard practice.
- **Drive architectures using data**. Eg.: Use a cloud monitoring solution and monitoring metrics to inform your architecture choices and improvements over time.
- **Improve through game days**: Test how your architecture and processes perform by regularly scheduling game days to simulate events in production. (Hack days, fire drills, etc.)

### Pillar 1: Operational Excellence
#### Design Principles:
- **Perform operations as code**. Define application and infrastructure as code and automate operations procedures.
- **Annotate documentation**(?).
- **Make frequent, small, reversible changes**. Make changes in small increments.
- **Refine operations procedures frequently.** (eg.: disaster recovery procedure).
- **Anticipate failure**. Perform "pre-mortem" exercises. (eg.: fire drills).
- **Learn from all operational failures**. Drive improvements through lessons learned (eg.: post-mortems).
#### Best Practices:
- **Prepare**. Create mechanisms to validate that workloads or changes are ready to be moved into production. Invest in scripting operations activities to maximize the productivity of operations personnel, minimize error rates, and enable automated responses. Use cloud monitoring tools (eg.: AWS Config) to check if environments are compliant with standards.
- **Operate**. Define expected outcomes, and identify the workload and operations metrics that will be used to define success (eg.: using CloudWatch). Prioritize responses to events based on their business and customer impact. Ensure that if an alert is raised in response to an event, there is an associated process to be executed. Determine the RCA of unplanned events.
- **Evolve**. Dedicate work cycles to making continuous incremental small improvements (eg.: compliance requirements). Capture learnings from the execution of operations. Share lessons learned across teams. Analyze logs to gain actionable insights (eg.: Using an ELK stack).

### Pillar 2: Security
#### Design Principles:
- **Implement a strong identity foundation**. Reduce the reliance on long-term credentials.
- **Enable traceability**. Monitor, alert, and audit actions and changes in real time. Integrate logs and metrics with systems to automatically respond and take action.
- **Apply security at all layers**. Edge network, VPC, subnet, load balancer, instance OSes and application.
- **Automate security best practices**. Create secure architectures, including the implementation of controls defined and managed with infrastructure as code.
- **Protect data in transit and at rest**. Classify data into sensitivity levels. Use encryption and access control.
- **Keep people away from data**. Create mechanisms and tools to reduce or eliminate the need for direct access to data.
- **Prepare for security events**. Having an incident management process. Run incident response simulations and automate detection, investigation and recovery.
#### Best Practices:
- **Identity and Access Management**. Use IAM to control user and programmatic access to AWS services and resources. Apply granular policies, require strong password practices, enforcing MFA. Use federation with existing directory service. Use temporary credentials issued by the AWS Security Token Service (STS).
- **Detective Controls**. In AWS you can implement detective controls by processing logs, events, and monitoring. Use AWS services such as CloudTrail logs, CloudWatch monitoring, AWS config, and GuardDuty. Log management is important for security, forensics and regulatory/legal requirements.
- **Infrastructure Protection**. Enforce boundary protection of your VPC, monitor points of ingress/egress. Implement security hardening with base AMIs. CloudFront which integrates with AWS Shield for DDoS mitigation. WAF protects from common web exploits.
- **Data Protection**. High durability through S3, data encryption with KMS keys, and SSL termination handled by ELBs.
- **Incident Response**. Your organization should put processes in place to respond and mitigate security incidents. An effective incident respond must have detailed logging and automated responses. eg.: CloudWatch events + Lambdas.

### Pillar 3: Reliability
#### Design Principles:
- **Test Recovery Procedures**. Create automation to simulate different failures.
- **Automatically recover from failure**. By monitoring a system for key performance indicators (KPIs), you can trigger automation when a threshold is breached.
- **Scale horizontally to increase aggregate system availability**. Replace one large resource with multiple small resources to reduce the impact of a single failure.
- **Stop guessing capacity**.
- **Manage change in automation**. Changes to infrastructure should be done using automation.
#### Best Practices:
- **Foundations**. With AWS most of the foundational requirements for network and computing capacity.
- **Change Management**. Controls on change management ensure that you can enforce the rules that deliver the reliability you need.
- **Failure Management**. How do you backup your data? How does your system withstand component failures? How do you test resilience? How do  you plan for disaster recovery?

### Pillar 4: Performance Efficiency
#### Design Principles:
- **Democratize advanced technologies**. Push knowledge and complexity into the cloud vendor's domain.
- **Go global in minutes**. Deploy your system in multiple regions.
- **Use serverless architectures**. Remove the need for you to run and maintain servers.
- **Experiment more often**.
- **Mechanical sympath**. Consider data access patterns when selecting database or storage approaches.
#### Best Practices:
- **Selection**. How do you select the best performing architecture?
- **Compute**. The optimal compute solution for a particular system may vary based on application design, usage patterns, and configuration settings. In AWS compute is available in the form of instances, containers, and functions.
- **Storage**. When you select a storage solution, ensure it aligns with your access patterns.
- **Database**. RDS.
- **Network**. AWS offers enhanced networking, EBS-optimized instances, S3 transfer acceleration, Route 53 latency routing, VPC endpoints, Direct Connect, etc. in order to reduce network distance or jitter.
- **Review**.
- **Monitoring**. CloudWatch provides the ability to monitor and send notification alarms. You can use automation through Kinesis, SQS, and Lambda.
- **Tradeoffs**. Depending on your situation, you could trade consistency, durability, and space versus time or latency to deliver higher performance.

### Pillar 5: Cost Optimization
#### Design Principles:
- **Adopt a consumption model**. Pay only for the computing resources that you require.
- **Measure overall efficiency**. Measure the business output of the system and the costs associated with delivering it.
- **Stop spending money on data centre operations**. AWS does the heavy lifting so you can focus on your customers and business projects.
- **Analyze and attribute expenditure**. The cloud makes it easier to accurately identify the usage and cost of systems. This helps measuring ROI.
- **Use managed and application level services to reduce cost of ownership**.
#### Best Practices:
- **Cost-Effective Resources**. Using tools such as Cost Explorer and AWS Trusted Advisor to regularly review your AWS usage and adjust your deployments accordingly.
- **Matching supply and demand**. auto-scaling allows you to add or remove resources to match demand without overspending.
- **Expenditure awareness**. Combining tagged resources with entity lifecycle tracking (employees, projects) makes it possible to identify orphaned resources or projects that are no longer generating value to the business and should be decommissioned.
- **Optimizing over time**. For example running an RDS database can be cheaper than running your own database on EC2.

## Cost Optimization Pillar
## Operational Excellence Pillar
## Performance Efficiency Pillar
## Reliability Pillar
## Security Pillar
## HPC Lens
## Serverless Applications Len
