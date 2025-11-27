# Cloud Computing Project Report
**Project Title:** Scalable Web Application Deployment on AWS
**Student Name:** [Your Name]
**Date:** [Date]

---

## 1. Executive Summary
*Briefly describe the project goal: deploying a WordPress blog using AWS Free Tier services to demonstrate cloud architecture skills.*

## 2. Architecture Design
![Architecture Diagram](./architecture_diagram.md)
*Insert your Mermaid diagram or a screenshot of it here.*

**Components Used:**
- **EC2:** Web server hosting WordPress.
- **RDS:** Managed MySQL database for data persistence.
- **S3:** Object storage for media files.
- **CloudFront:** CDN for fast content delivery.
- **CloudWatch:** Monitoring system health.

## 3. Implementation Steps

### 3.1 Network & Security
*Describe the Security Groups created.*
- **Web SG:** Allowed HTTP/HTTPS/SSH.
- **DB SG:** Allowed MySQL only from Web SG.

### 3.2 Database Deployment (RDS)
*Screenshot of RDS Dashboard showing the active database.*
![RDS Screenshot](path/to/screenshot)

### 3.3 Web Server Deployment (EC2)
*Screenshot of EC2 Dashboard showing the running instance.*
![EC2 Screenshot](path/to/screenshot)

### 3.4 WordPress Configuration
*Describe how you connected WordPress to RDS.*
*Screenshot of the WordPress Admin Dashboard.*
![WP Admin Screenshot](path/to/screenshot)

### 3.5 Storage & CDN (S3 + CloudFront)
*Explain the offloading of media.*
*Screenshot of an image URL showing the CloudFront domain.*
![CDN Screenshot](path/to/screenshot)

## 4. Monitoring & Optimization
### 4.1 CloudWatch Metrics
*Screenshot of the CloudWatch Dashboard.*
![CloudWatch Screenshot](path/to/screenshot)

### 4.2 Optimization Suggestions
- **Caching:** Implement W3 Total Cache on WordPress.
- **Auto Scaling:** Create an Auto Scaling Group (ASG) to handle traffic spikes (future improvement).
- **Security:** Move RDS to a private subnet (requires NAT Gateway, which costs money, so skipped for Free Tier).

## 5. Challenges & Solutions
*List any issues faced (e.g., database connection errors) and how you solved them.*

## 6. Conclusion
*Final thoughts on the project and what was learned about AWS.*
