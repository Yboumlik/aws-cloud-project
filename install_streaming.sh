#!/bin/bash

# ==========================================
# AWS Live Streaming Server Installer
# Installs NGINX + RTMP Module on Amazon Linux 2023
# ==========================================

# 1. Update System & Install Build Tools
echo "🚀 Updating system and installing dependencies..."
sudo dnf update -y
sudo dnf groupinstall "Development Tools" -y
sudo dnf install pcre-devel zlib-devel openssl-devel -y

# 2. Download NGINX and RTMP Module
echo "📥 Downloading NGINX and RTMP module..."
cd /tmp
wget https://nginx.org/download/nginx-1.24.0.tar.gz
wget https://github.com/arut/nginx-rtmp-module/archive/master.zip

tar -zxvf nginx-1.24.0.tar.gz
unzip master.zip

# 3. Compile NGINX with RTMP
echo "🔨 Compiling NGINX..."
cd nginx-1.24.0
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master
make
sudo make install

# 4. Configure NGINX (RTMP + HLS)
echo "⚙️ Configuring NGINX..."
sudo cat <<EOF > /usr/local/nginx/conf/nginx.conf
worker_processes  1;

events {
    worker_connections  1024;
}

# RTMP Configuration (Input from OBS)
rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;
            
            # Turn on HLS
            hls on;
            hls_path /tmp/hls;
            hls_fragment 3;
            hls_playlist_length 60;
        }
    }
}

# HTTP Configuration (Output to Browser)
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        # Serve HLS fragments
        location /hls {
            # Serve HLS fragments
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /tmp;
            add_header Cache-Control no-cache;
            add_header Access-Control-Allow-Origin *;
        }
    }
}
EOF

# 5. Create Web Player (index.html)
echo "🌐 Creating Web Player..."
sudo cat <<EOF > /usr/local/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>AWS Live Stream</title>
    <link href="https://vjs.zencdn.net/7.20.3/video-js.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #1a1a1a;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        h1 { margin-bottom: 20px; }
        .video-container {
            box-shadow: 0 0 20px rgba(0,0,0,0.5);
            border-radius: 8px;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <h1>🔴 Live Stream Demo</h1>
    <div class="video-container">
        <video-js id="my_video_1" class="vjs-default-skin" controls preload="auto" width="640" height="360">
            <source src="http://$(curl -s http://checkip.amazonaws.com)/hls/stream.m3u8" type="application/x-mpegURL">
        </video-js>
    </div>

    <script src="https://vjs.zencdn.net/7.20.3/video.min.js"></script>
    <script>
        var player = videojs('my_video_1');
        player.play();
    </script>
</body>
</html>
EOF

# 6. Start NGINX
echo "✅ Starting NGINX..."
sudo /usr/local/nginx/sbin/nginx

echo "=========================================="
echo "🎉 Installation Complete!"
echo "RTMP URL (for OBS): rtmp://$(curl -s http://checkip.amazonaws.com)/live"
echo "Stream Key: stream"
echo "Web Player URL: http://$(curl -s http://checkip.amazonaws.com)/"
echo "=========================================="
