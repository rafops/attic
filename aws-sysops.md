# AWS Sysops

## CloudWatch

- Minumum metric interval is 1 minute
- System status check (Host)
  - Stop/Start instance may solve issue
- Instance status check (VM)
- Create a Role "CloudWatch", select EC2 and add permission CloudWatch full access. EC2 Instance will be able to read and write into CloudWatch
- Attach role "CloudWatch" to EC2 instance
- Install a few Perl packages and download/install CloudWatch monitoring scripts
- CloudWatch, create a new Dashboard
- Run CloudWatch monitoring scripts from crontab

## Volume Types

- General Purpose SSD (gp2): Low-latency interactive apps, system boot volumes, most workloads. 
- Provisioned IOPS SSD (io1): 20K IOPS/320 MiB/s throughput. Databases.
- Throughput Optimized HDD (st1): high throughput. Streaming. Log processing. low price.
- Cold HDD (sc1): large volume of data, infrequent access. lowest cost.
- Performance: 3 IOPS per GiB of volume size. Max size 16TB. 3000 IOPS burstable using 5400000 I/O credits. burstable for 30 minutes.
- Storage block volumes restored from snapshots requires [initialization](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-initialize.html):

      sudo dd if=/dev/xvdf of=/dev/null bs=1M

- Operations that are smaller than 256K count as 1 consumed IOPS. I/O operations larger than 256K are counted in 256K capacity units.
- Volume status checks: ok, warning, impaired, insufficient data

## Monitoring RDS

- ReplicaLag may be an indicator of exceding IOPS capacity.

## ELB Metrics

- Every 60 seconds (with traffic).

## Elasticache

- SwapUsage should be around 0 most of the time. If exceeds 50Mb you should increase the memcached_connections_overhead parameter (amount of memory for connections).
- Redis instead use reserved-memory.
- Evictions metrics tells you about memory consumption.
- Concurrent connections spikes might be due to application not releasing connections properly.

## Centralized Monitoring

- Enterprise monitoring solutions: Zennos, ?Nimsoft, Splunk, …
- Most basic monitoring uses ICMP. Configure security groups to allow ICMP to specific range of IPs within your VPC (monitoring servers).

## AWS Organizations/Consolidate Billing

- Apply policies per organization unit.
- Paying Account -> Test/Production accounts -> Monthly bill
- Consolidate billing has de advantage of cost reduction (S3, reserved instances, etc.)
- CloudTrail can be consolidated by aggregating logs into a single bucket in the paying or production account.

## Cost Optimization

- TODO: How to use spot instances effectivelly. Maybe for running tests (CI)?
- Mix reserved instances (heavy/medium) and on-demand instances utilization and autoscaling for reducing costs depending on a pattern usage.

## Elasticity/Scalability

- Scale up (vertical): Traditional IT. Increase instance type.
- Network performance used to be based on instance type. EBS Optimized Network Performance (Scale up).
- NAT scaling: Increase NAT size (Scale up) or add multiple NAT and make route on multiple NAT (Scale out).

## RDS Multi-AZ failover

- You can force a failover by rebooting your instance.
- RDS Multi-AZ failover is not a SCALING SOLUTION.
- Read replicas are used to scale.
- Creating read replicas if Multi-AZ is enabled will take snapshot from secondary database.
- Key metric is replica LAG.
- Read replica creation requires backups enabled.

## Bastion

- Use two public subnets with Route 53 failover for high availability of bastion hosts.

## Elastic Load Balancer

- External/Internal (within the VPC).
- Use metrics such as SurgeQueueLength & SpilloverCount to scale.
