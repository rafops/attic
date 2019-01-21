# AWS Certified SysOps Administrator - Associate (SOA-C01)

- https://aws.amazon.com/certification/certified-sysops-admin-associate/

## Study Material

- [Exam Guide](https://d1.awsstatic.com/training-and-certification/docs-sysops-associate/AWS%20Certified%20SysOps%20-%20Associate_Exam%20Guide_Sep18.pdf)
- [AWS Certified SysOps Administrator - Associate 2019](https://www.udemy.com/aws-certified-sysops-administrator-associate)
- [Become AWS Certified - SysOps Administrator Practice Test](https://www.udemy.com/sysopstest)
- [AWS Well-Architected Framework (June 2018)](https://d1.awsstatic.com/whitepapers/architecture/AWS_Well-Architected_Framework.pdf)

## Exam

- No pre-requisites.
- Multiple-choice and multiple-answer questions.
- Multiple-choice has one correct response and three incorrect responses (distractors).
- Multiple-answer has two or more correct responses out of five or more options.
- 130 minutes to complete the exam.
- 65 questions.
- Practice exam registration fee is USD 20.
- Exam registration fee is USD 150.
- Your results for the examination are reported as a score from 100-1000, with a minimum passing score of 720.
- Qualification is valid for 2 years.

### Content Outline

- Domain 1: Monitoring and Reporting
  - 1.1 Create and maintain metrics and alarms utilizing AWS monitoring services
  - 1.2 Recognize and differentiate performance and availability metrics
  - 1.3 Perform the steps necessary to remediate based on performance and availability metrics
- Domain 2: High Availability
  - 2.1 Implement scalability and elasticity based on use case
  - 2.2 Recognize and differentiate highly available and resilient environments on AWS
- Domain 3: Deployment and Provisioning
  - 3.1 Identify and execute steps required to provision cloud resources
  - 3.2 Identify and remediate deployment issues
- Domain 4: Storage and Data Management
  - 4.1 Create and manage data retention
  - 4.2 Identify and implement data protection, encryption, and capacity planning needs
- Domain 5: Security and Compliance
  - 5.1 Implement and manage security policies on AWS
  - 5.2 Implement access controls when using AWS
  - 5.3 Differentiate between the roles and responsibility within the shared responsibility model
- Domain 6: Networking
  - 6.1 Apply AWS networking features
  - 6.2 Implement connectivity services of AWS
  - 6.3 Gather and interpret relevant information for network troubleshooting
- Domain 7: Automation and Optimization
  - 7.1 Use AWS services and features to manage and assess resource utilization
  - 7.2 Employ cost-optimization strategies for efficient resource utilization
  - 7.3 Automate manual or repeatable process to minimize management overhead

## Domain 1: Monitoring and Reporting

- 1.1 Create and maintain metrics and alarms utilizing AWS monitoring services
- 1.2 Recognize and differentiate performance and availability metrics
- 1.3 Perform the steps necessary to remediate based on performance and availability metrics

### CloudWatch

- Monitor performance.
- Host level metrics are CPU, Network, Disk, Status check. Memory is a custom metric.
- Minimum metric interval is 1 minute (detailed monitoring), default is 5 minutes (standard monitoring).
- Metrics are stored indefinitely, but retention can be configured for each Log Group.
- Alarms can be created from any CloudWatch Metrics.
- CloudWatch can be used on premisses servers by installing an SSM agent to ship logs to CloudWatch Logs.
- Monitoring EC2:
  - Create an IAM role "CloudWatch", select EC2 and add permission policy CloudWatchFullAccess. EC2 Instance will be able to read and write into CloudWatch.
  - Attach IAM role "CloudWatch" to EC2 instance.
  - Install a few Perl packages and download/install CloudWatch monitoring scripts.
  - CloudWatch, create a new Dashboard.
  - Run CloudWatch monitoring scripts from crontab.
- Monitoring RDS:
  - RDS ReplicaLag may be an indicator of exceeding IOPS capacity.
- Monitoring ELB:
  - ELB metrics can be obtained every 60 seconds (with traffic).
  - ELB can be monitored using CloudWatch metrics, access logs, request tracing, or CloudTrail logs.
- Monitoring Elasticache:
  - SwapUsage should be around 0 most of the time. If exceeds 50Mb you should increase the memcached_connections_overhead parameter (amount of memory for connections).
  - Redis instead use reserved-memory.
  - Evictions metrics tells you about memory consumption.
  - Concurrent connections spikes might be due to application not releasing connections properly.
- System status check monitors the host health.
  - Stop/Start instance may solve issue. Does it moves the VM to a new host?
- Instance status check monitors the VM health.

### CloudTrail

- CloudTrail monitors API calls in the AWS platform.
- CloudTrail can be consolidated by aggregating logs into a single bucket in the paying or production account.

### AWS Config

- Record the state of your AWS environment.
- Enables compliance auditing, security analysis, and resource tracking.
- Logs configuration changes.
- Automated compliance checking.
- AWS Config requires:
  - An IAM Role with read-only permissions to the recorded solutions.
  - Write access to S3 logging bucket.
  - Publish access to SNS.
- Compliance checks are triggered periodically or by configuration changes.
- You can use managed rules or custom rules.

### AWS Organizations

- Centrally manage policies across multiple AWS accounts.
- Control access to AWS services:
  - Service Control Policies (SCPs) centrally control AWS service across multiple AWS accounts, allowing or denying individual services.
  - You need to enable SCP into a group.
  - Policies attached to a group (organization unit) are applied automatically to sub-accounts.
  - Create an organization unit and attach policy to it. The policy can include services and actions.
- Automate AWS account creation and management.
- Consolidate billing across multiple AWS accounts:
  - Paying Account -> Test/Production accounts -> Monthly bill.
  - Consolidate billing has de advantage of cost reduction (S3, reserved instances, etc.).

### AWS Resource Groups & Tagging

- Key value pairs attached to AWS resources.
- Resource groups group your resources using the tags that are assigned to them.
- There are two types: Classic Resource Groups (global) or the new AWS Systems Manager (per region).
- AWS Systems Manager let you run automation on a group of resources.

### Pricing Model

- On Demand you pay a fixed rate by hour.
- Reserved (up to 75% discount), one or three year terms.
- Spot instances when you have flexible start and end times.
- Dedicated host (useful for regulatory requirements, licensing, etc.).
- Cost optimization:
  - TODO: How to use spot instances effectively. Maybe for running tests (CI)?
  - Mix reserved instances (heavy/medium) and on-demand instances utilization and autoscaling for reducing costs depending on a pattern usage.

### Health Dashboard

- Service Health Dashboards monitors AWS services health.
- Personal Health Dashboards provides alerts and remediation when your resources are affected.

### Billing Alarms

- You can create billing alarms to automatically alert you when you go above a pre-defined cost that you set.

## High Availability

### Elasticity/Scalability

- Scalability: Increase instance sizes as required (long term).
- Elasticity: Increase number of EC2 instances based on autoscaling (short term).
- Scale up (vertical): Traditional IT. Increase instance type.
- Network performance used to be based on instance type. EBS Optimized Network Performance (Scale up).
- NAT scaling: Increase NAT size (Scale up) or add multiple NAT and make route on multiple NAT (Scale out).
- RDS has good scalability (increase instance size) but not much elasticity (can't scaled on demand).
- Aurora has good scalability and elasticity (Aurora serverless).

### RDS Multi-AZ failover

- You can force a failover by rebooting your instance.
- RDS Multi-AZ failover is not a SCALING SOLUTION. Is done by updating DNS endpoint to failover replica.
- Multi-AZ replication is synchronous and read replicas are asynchronous.
- Read replicas are used to scale. Maximum of 5 nodes.
- Creating read replicas if Multi-AZ is enabled will take snapshot from secondary database.
- Key metric is replica LAG.
- Read replica creation requires backups enabled.
- Aurora replicas share the same storage (cluster volume) instead of copying data to replica nodes.

### Elasticache

- In memory cache.
- Memcache or Redis.

### Aurora

- High performance (5x MySQL, 3x PostgreSQL).
- 10 GiB increments up to 64 TB.
- Cluster volume has two copies of your data in each of a minimum of 3 AZs. Storage is self-healing.
- 100% CPU scales up (increase instance size).
- More read capacity scale out (increase replicas).

### Bastion

- Use two public subnets with Route 53 failover for high availability of bastion hosts.

### Elastic Load Balancer

- External/Internal (within the VPC).
- Use metrics such as SurgeQueueLength & SpilloverCount to scale.

### Disaster Recovery

- AWS Storage Gateway. On site appliance that replicates to S3 using VPN or Direct Connect.
- Gateway-stored volumes: Store entire dataset on site and asynchronously replicate data back to S3.
- Gateway-virtual tape library.
- Recovery Time Objective (RTO): Length of time from which you can recover from a disaster.
- Recovery Point Objective (RPO): Amount of data your organisation is prepared to lose.
- Lower RTO/RPO = Higher cost.
- Ensure appropriate retention policy.
- Ensure security measures including encryption and access policies.
- Pilot Light: A DR scenario in which a mnimal version of an environment is always running.
- Pre-allocated EIPs or ENIs (when Mac Addresses for application licensing is required).
- Warm Standby: Scaled down (horizontal scaling) standby copy of environment across region that can be scaled up quickly.
- Use Route53 automated health checks.

## Deployment and Provisioning

### Deploying EC2

- InstanceLimitExceeded error happens when you have reached the maximum allowed for the region (20 by default).
- InsufficientInstanceCapacity error happens when AWS does not currently have
  enough available on demand instances. Purchasing reserved instances in advance can solve this issue.

### EBS Volume Types

- General Purpose SSD (gp2): Low-latency interactive apps, system boot volumes, most workloads.
  - 3 IOPS per GiB of volume size, maximum of 10000 IOPS. Max size 16TB.
  - The base IOPS is always 100 when disk is < 33.33GB.
- Provisioned IOPS SSD (io1): 50 IOPS/GiB, maximum of 32000 IOPS. Use case: Databases.
- Throughput Optimized HDD (st1): high throughput. Streaming. Log processing. Low price.
- Cold HDD (sc1): large volume of data, infrequent access. lowest cost.
- Magnetic.
- To extend an EBS volume you need to perform a snapshot and restore into a larger volume.
- A volume can only be attached to the same AZ it was created.
- Performance:
  - 3000 IOPS burstable using 5400000 I/O credits. burstable for 30 minutes.
  - Anything over 10000 IOPS use PIOPS.
  - When you hit the IOPS limit you will see I/O requests queueing.
  - Storage block volumes restored from snapshots requires [initialization](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-initialize.html):

      sudo dd if=/dev/xvdf of=/dev/null bs=1M

  - Operations that are smaller than 256K count as 1 consumed IOPS. I/O operations larger than 256K are counted in 256K capacity units.
- Volume status checks: ok, warning, impaired, insufficient data.

### Bastion Host

- A bastion is on a public subnet and is an internet facing host.
- Used to securely connect to instances on a private subnet (SSH/RDP).

### Elastic Load Balancers (ELB)

- Application load balancer. Layer 7 (HTTP).
- Network load balancer. Layer 4, load balancing TCP traffic, low lattency. Creates an static IP per subnet that helps to maintain simple firewall rules.
- Classic load balancer. Legacy. Layer 4 and basic layer 7 features.
- Pre-warm load balances for sudden spike of traffic. Request AWS by specifying dates, RPM and size of request.
- Error codes indicating error on the application server:
  - 400 Bad request (eg.: malformed headers)
  - 401 Unauthorized. User access denied.
  - 403 Forbidden. Request blocked by WAF or ACL.
  - 460 Client closed connection. Application server timeout may be too short.
  - 463 X-Forwarded-For with more than 30 IP addresses.
- Error codes indicating problem on the load balancer:
  - 500 Error with load balancer configuration.
  - 502 Bad gateway application server connection/response problem.
  - 503 Service Unavailable. No targets.
  - 504 Gateway Timeout. App server not responding.
  - 561 Unauthorized. Identity provider error on the load balancer.
- Publish metrics to CloudWatch by default gathered at 60 seconds interval that includes:
  - Backend connection errors count.
  - Healthy/Unhealthy host count.
  - HTTP status errors count.
  - Latency (response time).
  - Request count.
  - SurgeQueueLenght: Maximum is 1024 on classic load balancer.
  - SpilloverCount: Count rejected requests.

### AWS Systems Manager

- Organize inventory (including on premisses) grouping resources together.
- Integrates with CloudWatch dashboards.
- Run Command automate tasks such as patching.
- Built-in insight includes Trust Advisor for cost optimization, performance, security, etc; Also suggesting recommended actions.

## Storage and Data Management

### S3

- S3 is object-based key-value storage with versioning and metadata capabilities.
- S3 buckets have universal namespace, can contain policies, access control lists, CORS configurations, transfer accelerations, lifecycle management, and encryption.
- File size can range from 0 bytes to 5TB, but there is virtually unlimited storage and built for 99.99% availability (99.9% guarantee), and 99.999999999% durability.
- HTTP 200 if upload is successful.
- Data consistency is immediate read after write of a new object, but eventual consistent for updates (PUT) and deletes.
- IA (Infrequent Access) has lower fees than S3 but you're charged a retrieval fee.
- One-zone IA has 99.5% availability and costs 20% less than regular IA.
- Reduced Redundancy Storage 99.99% durability/availability used for data that can be recreated if lost (deprecated?).
- Glacier is optimized for archival only (restore may take 3-5 hours).
- Charged by GB stored, requests and data transfer.

- Lifecycle:
	- When defining an S3 lifecycle policy, configure object transition to IA after 90 days and to Glacier after 1 year or expire (auto delete).
	- With version enabled a DELETE action doesn't delete the object version, but applies a delete mark instead.
	- MFA delete will require a code to permanently delete an object version or change versioning configuration.

- Encryption:
	- Encryption in transit using SSL/TLS.
	- S3 managed keys (SSE-S3).
	- AWS KMS.
	- Customer provided keys (SSE-C).
	- Client side encryption.
	- A bucket policy can enforce the use of server-side encryption by denying upload requests that doesn't include x-amz-server-side-encryption header.

### EBS

- Root device (where OS is installed) can be either EBS volume or instance store (ephemeral) volume.
- Instance store root device max size is 10GB.
- EBS root can be up to 2TB.
- Root device is terminated with the instance. Other EBS volumes attached are preserved.
- EBS backed instances can be stopped, but the ones with Instance Store can only be rebooted or terminated.
- Snapshots are stored on S3, are point in time copies of volumes and are incremental since your last snapshot. First snapshot may take some time to create.
- Snapshot from EBS root devices require stopping the instance.
- AMIs can be created from both images and snapshots.
- EBS volume size/storage type can be changed on the fly.
- Volume is always on the same AZ of EC2. To move copy a snapshot or image to another AZ or region.
- Snapshots of encrypted volumes are encrypted automatically. You can share snapshots only if they're not encrypted.

### Encryption

- Mostly encryption can only be enabled at creation or when restoring from unencrypted snapshot (EFS, RDS, EBS volumes, etc.). S3 encryption can be enabled at any time of individual S3 objects.
- KMS is a shared hardware multi tenant managed service.
- Cloud HSM provide a dedicated HSM (hardware security module) instance. HSM is under your control and available only to your VPC. FIPS 140-2 Level 3 compliance. Suitable for contractural/regulatory requirements (financial services, etc.). Enables use of assymetrics keys.

### AMIs

- It's a template to launch EC2 instances containing the root volume, launch permissions, and EBS volume mapping.
- You need to register a custom AMI before use.
- AMIs are registered on a per-region basis.
- AMIs can be copied between different accounts. 
- Encrypted AMIs requires copying the snapshot, re-encrypting with a new key and creating a new AMI from snapshot.
- For proprietary AMIs with license (billingProducts), launch an EC2 and create an AMI from the instance.

### Snowball

- Snowball allows transporting data to AWS in the order of 100s of TB or PB (data transfer only).
- Snowball edge allows creating a S3 compatible endpoint within your network with NFS, etc.

### Storage Gateway

- VMWare ESXi or Microsoft Hyper-V on your on premisses data center.
- File gateway accessed locally via NFS/SMB and stored as objects in your S3 buckets.
- Volume gateway iSCSI. Cloud backed storage. Types:
  - Gateway stored volumes: Store data locally (SAN, NAS, DAS), async backup to AWS in the form of EBS snapshots.
  - Gateway cached volumes: Use S3 as primary storage and cache data frequently accessed in your storage gateway.
- Tape gateway: virtual tape (VTL) that archives to Glacier. Integrates with existing tape backup infrastructure.

### Athena

- Serverless.
- SQL data stored in S3. No need of complex ETL process.

### Data Management

- EBS uses incremental snapshots.
- Root volume (instance/ephemeral storage): OS. Delete on termination (default).
- Additional volumes (EBS volumes attached to the instance): Data.
- EC2 can be EBS backed. Volume is deleted when instance is terminated (set during creation time).
- Show volumes and mount points: `lsblk`.
- Check if volume has data: `file -s /dev/xvdx`.
- EBS volumes can be changed on the fly (except Magnetic).
- Wait 6 hours before making another change on the fly.
- Scale EBS volumes up only.
- Volumes should be on same AZ. Take snapshots to move data to another AZ or region.

## Security and Compliance

### DDoS protection

- AWS Shield is a free service that protect AWS customers on ELB, CloudFront and Route53.
- AWS Shield Advanced (enhanced protection for more sophisticated attacks) costs $3k/mo.

### IAM

- Attached roles to EC2 takes effect immediately.
- Police changes take effect immediately.

### Logging

- CloudTrail: Records API calls.
- Config: Record configuration changes.
- CloudWatch Logs: Monitors performance.
- VPC Flow logs: Records VPC network logs.

### Hypervisor

- EC2 currently runs on Xen Hypervisors.
- Guest operating systems can run either as a paravirtualization (PV) or hardware virtual machine (HVM).
- AWS recommends using HVM over PV. Linux can be both PV and HVM.
- PV is isolated by layers, guest OS is L1, applications on L3.
- AWS admins have access to the hypervisor but not the guest hosts.
- Security groups runs on firewall on the hypervisor layer: Physical hardware > Firewall > SGs > Virtual Interface > Hypervisor > Customer.
- EBS volumes and allocated memory are scrubbed before returning to the pool.

### Dedicated Instances

- Dedicated instances runs on hardware dedicated to a single customer, but may share hardware with other instances from the same AWS account.
- Dedicated hosts gives you additional control where instances are placed on a physical server (for licensing/compliance purposes).

### Shared responsibility Model

- AWS: Global infrastructure, hardware, software, networking, and managed services (eg: RDS).
- Customer: Updates, security patches, security groups, network ACLs.

## Networking

### Routing Policy

- Simple: Return IP addresses in a random order.
- Weighted: Send certain amount of traffic to different destinations.
- Latency: Send traffic to the lowest latency endpoint.
- Failover: Define an active/passive sites, when active health check fails, it failover to passive.
- Geolocation: Traffic on user geolocation.
- Multivalue: When health check fails in one of the values, the traffic goes to the other records.

## VPC

- Security groups are stateful (opening inbound traffic to a port allows responding with outbout traffic). SGs are assigned to instances (network interfaces).
- Network access control are stateless (inbound/outbound need to explicitly opened). NACLs are assigned to subnets.
- NAT instances (launched with AMI prefix amzn-ami-vpc-nat). Disable source/destination check (disable the check that verifies the instance is be the source or destination of any traffic it sends or receives).
- Prefer using NAT gateway instead of NAT instances for HA.
- AWS S3 Gateway is HA.
- ALB require at least two public subnets for HA.
- VPC Flow Logs track IP traffic in/out from your ENIs in on your VPC/Subnet/ENI resources. DNS, instance metadata host, DHCP are not monitored.
- VPC flow logs for a peered VPC is only possible if in the same account.
- NAT gateways are HA.

## Automation and Optimization

### CloudFormation

- Template (JSON/YAML) => API calls.
- Upload to CloudFormation using S3.
- Resulting resources are called stack.
- Resources is the only require section of template.
- Transform section allows loading external dependencies such as Lambda scripts or other CloudFormation scripts.
- Mappings maps AMIs/regions.

### Elastic Beanstalk

- A service to deploy/scale apps in popular languages.
- You can choose having administration control of the resources or choosing Elastic Beanstalk controlling them for you.
- Automatically manage platform updates.
- Monitor/manage app health.
- Integrate with CloudWatch/X-Ray.

### OpsWorks

- Automate server configuration with Chef/Puppet.

## Review

### Section 1

- During the AMI creation snapshots are created from EBS volumes, and the AMI will include block device mappings for any instance store volumes. You can create AMIs either from instance store or EBS backed instances.
- Pre warming is not necessary for EBS volumes anymore (they're stored in S3). To retrieve the volume data from S3 immediately, **initialize** the volume.
- You can't convert an instance stored Windows AMI into a EBS AMI, but it is possible with Linux AMIs.
- root EBS volumes are deleted on termination.
- You cannot encrypt/decrypt an existing volume. EBS encryption encrypts data at rest and transit between EBS and instance. You cannot encrypt an EBS volume by taking a snapshot.
- If you set InstanceInitiatedShutdownBehaviour, the instance will be either stopped/terminated when there's a instance initiated shutdown.
- When you **get system log** on an EC2 instance, a Windows instance will show the last three system event log errors and a Linux will display the output from a physical monitor attached to it.
- `dd` and `fio` can be used to initialize an EBS volume created from a snapshot.

### Section 2

- Provisioned IOPS SSD (io1): 50 IOPS/GiB
- 50 IOPS/GiB, maximum of 32000 IOPS. Disk must be >= 640 GiB for maximum performance.
- A provisioned IOPs EBS volume can be up to 16 TB in size.
- The maximum size of a file you can upload to S3 using the console is 78 GB.
- When you create a VPC with public/private subnets, the main route table is used for the private subnet.
- If you need to restrict resource access to users, use IAM variables and create a resource for each user.
- Use ACL to block traffic from an IP range in a VPC.
- Use scheduled actions on ASG to build capacity proactively and give instances time to warm up before they're needed.
- If you receive an error InsufficientInstanceCapacity wait a few minutes or try creating an instance without specifying an AZ.
- monitoring.us-east-1.amazonaws.com is a valid CloudWatch endpoint URL.
- When restoring from Glacier, you're billed for both temporary and archive copies, you can copy the temporary restored copy to S3 for long term acces, and you need to specify the duration for the temporary copy of restored data.
- When sending data to CloudWatch using the API, UTC is recommended but not required, and the timestamp can be up to two weeks in the past and two hours in the future.

### Section 3

- Using CloudWatch to monitor metrics from EMR, metrics are updated every 5 minutes, and this interval cannot be changed. Also, there is no charge to report EMR metrics to CloudWatch.
- To get Route53 metrics from CloudWatch, use us-east-1 region. CloudWatch provides detailed metric of Route53 by default.
- DynamoDB, Redshift and RDS comes with snapshot backup solution builtin.
- When you create a launch configuration using the Console, basic monitoring is enabled. But when using the CLI or API, detailed monitoring is enabled by default.
- An S3 bucket ACL can grantee access to one of the following predefined groups: All Users, Log Delivery, or Authenticated Users.
- For an EBS backed instance, you can choose stop or terminate.
- For an instance store backed instance, the shutdown behaviour must be terminate.
- MS SQL requires synchronous logical replication to support Multi-AZ.
- When creating a subnet with address range too large, delete and create smaller subnets.
- If you create a subnet that occupies the full CIDR of the VPC, an error will occur if you try to create a new subnet.
- In CloudFormation, to wait until an instance is created, add the DependsOn attribute to the next resource, and create a Wait Condition on the EC2.
- The maximum size of PutMetricData HTTP POST request to CloudWatch is 40 KB.
- To create an RDS event notification subscription, create it in the RDS console then chosse Yes to enable it.


### Section 4

- If an instance store backed EC2 is impaired, you'll need to terminate the instance and create a replacement.
- Instances are registered to a classic load balancer by IP address.
- Elastic load balancers supports TLS 1.2, 1.1, 1.0 and SSL v3
- If an instance that is EBS backed is impaired, stop and start instance to fix.
- When sharing AMI cross account, once AMI is copied, original account has no access to copied version.
- The maximum draining timeout for an ELB is 60 minutes.
- If ASG fails to launch instances after 24hrs is suspended.
- If you delete a VPC, a VPN VPG will be detached and can be attached to a different VPC.
- In SQS, messages are retained for 4 days by default, up to a maximum of 14 days.