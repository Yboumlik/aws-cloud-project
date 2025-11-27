# AWS Cloud Project: Live Streaming Server

## 🚀 Quick Start Guide for Partners

**Goal:** Deploy a custom **Live Streaming Server** (like Twitch) on AWS EC2.

### Step 1: Get the Files
You are already here! You have the scripts and guides.

### Step 2: Follow the Master Guide
Open **[aws_streaming_guide.md](./aws_streaming_guide.md)**. This is your roadmap.
- **Phase 1 (Network):** Create a Security Group allowing Ports **1935** (Video) and **80** (Web).
- **Phase 2 (Server):** Launch an EC2 instance (Amazon Linux 2023).
- **Phase 3 (Software):** Run the auto-installer script.

### Step 3: The "Magic" Installation
When connected to your EC2 server:
1.  Copy the code from **[install_streaming.sh](./install_streaming.sh)**.
2.  Run it on the server.
    ```bash
    nano install.sh
    # Paste code, save (Ctrl+O, Enter, Ctrl+X)
    chmod +x install.sh
    sudo ./install.sh
    ```
3.  This compiles NGINX and sets up the video player for you.

### Step 4: Stream & Watch
1.  **Stream:** Use **OBS Studio** to stream to `rtmp://<EC2-IP>/live`.
2.  **Watch:** Go to `http://<EC2-IP>/` in your browser.

### Step 5: The Report
1.  Open **[project_report_template.md](./project_report_template.md)**.
2.  Take screenshots as you go (EC2, OBS, Browser).
3.  Export to PDF. Submit. 🎓
