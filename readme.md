## Assumptions

- All resources are deployed in **eu‑west‑1**.  
- The VPC was provisioned via the **terraform-aws-modules/vpc** module, with:  
  - 2 public subnets  
  - 2 private subnets  
  - a single NAT Gateway  
- The ECS cluster runs on **Fargate** in `awsvpc` mode (no EC2 instances).  
- By default, tasks run in private subnets **without** public IPs; for testing we can set `assign_public_ip = true` and launch them in public subnets.  
- Application containers listen on **port 8080** and are registered in an NLB target group.  
- An HTTP API (`aws_apigatewayv2_api`) uses a **VPC Link** to connect to the NLB via private ENIs in the same subnets as ECS.  
- The API integration is `HTTP_PROXY`, pointing at the NLB’s DNS name on port 8080.  
- The ECS security group allows ingress **only** from the trusted IP range (`75.2.60.0/24` plus your IP) on ports **8080** and **443**; egress is unrestricted.  
- Terraform remote state is stored in an **S3 backend** with versioning, SSE‑S3 encryption, and a public‑access block.  
- Logs are sent to CloudWatch Log Group **`/ecs/myapp`**, with log streams auto‑created by ECS.  
- **RDS** is currently deployed as a single instance to minimize costs.
- Used Api Gateway for SSL without custom domain

## Improvements

- **RDS Multi‑AZ** deployment for high availability  
- Comprehensive **backup strategy** (automated snapshots, retention policy)  
- **ECS autoscaling** (target tracking based on CPU, memory or request count)  
- Automated **cleanup of old Docker images** in ECR  
- **Alerts & monitoring** for ECS (CPU, memory, unhealthy tasks) and RDS (CPU, connections, replica lag)  
- **Cross‑region replication** of Terraform state (S3 bucket and DynamoDB table) for disaster recovery  
- **ElastiCache** (Redis or Memcached) layer in front of RDS for read caching  
- **VPC Flow Logs** enabled for traffic auditing and troubleshooting  
- **AWS WAF** implementation (rate limiting, IP blocking) in front of API Gateway or NLB  
- Purchase **Reserved Instances** or **Savings Plans** to optimize RDS/ECS costs  
- **Canary / blue‑green deployment** strategy for ECS services  
- **AWS X‑Ray** integration for distributed tracing  
- **AWS Config Rules** (e.g., tag compliance, public resource checks)  
- Full **CI/CD pipelines** for both Terraform (plan/apply) and application deployments  
- Consistent **Terraform outputs** to expose ARNs, endpoints, IDs  
- Enhanced **health checks** (application‑level probes, grace periods)  
