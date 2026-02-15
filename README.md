# AWS Enterprise Landing Zone — Multi-Account Terraform + DevSecOps CI/CD

## Project Overview
This project demonstrates how to design and deploy a production-style AWS Enterprise Landing Zone using:
- Multi-Account Architecture (AWS Organizations)
- Infrastructure as Code (Terraform)
- Centralized Logging & Audit
- Security Guardrails (SCPs)
- DevSecOps Automation (Jenkins + Checkov)
- Automated Application Deployment

The goal was to simulate how real enterprises secure and automate cloud environments while enforcing governance and compliance.

## Why This Project?
Most beginner cloud projects focus only on deploying an application.

Real companies first build:

- Governance
- Security boundaries
- Audit visibility
- Automation pipelines

This project replicates that enterprise foundation before deploying workloads.

## Architecture Diagram
<img width="972" height="768" alt="aws-enterprise-landing-zone (2)" src="https://github.com/user-attachments/assets/37c2aa9f-d259-409a-8881-d4d870b182fe" />


## High-Level Architecture
**Accounts Used**

1. **Management Account**

Acts as the control plane of the organization.

Responsibilities:

- AWS Organizations
- Billing & governance
- Service Control Policies (SCPs)
- Account lifecycle management

2. **Shared Services Account**

Centralized security & observability layer.

Contains:

- Organization CloudTrail
- Central S3 Log Bucket
- CloudWatch Logs
- SNS Alerting
- Jenkins CI/CD server

Purpose:

- Single source of monitoring
- Central audit logs
- Security tooling isolated from workloads

3. **Workloads Environment (OU-based simulation)**

Application environment:

- VPC
- Security Groups
- EC2 workload instance
- Dockerized microservices

## Key Goals Achieved

✔ Multi-account isolation

✔ Centralized logging architecture

✔ Infrastructure as Code automation

✔ Security guardrails using SCPs

✔ CI/CD pipeline validation

✔ DevSecOps security scanning

✔ Automated workload deployment

## Technologies Used

**Cloud**

- AWS Organizations
- AWS CloudTrail
- Amazon EC2
- Amazon S3
- CloudWatch
- SNS
- IAM / SCP

**Infrastructure as Code**

- Terraform

**DevSecOps**

- Jenkins
- Checkov (IaC security scanning)

**Deployment**

- Docker
- Docker Compose

## Security Design Decisions
**Why Multi-Account Architecture?**

Single accounts become unsafe at scale.

Benefits:

- Blast radius reduction
- Isolated permissions
- Centralized auditing
- Enterprise-level governance

**Why Central CloudTrail?**

Without centralized logging:

- Compromised accounts can delete logs.

Central logging ensures:

- Immutable audit trail
- Cross-account visibility
- Compliance readiness

**Why Service Control Policies?**

SCPs prevent dangerous actions:

Examples implemented:

- Root user restrictions
- CloudTrail tampering prevention

This enforces organization-wide security.

## CI/CD Pipeline (Jenkins)
Pipeline stages:

1. Checkout source code

2. Terraform formatting check

3. Terraform validation

4. Security scanning (Checkov)

5. Copy application files

6. Deploy containers to workload EC2

**Why Jenkins?**

Chosen to demonstrate:

- Real enterprise CI/CD
- Self-hosted pipeline management
- SSH-based deployment automation

## DevSecOps — Checkov Integration

Before deployment:

- Terraform code is scanned automatically.

This prevents:

- Public infrastructure
- Weak security configurations
- Missing encryption or monitoring

Security validation becomes:
```
CODE → SECURITY CHECK → DEPLOY
```

## Workload Deployment
Deployment flow:
```
Jenkins → SSH → EC2 Workload → Docker Compose → Microservices
```
Containers are automatically stopped and recreated on every deployment.

## Major Challenges & Solutions
❌ **SSH Permission Issues**

Problem:

```
Permission denied (publickey)
```
Fix:

- Correct Jenkins SSH credentials
- Proper key permissions

❌ **Docker Daemon Errors**

Problem:

```
Cannot connect to Docker daemon
```

Fix:

- Enable Docker service
- Add ec2-user to docker group

❌ **Terraform Organization Errors**

Challenges:

- Organization not enabled
- Role assumption failures
- Policy attachment issues

Solution:

- Correct account context
- Proper provider configurations
- Organization service enablement

❌ **Checkov Security Failures**

Initial scans detected:

- Open security groups
- Missing encryption
- Weak EC2 settings

Improvements:

- Restricted CIDRs
- Instance hardening
- Metadata protection
- Encryption enabled

## Project Evidence

**AWS Organizations**
<img width="1920" height="925" alt="image" src="https://github.com/user-attachments/assets/9106d47c-f87c-4d5a-969f-537cc0059328" />

**SCP Guardrails**
<img width="1920" height="906" alt="image" src="https://github.com/user-attachments/assets/a7ea0fc2-fdb8-43df-91ed-94ed5d2a7106" />

**CloudTrail Organization Logging**
<img width="1920" height="968" alt="Screenshot (75)" src="https://github.com/user-attachments/assets/48318ae6-1221-455a-86db-3c9f757a4aa6" />

**Jenkins Pipeline Success**
<img width="1920" height="984" alt="image" src="https://github.com/user-attachments/assets/6bc565bc-4c44-4dd1-861c-608c0089c1eb" />

## What This Project Demonstrates

This project proves ability to:

- Design enterprise cloud architecture
- Implement governance & compliance
- Automate infrastructure deployment
- Build DevSecOps pipelines
- Troubleshoot real-world cloud problems

## Future Improvements

Possible next phases:

- Remote Terraform State (S3 + DynamoDB)
- OIDC authentication for Jenkins
- Automated rollback pipeline
- Kubernetes/EKS workload migration
- Cost monitoring & budgets
- Automated drift detection

## Final Outcome

This is not a simple deployment project.

It represents:

✅ Enterprise AWS Foundation

✅ Security-first Infrastructure

✅ Automated Compliance & Deployment

## 👨‍💻 Author

**Vivek Challa** 

**Cloud & DevOps Engineer**
