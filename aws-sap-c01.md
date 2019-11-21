# AWS Certified Solutions Architect - Professional Exam (SAP-C01)

## Objectives

- Apply the AWS Well-Architected Framework
- Manage multiple AWS accounts for your organization
- Connect on-premises datacenter to AWS cloud
- Discuss billing implications of connecting multi-region VPCs
- Move large data from on-premises datacenter to AWS
- Design large datastores for AWS cloud
- Understand different architectural designs for scaling a large website
- Protect your infrastructure from DDoS attack
- Secure your data on AWS with encryption
- Design protection of data-at-rest as well as data-in-flight
- Enhance the performance of your solutions
- Select the most appropriate AWS deployment mecha3nism

## Articles

- [Preparing for the AWS Certified Solutions Architect – Professional 2019 (SAP-C01) Exam](https://www.linkedin.com/pulse/preparing-aws-certified-solutions-architect-2019-sap-c01-agarwal)
- [AWS Certified Solution Architect – Professional (SAP-C01) Exam Learning Path](http://jayendrapatil.com/aws-certified-solution-architect-professional-exam-learning-path)

## Courses

- [Exam Readiness: AWS Certified Solutions Architect – Professional](https://www.aws.training/Details/eLearning?id=34737) (free) ✔
- [AWS Training and Certification Learning Library](https://www.aws.training/LearningLibrary) (free)
- ~~[Udemy: AWS Certified Solutions Architect Professional](https://www.udemy.com/course/amazon-certified-solutions-architect-professional) (CAD 140)~~
- [Udemy: AWS Certified Solutions Architect - Professional 2019](https://www.udemy.com/course/aws-certified-solutions-architect-professional) (CAD 40)
- [A Cloud Guru: AWS Certified Solutions Architect - Professional 2019](https://acloud.guru/learn/aws-certified-solutions-architect-professional-2019) (USD 29) 💸
- [Linux Academy: AWS Certified Solutions Architect – Professional](https://linuxacademy.com/course/aws-certified-solutions-architect-professional-2018/) (USD 40) 💸

## Practice Tests

- PSI: AWS Certified Solutions Architect - Professional Practice (USD 40)
- [Udemy: AWS Certified Solutions Architect Professional Practice Exam](https://www.udemy.com/course/aws-solutions-architect-professional-practice-exams-2018/) (CAD 45)
- [Udemy: AWS CSAP Practice Tests](https://www.udemy.com/course/aws-certified-solutions-architect-professional-whizlabs/) (CAD 40)
- [BrainCert: AWS Certified Solutions Architect Professional SAP-C01 Practice Exams](https://www.braincert.com/course/10323-AWS-Certified-Solutions-Architect-–-Professional-Practice-Exams) (CAD 25)
- [AWS Certified Solutions Architect – Professional Level Sample Exam Questions](https://d0.awsstatic.com/training-and-certification/docs/AWS_certified_solutions_architect_professional_examsample.pdf)

## Roadmap

### AWS Well-Architected

- [AWS Well-Architected Training](https://www.aws.training/Details/Curriculum?id=12049)
- [Framework](https://d1.awsstatic.com/whitepapers/architecture/AWS_Well-Architected_Framework.pdf)
- [Operational Excellence](https://d1.awsstatic.com/whitepapers/architecture/AWS-Operational-Excellence-Pillar.pdf)
- [Security](https://d1.awsstatic.com/whitepapers/architecture/AWS-Security-Pillar.pdf)
- [Reliability](https://d1.awsstatic.com/whitepapers/architecture/AWS-Reliability-Pillar.pdf)
- [Performance Efficiency](https://d1.awsstatic.com/whitepapers/architecture/AWS-Performance-Efficiency-Pillar.pdf)
- [Cost Optimization](https://d1.awsstatic.com/whitepapers/architecture/AWS-Cost-Optimization-Pillar.pdf)
- [Serverless Application](https://d1.awsstatic.com/whitepapers/architecture/AWS-Serverless-Applications-Lens.pdf)
- [High Performance Computing (HPC)](https://d1.awsstatic.com/whitepapers/architecture/AWS-HPC-Lens.pdf)
- [IoT (Internet of Things)](https://d1.awsstatic.com/whitepapers/architecture/AWS-IoT-Lens.pdf)

### Domain 1: Design for Organizational Complexity (12.5%)

- Design for Organizational Complexity; Udemy 02:22:47

**Cross-account Authentication and Access Strategy**

- AWS Identity Basics; Linux Academy (01:52:00)
- [Active Directory Domain Services on AWS](https://d1.awsstatic.com/whitepapers/adds-on-aws.pdf)

**Networks**

- Networking in AWS: Virtual Private Clouds (VPCs); Linux Academy (05:36:00)
- [Amazon Virtual Private Cloud User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ug.pdf)
- [Amazon Virtual Private Cloud Connectivity Options](https://d1.awsstatic.com/whitepapers/aws-amazon-vpc-connectivity-options.pdf)
- [AWS VPN FAQs](https://aws.amazon.com/vpn/faqs/)
- [AWS Direct Connect FAQs](https://aws.amazon.com/directconnect/faqs/)
- Networking; A Cloud Guru, CHAPTER 3 (01:30:10)

**Multi-account Environments**

- Account Management; Linux Academy (02:37:00)
- [AWS Organizations User Guide](https://docs.aws.amazon.com/organizations/latest/userguide/organizations-userguide.pdf)
- [AWS Organizations FAQs](https://aws.amazon.com/organizations/faqs/)
- [AWS re:Inforce 2019: Managing Multi-Account AWS Environments Using AWS Organizations](https://www.youtube.com/watch?v=fxo67UeeN1A)

### Domain 2: Design for New Solutions (31%)

- Design for New Solutions; Udemy (17:07:46)
- **EC2 Auto Scaling**
- **ELB**: Middle-tier load balancer
- **SQS**: Assynchronous tasks, single direction, unordered, “at least once” delivery
- **SNS**: Fan out to Amazon SQS, assynchronous, batch processing
- **Kinesis**: Assynchronous, single direction, ordered within a shard, “at least once” semantics, independent stream position, _Data Streams_ vs _Firehose_
- **CloudFront**: Reduce traffic costs, increase performance, access to S3 restricted to _Origin Access Identities_ and AWS account trusted signer
- **Route53**
- **EBS**: Volume resize, change on type and throughtput while attached, EC2 maximum EBS throughput, OS-based RAIS sets
- **RDS**: Scaling, replication, _ReplicaLag_
- **ElastiCache**: _Redis_ and _Memcached_
- **DynamoDB**: Caching, _DAX_ (read/write through cache), use of SQS to limit throughput (cost saving), autoscaling, _Global Tables_ (globally distributed, multi-region)
- **CloudWatch**
- **CloudFormation**


**Security**

- Security; Linux Academy (01:31:00)
- Security; A Cloud Guru, CHAPTER 4 (57:56)
- [Amazon Web Services: Overview of Security Processes](https://d1.awsstatic.com/whitepapers/aws-security-whitepaper.pdf)

**Reliability**

- Compute; Linux Academy (05:28:00)
- Databases in AWS; Linux Academy (03:39:00)
- Scaling and Resilience; Linux Academy (08:30:00)
- [AWS Best Practices for DDoS Resiliency](https://d1.awsstatic.com/whitepapers/Security/DDoS_White_Paper.pdf)
- [Amazon EC2 FAQs](https://aws.amazon.com/ec2/faqs/)
- [Elastic Load Balancing FAQs](https://aws.amazon.com/elasticloadbalancing/faqs/)
- [AWS Elastic Beanstalk FAQs](https://aws.amazon.com/elasticbeanstalk/faqs/)
- Architecting to Scale; A Cloud Guru, CHAPTER 6 (01:26:10)

**Business Continuity**

- [Migrating AWS Resources to a New AWS Region](http://d0.awsstatic.com/whitepapers/aws-migrate-resources-to-new-region.pdf)
- Business Continuity; A Cloud Guru, CHAPTER 7 (41:26)

**Performance**

- [Performance at Scale with Amazon ElastiCache](https://d1.awsstatic.com/whitepapers/performance-at-scale-with-amazon-elasticache.pdf)

**Deployment**

- Deployment and Operations; Linux Academy (04:52:00)
- [Web Application Hosting in the AWS Cloud](https://d1.awsstatic.com/whitepapers/aws-web-hosting-best-practices.pdf)
- Deployment and Operations Management; A Cloud Guru, CHAPTER 8 (01:17:58)

### Domain 3: Migration Planning (15%)

- [AWS Cloud Migration](https://aws.amazon.com/cloud-migration/)
- [AWS Training: Introduction to AWS Storage Gateway](https://www.aws.training/Details/Video?id=37440)
- Migration Planning; Udemy (01:28:05)
- Migrations and Hybrid Architectures; Linux Academy (01:27:00)
- [AWS Migration Whitepaper](https://d1.awsstatic.com/whitepapers/Migration/aws-migration-whitepaper.pdf)
- Migrations; A Cloud Guru, CHAPTER 5 (32:45)

### Domain 4: Cost Control (12.5%)

- Cost Control; Udemy (01:20:05)
- Cost and Cost Optimization; Linux Academy (00:15:14)
- Cost Management; A Cloud Guru, CHAPTER 9 (38:35)

### Domain 5: Continuous Improvement for Existing Solutions (29%)

- [AWS Best Practices: Architecting for the Cloud](https://d1.awsstatic.com/whitepapers/AWS_Cloud_Best_Practices.pdf)
- [AWS Training: EC2 Systems Manager](https://www.aws.training/Details/Curriculum?id=13830)
- [AWS Serverless Computing](https://aws.amazon.com/serverless/)
- [Implementing Microservices on AWS](https://d1.awsstatic.com/whitepapers/microservices-on-aws.pdf)
- Continuous Improvement for Existing Solutions; Udemy (09:58:00)
- Analytics, IoT, and Streaming; Linux Academy (02:20:00)
- Application Integration; Linux Academy (02:01:00)
- Storage; Linux Academy (02:44:00)
- Data Stores; A Cloud Guru, CHAPTER 2 (01:38:44)