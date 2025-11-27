#!/bin/bash

# AWS Free Tier WordPress Installation Script
# For Amazon Linux 2023
# Usage: sudo ./install_wordpress.sh

# 1. Update System
echo "Updating system packages..."
dnf update -y

# 2. Install LAMP Stack (Linux, Apache, MySQL/MariaDB, PHP)
echo "Installing Apache, PHP, and MariaDB client..."
dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel
dnf install -y mariadb105-server # Installs client and server, we just need client usually but this ensures dependencies

# 3. Start and Enable Apache
echo "Starting Apache Web Server..."
systemctl start httpd
systemctl enable httpd

# 4. Download and Configure WordPress
echo "Downloading WordPress..."
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

# 5. Set Permissions
echo "Setting file permissions..."
usermod -a -G apache ec2-user
chown -R apache:apache /var/www/html
chmod 2775 /var/www/html
find /var/www/html -type d -exec chmod 2775 {} \;
find /var/www/html -type f -exec chmod 0664 {} \;

# 6. Create wp-config.php (Placeholder)
echo "Creating wp-config.php sample..."
cp wp-config-sample.php wp-config.php

# 7. Restart Apache
systemctl restart httpd

echo "=========================================="
echo "WordPress Installation Complete!"
echo "Next Steps:"
echo "1. Create an RDS Database."
echo "2. Edit /var/www/html/wp-config.php with DB details."
echo "3. Open your browser and go to http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "=========================================="
