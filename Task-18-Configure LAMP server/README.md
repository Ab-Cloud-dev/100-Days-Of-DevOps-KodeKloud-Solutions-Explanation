# LAMP Stack Setup with MariaDB

## Part A: Configure App Servers (stapp01, stapp02, stapp03)

### Step 1: Install HTTPD and PHP on stapp01

```bash
# SSH to stapp01
ssh tony@stapp01

# Install httpd, php and dependencies
sudo yum install httpd php php-mysqlnd  -y

# Check installation
php --version
httpd -v
```

### Step 2: Configure Apache to serve on port 3000

```bash
# Edit the main Apache configuration
sudo vi /etc/httpd/conf/httpd.conf

# Find the Listen directive and change it to:
# Listen 3000

# Or add the listen directive if not present
echo "Listen 3000" | sudo tee -a /etc/httpd/conf.d/port3000.conf

# Create a simple PHP test file
sudo tee /var/www/html/index.php << 'EOF'
<?php
$servername = "172.16.239.10";  // DB Server IP
$username = "kodekloud_rin";
$password = "B4zNgHA7Ya";
$dbname = "kodekloud_db2";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "App is able to connect to the database using user kodekloud_rin";
$conn->close();
?>
EOF

# Set proper permissions
sudo chown apache:apache /var/www/html/index.php
sudo chmod 644 /var/www/html/index.php
```

### Step 3: Configure Firewall and Start Services on stapp01

```bash
# Configure firewall for port 3000
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload

# Start and enable httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Check if httpd is listening on port 3000
sudo netstat -tlnp | grep :3000
sudo systemctl status httpd

# Test locally
curl http://localhost:3000

# Exit from stapp01
exit
```

### Step 4: Repeat for stapp02

```bash
# SSH to stapp02
ssh steve@stapp02

# Install httpd, php and dependencies
sudo yum install httpd php php-mysql php-mysqli php-json php-curl -y

# Configure port 3000
echo "Listen 3000" | sudo tee -a /etc/httpd/conf.d/port3000.conf

# Create the same PHP file
sudo tee /var/www/html/index.php << 'EOF'
<?php
$servername = "172.16.239.10";
$username = "kodekloud_rin";
$password = "B4zNgHA7Ya";
$dbname = "kodekloud_db2";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "App is able to connect to the database using user kodekloud_rin";
$conn->close();
?>
EOF

# Set permissions
sudo chown apache:apache /var/www/html/index.php
sudo chmod 644 /var/www/html/index.php

# Configure firewall
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload

# Start services
sudo systemctl start httpd
sudo systemctl enable httpd

# Verify
sudo netstat -tlnp | grep :3000
curl http://localhost:3000

# Exit from stapp02
exit
```

### Step 5: Repeat for stapp03

```bash
# SSH to stapp03
ssh banner@stapp03

# Install httpd, php and dependencies
sudo yum install httpd php php-mysql php-mysqli php-json php-curl -y

# Configure port 3000
echo "Listen 3000" | sudo tee -a /etc/httpd/conf.d/port3000.conf

# Create the same PHP file
sudo tee /var/www/html/index.php << 'EOF'
<?php
$servername = "172.16.239.10";
$username = "kodekloud_rin";
$password = "B4zNgHA7Ya";
$dbname = "kodekloud_db2";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "App is able to connect to the database using user kodekloud_rin";
$conn->close();
?>
EOF

# Set permissions
sudo chown apache:apache /var/www/html/index.php
sudo chmod 644 /var/www/html/index.php

# Configure firewall
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload

# Start services
sudo systemctl start httpd
sudo systemctl enable httpd

# Verify
sudo netstat -tlnp | grep :3000
curl http://localhost:3000

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
CREATE DATABASE kodekloud_db2;

# Create the user with remote access
CREATE USER 'kodekloud_rin'@'%' IDENTIFIED BY 'B4zNgHA7Ya';

# Grant all privileges on the database
GRANT ALL PRIVILEGES ON kodekloud_db2.* TO 'kodekloud_rin'@'%';

# Flush privileges
FLUSH PRIVILEGES;

# Verify the user and database
SHOW DATABASES;
SELECT User, Host FROM mysql.user WHERE User = 'kodekloud_rin';

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
mysql -u kodekloud_rin -p'B4zNgHA7Ya' -h localhost kodekloud_db2 -e "SELECT 'Connection successful' as Status;"

# Exit from database server
exit
```

## Part C: Update Load Balancer Configuration

### Step 11: Update Nginx Configuration for Port 3000

```bash
# SSH to load balancer
ssh loki@stlb01

# Edit nginx configuration
sudo vi /etc/nginx/nginx.conf

# Update the upstream section to use port 3000:
# upstream app_servers {
#     server 172.16.238.10:3000;
#     server 172.16.238.11:3000;
#     server 172.16.238.12:3000;
# }

# Or use sed to replace the ports
sudo sed -i 's/:80/:3000/g' /etc/nginx/nginx.conf

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
curl http://stapp01:3000
curl http://stapp02:3000
curl http://stapp03:3000

# Test through load balancer
curl http://stlb01

# Test database connectivity from jump host
mysql -u kodekloud_rin -p'B4zNgHA7Ya' -h stdb01 kodekloud_db2 -e "SELECT 'Direct DB connection works' as Status;"
```

## Troubleshooting Commands

If you encounter issues:

```bash
# Check Apache status on app servers
ssh tony@stapp01 "sudo systemctl status httpd && sudo netstat -tlnp | grep :3000"

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
**"App is able to connect to the database using user kodekloud_rin"**

This confirms that:
- Apache is serving PHP on port 3000 on all app servers
- Load balancer is correctly routing traffic
- MariaDB is configured and accessible
- Database user has proper permissions
- PHP can connect to the database successfully
