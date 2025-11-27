# Cloud Computing Project Report
**Project Title:** Live Streaming Infrastructure on AWS
**Student Name:** [Your Name]
**Date:** [Date]

---

## 1. Executive Summary
*Briefly describe the project goal: deploying a custom Live Streaming server using NGINX and RTMP on AWS EC2 to broadcast real-time video.*

## 2. Architecture Design
![Architecture Diagram](./architecture_diagram.md)
*Insert the Mermaid diagram or a screenshot of it here.*

**Components Used:**
- **EC2 (t2.micro):** The core server hosting the streaming engine.
- **NGINX + RTMP Module:** Open-source software compiled to handle video streams.
- **OBS Studio:** The broadcasting client pushing video to the cloud.
- **HLS (HTTP Live Streaming):** Protocol used to deliver video to web browsers.

## 3. Implementation Steps

### 3.1 Network & Security
*Describe the Security Groups created.*
- **Port 1935 (RTMP):** Opened to allow the video stream upload from OBS.
- **Port 80 (HTTP):** Opened to allow users to view the player.
- **Port 22 (SSH):** Opened for server administration.
*Screenshot of Security Group Rules.*
![Security Group Screenshot](path/to/screenshot)

### 3.2 Server Configuration
*Describe the installation process.*
- Launched Amazon Linux 2023.
- Compiled NGINX from source code to include the RTMP module.
- Configured `nginx.conf` to ingest RTMP and output HLS.

### 3.3 Broadcasting (The Input)
*Screenshot of OBS Studio showing the "Streaming" status and connection to the EC2 IP.*
![OBS Screenshot](path/to/screenshot)

### 3.4 Playback (The Output)
*Screenshot of the web browser playing the live video from the EC2 server.*
![Browser Screenshot](path/to/screenshot)

## 4. Challenges & Solutions
- **Challenge:** NGINX does not support RTMP by default.
- **Solution:** Had to download the source code and the `nginx-rtmp-module` and compile them manually using `make`.
- **Challenge:** Latency (Delay).
- **Solution:** Tuned HLS fragment size to 3 seconds to reduce delay while maintaining stability.

## 5. Conclusion
*Final thoughts on the project. Discuss how this demonstrates "Infrastructure as a Service" (IaaS) by building a custom solution from scratch rather than using a managed service.*
