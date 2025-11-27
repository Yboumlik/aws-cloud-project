# AWS Free Tier WordPress Deployment Guide

## Prerequisites
- AWS Account (Free Tier eligible)
- Terminal (Mac/Linux) or PuTTY (Windows)
- Basic knowledge of Linux commands

---

## Phase 1: Network & Security (VPC)
*Note: We will use the default VPC for simplicity, but ensure Security Groups are tight.*

1.  **Create Security Group for Web Server:**
    - Go to **EC2 Dashboard** -> **Security Groups** -> **Create security group**.
    - Name: `WP-Web-SG`
    - **Inbound Rules:**
        - Type: HTTP, Source: Anywhere-IPv4 (0.0.0.0/0)
        - Type: HTTPS, Source: Anywhere-IPv4 (0.0.0.0/0)
        - Type: SSH, Source: My IP (Your current IP)
    - **Outbound Rules:** Leave default (Allow all).

2.  **Create Security Group for Database:**
    - Name: `WP-DB-SG`
    - **Inbound Rules:**
        - Type: MYSQL/Aurora, Source: Custom -> Select `WP-Web-SG` (This allows only your web server to access the DB).

---

## Phase 2: Database Setup (RDS)
1.  Go to **RDS Dashboard** -> **Create database**.
2.  **Choose a database creation method:** Standard create.
3.  **Engine options:** MySQL.
4.  **Templates:** Free tier.
5.  **Settings:**
    - DB instance identifier: `wordpress-db`
    - Master username: `admin`
    - Master password: `YourStrongPassword123!` (Remember this!)
6.  **Instance configuration:** `db.t2.micro` (or `db.t3.micro` if eligible).
7.  **Storage:** 20 GiB General Purpose SSD (gp2).
8.  **Connectivity:**
    - VPC: Default VPC.
    - Public access: **No**.
    - VPC security group: Choose `WP-DB-SG`.
9.  **Additional configuration:**
    - Initial database name: `wordpress` (Crucial step! If missed, you have to create it manually).
    - Uncheck "Enable automated backups" if you want to strictly avoid storage costs, but 7 days is usually free.
10. Click **Create database**. Wait for status to become "Available".
11. **Note the Endpoint:** Copy the endpoint URL (e.g., `wordpress-db.cx...us-east-1.rds.amazonaws.com`).

---

## Phase 3: Web Server Setup (EC2)
1.  Go to **EC2 Dashboard** -> **Launch Instances**.
2.  **Name:** `WordPress-Server`
3.  **AMI:** Amazon Linux 2023 AMI (Free tier eligible).
4.  **Instance Type:** `t2.micro`.
5.  **Key pair:** Create new key pair (e.g., `wp-key`), download the `.pem` file.
6.  **Network settings:**
    - Select existing security group: `WP-Web-SG`.
7.  **Advanced details:**
    - Scroll down to **User data** (Optional automation). You can paste the `install_wordpress.sh` content here to auto-install on boot.
    - *Alternatively, we will run the script manually.*
8.  Click **Launch instance**.

### Connect and Install
1.  Open Terminal.
2.  Move key to a safe place: `mv ~/Downloads/wp-key.pem ~/.ssh/`
3.  Set permissions: `chmod 400 ~/.ssh/wp-key.pem`
4.  Connect: `ssh -i ~/.ssh/wp-key.pem ec2-user@<EC2-Public-IP>`
5.  **Run the Installation Script:**
    - Upload the script or create it: `nano install_wordpress.sh` (Paste content).
    - Make executable: `chmod +x install_wordpress.sh`
    - Run: `sudo ./install_wordpress.sh`

---

## Phase 4: Connect WordPress to RDS
1.  After the script finishes, open your browser: `http://<EC2-Public-IP>`
2.  You should see the WordPress setup screen. Click **Let's go!**.
3.  **Enter Database Details:**
    - Database Name: `wordpress`
    - Username: `admin`
    - Password: `YourStrongPassword123!`
    - Database Host: `<RDS-Endpoint>` (Paste the endpoint from Phase 2).
    - Table Prefix: `wp_`
4.  Click **Submit** -> **Run the installation**.
5.  Create your admin account and login.

---

## Phase 5: Offload Media to S3 & CloudFront
### S3 Setup
1.  Go to **S3** -> **Create bucket**.
2.  Name: `my-wp-media-bucket-unique-123` (Must be globally unique).
3.  Region: Same as EC2 (e.g., us-east-1).
4.  **Block Public Access settings:** Uncheck "Block all public access" (We need public read for now, or use CloudFront OAC for better security. For simplicity/Free Tier demo, public read with bucket policy is easiest).
    - Acknowledge the warning.
5.  Click **Create bucket**.
6.  **Bucket Policy:** Go to Permissions -> Bucket policy -> Edit.
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "PublicReadGetObject",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::my-wp-media-bucket-unique-123/*"
            }
        ]
    }
    ```

### CloudFront Setup
1.  Go to **CloudFront** -> **Create distribution**.
2.  **Origin domain:** Select your S3 bucket.
3.  **Viewer protocol policy:** Redirect HTTP to HTTPS.
4.  Click **Create distribution**.
5.  Copy the **Distribution Domain Name** (e.g., `d12345.cloudfront.net`).

### WordPress Configuration
1.  Login to WordPress Admin.
2.  Install Plugin: **WP Offload Media Lite** (or similar S3 plugin).
3.  Activate and go to Settings.
4.  Enter AWS Access Keys (Create an IAM User `wp-s3-user` with `AmazonS3FullAccess` for this).
5.  Select your bucket.
6.  Enable CloudFront and enter your Distribution Domain Name.
7.  Save. Now uploaded images go to S3 and are served via CloudFront!

---

## Phase 6: Monitoring (CloudWatch)
1.  Go to **CloudWatch**.
2.  **Dashboards** -> **Create dashboard**.
3.  Name: `WordPress-Monitor`.
4.  Add Widget -> Line.
5.  **Metrics:**
    - EC2 -> Per-Instance Metrics -> Select your instance -> `CPUUtilization`.
    - RDS -> DBInstanceIdentifier -> Select your DB -> `CPUUtilization`, `FreeStorageSpace`.
6.  Save Dashboard.
7.  **Create Alarm:**
    - Alarms -> Create alarm.
    - Select Metric: EC2 CPUUtilization.
    - Condition: Greater than 80% for 5 minutes.
    - Action: Notification (SNS) -> Create new topic -> Enter email.

---

## Screenshot Checkpoints for Report
Take screenshots of the following:
1.  **EC2 Console:** Showing "Running" instance.
2.  **RDS Console:** Showing "Available" database.
3.  **WordPress Installation:** The "Welcome" screen.
4.  **S3 Bucket:** Showing an uploaded image file.
5.  **CloudWatch Dashboard:** Showing the graphs.
6.  **Final Blog:** The live website front page.
