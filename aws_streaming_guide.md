# AWS Live Streaming Project Guide

**Goal:** Build your own Live Streaming Server (like a mini-Twitch) on AWS EC2.

---

## Phase 1: Create Security Group (The Firewall)
Before launching the server, we need to allow traffic for Video (RTMP) and Web (HTTP).

1.  Log in to **AWS Console** > **EC2** > **Security Groups**.
2.  Click **Create security group**.
    *   **Name:** `Streaming-SG`
    *   **Description:** `Allow RTMP and HTTP`
3.  **Inbound Rules** (Add these 3 rules):
    *   **Type:** `HTTP` | **Port:** `80` | **Source:** `Anywhere-IPv4` (0.0.0.0/0) -> *For people to watch.*
    *   **Type:** `Custom TCP` | **Port:** `1935` | **Source:** `Anywhere-IPv4` (0.0.0.0/0) -> *For you to stream video.*
    *   **Type:** `SSH` | **Port:** `22` | **Source:** `My IP` -> *For you to control the server.*
4.  Click **Create security group**.

---

## Phase 2: Launch the Server (EC2)
1.  Go to **EC2 Dashboard** > **Launch Instance**.
2.  **Name:** `Live-Stream-Server`
3.  **OS Image:** `Amazon Linux 2023 AMI` (Free Tier eligible).
4.  **Instance Type:** `t2.micro` (Free Tier eligible).
5.  **Key Pair:** Select your existing key (or create a new one `streaming-key`).
6.  **Network Settings:**
    *   **Firewall (security groups):** Select **"Select existing security group"**.
    *   Choose `Streaming-SG` (the one you just created).
7.  Click **Launch Instance**.

---

## Phase 3: Install the Streaming Software
1.  **Connect to your instance** (Select instance > Connect > EC2 Instance Connect).
2.  **Run the Magic Script:**
    Copy and paste this entire block into the black terminal window:

    ```bash
    nano install.sh
    # Paste the contents of install_streaming.sh here
    # (Open the file install_streaming.sh on your computer, copy all text, and paste it into the terminal)
    # Press Ctrl+O, Enter, then Ctrl+X to save and exit.
    
    chmod +x install.sh
    sudo ./install.sh
    ```

3.  **Wait ~2 minutes.** The script will compile NGINX from source code.
4.  **Success!** At the end, it will show you your **RTMP URL** and **Web URL**.
    *   *Example RTMP:* `rtmp://54.123.45.67/live`
    *   *Example Web:* `http://54.123.45.67/`

---

## Phase 4: Start Streaming (OBS Studio)
You need software on your laptop to send the video.

1.  Download **OBS Studio** (Free) if you don't have it.
2.  Open OBS > **Settings** > **Stream**.
    *   **Service:** `Custom...`
    *   **Server:** `rtmp://<YOUR-EC2-IP>/live` (Copy from the script output)
    *   **Stream Key:** `stream`
3.  Click **OK**.
4.  Add a Source in OBS (e.g., "Video Capture Device" for your webcam, or "Screen Capture").
5.  Click **Start Streaming**.
    *   *Check the bottom right corner. If it's green with a bitrate (e.g., 2500 kb/s), you are live!*

---

## Phase 5: Watch the Stream
1.  Open your web browser (Chrome/Safari/Edge).
2.  Go to: `http://<YOUR-EC2-IP>/`
3.  Wait 10-15 seconds (HLS has a slight delay).
4.  **You should see your video live!** 🎉

---

## Phase 6: The Report
Take screenshots of:
1.  **EC2 Console** (Running instance).
2.  **Security Group Rules** (Showing port 1935).
3.  **OBS Studio** (Streaming green status).
4.  **Browser** (Showing the video playing).

**Don't forget to Terminate your instance when finished to avoid using up your Free Tier bandwidth!**
