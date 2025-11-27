# AWS Cloud Project: WordPress Deployment

## 🚀 Quick Start Guide for Partners

**Goal:** Deploy a WordPress blog on AWS Free Tier and finish the report in < 1 hour.

### Step 1: Get the Files
You are already here! You have the scripts and guides.

### Step 2: Follow the Master Guide
Open **[aws_wordpress_guide.md](./aws_wordpress_guide.md)**. This is your roadmap.
- **Phase 1 (Network):** Create 2 Security Groups in AWS EC2 Console.
- **Phase 2 (Database):** Create an RDS MySQL database (Free Tier). **Copy the Endpoint URL!**
- **Phase 3 (Server):** Launch an EC2 instance (Amazon Linux 2023).

### Step 3: The "Magic" Installation
When launching the EC2 instance (Phase 3), or after logging in via SSH:
1.  Copy the code from **[install_wordpress.sh](./install_wordpress.sh)**.
2.  Run it on the server.
    ```bash
    # If running manually on the server:
    nano install.sh
    # Paste code, save (Ctrl+O, Enter, Ctrl+X)
    chmod +x install.sh
    sudo ./install.sh
    ```
3.  This installs Apache, PHP, and downloads WordPress for you.

### Step 4: Connect & Finish
1.  Go to `http://<YOUR-EC2-IP>` in your browser.
2.  Enter the Database Endpoint, User, and Password you created in Phase 2.
3.  Click "Install". **Done!**

### Step 5: The Report
1.  Open **[project_report_template.md](./project_report_template.md)**.
2.  As you do the steps above, take screenshots of:
    - EC2 Console (Running)
    - RDS Console (Available)
    - The WordPress Home Page
3.  Paste them into the report.
4.  Export to PDF. Submit. 🎓
