# AWS ECS

## Summary

- Create an IAM role with the `AmazonEC2ContainerServiceforEC2Role` policy.
- Create a cluster with `aws ecs create-cluster --cluster-name "YourClusterName"`
- Create container instances with ECS Optimized AMI.
- Configure container instance to join the cluster by using ONE of the following methods:
  - Write `ECS_CLUSTER=YourClusterName` to `/etc/ecs/ecs.config` on the container instances;
  - Using a user data script writing to the ECS_CLUSTER variable;
  - Run docker manually by `docker run --name ecs-agent -env=ECS_CLUSTER=YourClusterName`.
- Alternativelly, create container instances using AutoScaling Groups.
  - Set up the Launch Configuration to use the ECS Optimized AMI;
  - or using a user data script to manually configure the ECS Container Agent.
  - Point the container agent to the Cluster you'd like them to join.
- Create a task definition from the skeleton: `aws ecs register-task-definition --generate-cli-skeleton`
- Define many of the `containerDefinitions` parameters.
- Define a task placement strategy: AZ Balanced Spread, One Per Host, etc.
- Define CloudWatch metrics.
- Create a target group.
- Create an application load balancer making a listener rule pointing to the target group.
- Create a service and register the application load balancer and the target group with the service.
- Create a listener rule when the path is / we send it to the target group.


## Naming Conventions

- Cluster
- Container Agent
- Container Instances
- Task Definition
- Task
- Service

## Naming Definitions

- AWS ECS: Is a CLUSTER management solution.
- You can create AWS ECS clusters within a new or existing VPC.
- A cluster is a logical grouping of EC2 instances called CONTAINER INSTANCES.
- EC2 instances with the CONTAINER AGENT that are a part of an ECS cluster are referred to as container instances.
- The container agent runs on each instance within a cluster and communicates with ECS about tasks.
- After a cluster is up and running you can define TASK DEFINITIONS and SERVICES that specify which Docker container images to run across your clusters.
- Container images are stored and pulled from a container registry in AWS ECR.
- An image is built from a Dockerfile.
- A TASK DEFINITION concept is similar to docker-compose.
- Scaling and deploys are handled by an updated version of our task definition (blue-green deployment, etc.).
- A TASK is the instantiation of a task definition on a container instance within your cluster.
- ECS TASK SCHEDULER is responsible for placing tasks on container instances.
- A SERVICE is composed by a task definition and a service description.
- A service launches and maintains a specified number of copies of the task definition in your cluster.
- A service tells our cluster how to manage tasks.
- A cluster can have multiple services and target groups.

## AWS Services

- ECS can be used with the following services:
  - IAM: IAM roles and IAM task roles
  - Auto Scaling/CloudWatch to scale container instances
  - Load Balancers
    - Classic Load Balancers spread traffic between servers.
    - Application Load Balancers spread traffic between applications. In this case, the applications are our ECS Tasks.
  - ECR

## Terraform ECS Resources

Terraform ECS module: https://github.com/arminc/terraform-ecs

- aws\_ecr\_repository
- aws\_ecr\_repository\_policy
- aws\_ecs\_cluster
- aws\_ecs\_service
- aws\_ecs\_task\_definition

## ECR

Build image:

```
docker build -t hello-world .
```

Create repository:

```
aws ecr create-repository --repository-name hello-world
```

Tag image in ECR:

```
docker tag hello-world aws_account_id.dkr.ecr.us-east-1.amazonaws.com/hello-world
```

Get Docker login to ECR:

```
aws ecr get-login --no-include-email
```

Push image to ECR:

```
docker push aws_account_id.dkr.ecr.us-east-1.amazonaws.com/hello-world
```

## Task Definition

- Which Docker images to use with the containers in your task
- How much CPU and memory to use with each container
- Whether containers are linked together in a task
- The Docker networking mode to use for the containers in your task
- What (if any) ports from the container are mapped to the host container instance
- Whether the task should continue to run if the container finishes or fails
- The command the container should run when it is started
- What (if any) environment variables should be passed to the container when it starts
- Any data volumes that should be used with the containers in the task
- What (if any) IAM role your tasks should use for permissions

## Container Definition

- name
- image
- memory
- memoryReservation
- portMappings
- …

## Cluster

- An Amazon ECS cluster is a logical grouping of container instances that you can place tasks on.
- You need to launch container instances into the cluster before running tasks.
- Clusters are region-specific (VPC?).

Creating a cluster:

```
aws ecs create-cluster --cluster-name "mycluster"
```

Supporting components:

- VPCs
- EBS volumes
- IAM roles
- EC2s (Container Instances)
- …

## Container Instances

- An Amazon ECS container instance is an Amazon EC2 instance that is running the Amazon ECS container agent and has been registered into a cluster.
- If you are using the Amazon ECS-optimized AMI, the agent is already installed.
- Because the Amazon ECS container agent makes calls to Amazon ECS on your behalf, you must launch container instances with an IAM role that authenticates to your account and provides the required resource permissions.
- EC2 instances that hook up with ECS need an IAM role with the `AmazonEC2ContainerServiceforEC2Role` policy.

## CloudWatch Logs

http://docs.aws.amazon.com/AmazonECS/latest/developerguide/using\_cloudwatch\_logs.html

## Using the awslogs Log Driver

You can configure the containers in your tasks to send log information to CloudWatch Logs. This enables you to view different logs from your containers in one convenient location, and it prevents your container logs from taking up disk space on your container instances.

## Services

http://docs.aws.amazon.com/AmazonECS/latest/developerguide/service\_definition\_parameters.html

## Elastic Application Load Balancers (Service Load Balancing)

- An Application Load Balancer makes routing decisions at the application layer (HTTP/HTTPS), supports path-based routing, and can route requests to one or more ports on each container instance in your cluster. Application Load Balancers support dynamic host port mapping. For example, if your task's container definition specifies port 80 for an NGINX container port, and port 0 for the host port, then the host port is dynamically chosen from the ephemeral port range of the container instance (such as 32768 to 61000 on the latest Amazon ECS-optimized AMI). When the task is launched, the NGINX container is registered with the Application Load Balancer as an instance ID and port combination, and traffic is distributed to the instance ID and port corresponding to that container. This dynamic mapping allows you to have multiple tasks from a single service on the same container instance.

## Setup



## References

- https://aws.amazon.com/ecs/
- http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html
- https://start.jcolemorrison.com/the-hitchhikers-guide-to-aws-ecs-and-docker/
- https://start.jcolemorrison.com/guide-to-fault-tolerant-and-load-balanced-aws-docker-deployment-on-ecs/
