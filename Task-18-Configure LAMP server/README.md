# LAMP Stack Setup with MariaDB

## Part A: Configure App Servers (stapp01, stapp02, stapp03)

### Step 1: Install HTTPD and PHP on stapp01

```bash
# SSH to stapp01
ssh tony@stapp01

# Install httpd, php and dependencies
sudo yum install httpd php php-mysql php-mysqli php-json php-curl -y

# Check installation
php --version
httpd -v
```

### Step 2: Configure Apache to serve on port 8089

```bash
# Edit the main Apache configuration
sudo vi /etc/httpd/conf/httpd.conf

# Find the Listen directive and change it to:
# Listen 8089

# Or add the listen directive if not present
echo "Listen 8089" | sudo tee -a /etc/httpd/conf.d/port8089.conf

# Create a simple PHP test file
sudo tee /var/www/html/index.php << 'EOF'
<?php
$servername = "172.16.239.10";  // DB Server IP
$username = "kodekloud_joy";
$password = "B4zNgHA7Ya";
$dbname = "kodekloud_db1";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "App is able to connect to the database using user kodekloud_joy";
$conn->close();
?>
EOF

# Set proper permissions
sudo chown apache:apache /var/www/html/index.php
sudo chmod 644 /var/www/html/index.php
```

### Step 3: Configure Firewall and Start Services on stapp01

```bash
# Configure firewall for port 8089
sudo firewall-cmd --permanent --add-port=8089/tcp
sudo firewall-cmd --reload

# Start and enable httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Check if httpd is listening on port 8089
sudo netstat -tlnp | grep :8089
sudo systemctl status httpd

# Test locally
curl http://localhost:8089

# Exit from stapp01
exit
```

### Step 4: Repeat for stapp02

```bash
# SSH to stapp02
ssh steve@stapp02

# Install httpd, php and dependencies
sudo yum install httpd php php-mysql php-mysqli php-json php-curl -y

# Configure port 8089
echo "Listen 8089" | sudo tee -a /etc/httpd/conf.d/port8089.conf

# Create the same PHP file
sudo tee /var/www/html/index.php << 'EOF'
<?php
$servername = "172.16.239.10";
$username = "kodekloud_joy";
$password = "B4zNgHA7Ya";
$dbname = "kodekloud_db1";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "App is able to connect to the database using user kodekloud_joy";
$conn->close();
?>
EOF

# Set permissions
sudo chown apache:apache /var/www/html/index.php
sudo chmod 644 /var/www/html/index.php

# Configure firewall
sudo firewall-cmd --permanent --add-port=8089/tcp
sudo firewall-cmd --reload

# Start services
sudo systemctl start httpd
sudo systemctl enable httpd

# Verify
sudo netstat -tlnp | grep :8089
curl http://localhost:8089

# Exit from stapp02
exit
```

### Step 5: Repeat for stapp03

```bash
# SSH to stapp03
ssh banner@stapp03

# Install httpd, php and dependencies
sudo yum install httpd php php-mysql php-mysqli php-json php-curl -y

# Configure port 8089
echo "Listen 8089" | sudo tee -a /etc/httpd/conf.d/port8089.conf

# Create the same PHP file
sudo tee /var/www/html/index.php << 'EOF'
<?php
$servername = "172.16.239.10";
$username = "kodekloud_joy";
$password = "B4zNgHA7Ya";
$dbname = "kodekloud_db1";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "App is able to connect to the database using user kodekloud_joy";
$conn->close();
?>
EOF

# Set permissions
sudo chown apache:apache /var/www/html/index.php
sudo chmod 644 /var/www/html/index.php

# Configure firewall
sudo firewall-cmd --permanent --add-port=8089/tcp
sudo firewall-cmd --reload

# Start services
sudo systemctl start httpd
sudo systemctl enable httpd

# Verify
sudo netstat -tlnp | grep :8089
curl http://localhost:8089

# Exit from stapp03
exit
```

## Part B: Configure MariaDB on Database Server

### Step 6: Install and Configure MariaDB on stdb01

```bash
# SSH to database server
ssh peter@stdb01

# Install MariaDB server
sudo yum install mariadb-server mariadb -y

# Start and enable MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Check status
sudo systemctl status mariadb
```

### Step 7: Secure MariaDB Installation

```bash
# Run mysql secure installation
sudo mysql_secure_installation

# When prompted:
# - Enter current password for root: [Press Enter for none]
# - Set root password? [Y/n]: Y
# - New password: [Set a strong password, e.g., RootPass123!]
# - Re-enter new password: [Confirm password]
# - Remove anonymous users? [Y/n]: Y
# - Disallow root login remotely? [Y/n]: n  (We need remote access)
# - Remove test database? [Y/n]: Y
# - Reload privilege tables? [Y/n]: Y
```

### Step 8: Create Database and User

```bash
# Login to MySQL as root
mysql -u root -p

# Create the database
CREATE DATABASE kodekloud_db1;

# Create the user with remote access
CREATE USER 'kodekloud_joy'@'%' IDENTIFIED BY 'B4zNgHA7Ya';

# Grant all privileges on the database
GRANT ALL PRIVILEGES ON kodekloud_db1.* TO 'kodekloud_joy'@'%';

# Flush privileges
FLUSH PRIVILEGES;

# Verify the user and database
SHOW DATABASES;
SELECT User, Host FROM mysql.user WHERE User = 'kodekloud_joy';

# Exit MySQL
EXIT;
```

### Step 9: Configure MariaDB for Remote Connections

```bash
# Edit MariaDB configuration
sudo vi /etc/my.cnf

# Add or modify the bind-address setting in [mysqld] section:
# [mysqld]
# bind-address = 0.0.0.0

# Or create a new configuration file
sudo tee /etc/my.cnf.d/server.cnf << 'EOF'
[mysqld]
bind-address = 0.0.0.0
EOF

# Restart MariaDB
sudo systemctl restart mariadb

# Configure firewall for MySQL port 3306
sudo firewall-cmd --permanent --add-port=3306/tcp
sudo firewall-cmd --reload

# Verify MariaDB is listening on all interfaces
sudo netstat -tlnp | grep :3306
```

### Step 10: Test Database Connection

```bash
# Test connection locally
mysql -u kodekloud_joy -p'B4zNgHA7Ya' -h localhost kodekloud_db1 -e "SELECT 'Connection successful' as Status;"

# Exit from database server
exit
```

## Part C: Update Load Balancer Configuration

### Step 11: Update Nginx Configuration for Port 8089

```bash
# SSH to load balancer
ssh loki@stlb01

# Edit nginx configuration
sudo vi /etc/nginx/nginx.conf

# Update the upstream section to use port 8089:
# upstream app_servers {
#     server 172.16.238.10:8089;
#     server 172.16.238.11:8089;
#     server 172.16.238.12:8089;
# }

# Or use sed to replace the ports
sudo sed -i 's/:80/:8089/g' /etc/nginx/nginx.conf

# Test nginx configuration
sudo nginx -t

# Restart nginx
sudo systemctl restart nginx

# Exit from load balancer
exit
```

## Part D: Final Verification

### Step 12: Test the Complete Setup

```bash
# From jump host, test individual app servers
curl http://stapp01:8089
curl http://stapp02:8089
curl http://stapp03:8089

# Test through load balancer
curl http://stlb01

# Test database connectivity from jump host
mysql -u kodekloud_joy -p'B4zNgHA7Ya' -h stdb01 kodekloud_db1 -e "SELECT 'Direct DB connection works' as Status;"
```

## Troubleshooting Commands

If you encounter issues:

```bash
# Check Apache status on app servers
ssh tony@stapp01 "sudo systemctl status httpd && sudo netstat -tlnp | grep :8089"

# Check MariaDB status on DB server
ssh peter@stdb01 "sudo systemctl status mariadb && sudo netstat -tlnp | grep :3306"

# Check nginx status on LBR
ssh loki@stlb01 "sudo systemctl status nginx && sudo netstat -tlnp | grep :80"

# Check PHP errors
ssh tony@stapp01 "sudo tail -f /var/log/httpd/error_log"

# Check MariaDB logs
ssh peter@stdb01 "sudo tail -f /var/log/mariadb/mariadb.log"
```

## Expected Result

After completing all steps, when you click the "App" button on the top bar, you should see:
**"App is able to connect to the database using user kodekloud_joy"**

This confirms that:
- Apache is serving PHP on port 8089 on all app servers
- Load balancer is correctly routing traffic
- MariaDB is configured and accessible
- Database user has proper permissions
- PHP can connect to the database successfully