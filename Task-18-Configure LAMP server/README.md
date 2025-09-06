# LAMP Stack Setup with MariaDB



a. Install httpd, php and its dependencies on all app hosts.


b. Apache should serve on port 8089 within the apps.


c. Install/Configure MariaDB server on DB Server.


d. Create a database named kodekloud_db4 and create a database user named kodekloud_gem identified as password LQfKeWWxWD. Further make sure this newly created user is able to perform all operation on the database you created.


e. Finally you should be able to access the website on LBR link, by clicking on the App button on the top bar. You should see a message like App is able to connect to the database using user kodekloud_gem

## Part A: Configure MariaDB on Database Server

### Step 1: Install and Configure MariaDB on stdb01

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
<img width="797" height="727" alt="image" src="https://github.com/user-attachments/assets/03846536-8983-4c41-8c56-cbc90c2b5e35" />

### Step 2: Secure MariaDB Installation

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

### Step 3: Create Database and User

```bash
# Login to MySQL as root
mysql -u root -p

# Create the database
CREATE DATABASE kodekloud_db4;

# Create the user with remote access
CREATE USER 'kodekloud_gem'@'%' IDENTIFIED BY 'LQfKeWWxWD';

# Grant all privileges on the database
GRANT ALL PRIVILEGES ON kodekloud_db4.* TO 'kodekloud_gem'@'%';

# Flush privileges
FLUSH PRIVILEGES;

# Verify the user and database
SHOW DATABASES;
SELECT User, Host FROM mysql.user WHERE User = 'kodekloud_gem';

# Exit MySQL
EXIT;
```

### Step 4: Configure MariaDB for Remote Connections

#### create a new configuration file
```bash 
sudo tee /etc/my.cnf.d/server.cnf << 'EOF'
[mysqld]
bind-address = 0.0.0.0
EOF
```

####  Restart MariaDB

```
sudo systemctl restart mariadb
```

### Step 5: Test Database Connection

```bash
# Test connection locally
mysql -u kodekloud_gem -p'LQfKeWWxWD' -h localhost kodekloud_db4 -e "SELECT 'Connection successful' as Status;"

# Exit from database server
exit
```
<img width="1073" height="155" alt="image" src="https://github.com/user-attachments/assets/e71233d3-1d33-4fe0-b35d-92c7debd8179" />

## Part B: Configure App Servers (stapp01, stapp02, stapp03)

### Step 6: Install HTTPD and PHP on stapp01, stapp02, stapp03

```bash
# SSH to stapp01
ssh tony@stapp01

# Install httpd, php and dependencies
sudo yum install httpd php php-mysqlnd  -y

# Check installation
php --version
httpd -v
```


### Step 7: Configure Apache to serve on port 8089

```bash
# Edit the main Apache configuration
sudo vi /etc/httpd/conf/httpd.conf

# Find the Listen directive and change it to:
# Listen 8089
```



# Create a simple PHP test file
```
sudo tee /var/www/html/index.php << 'EOF'
<?php
$servername = "172.16.239.10";  // DB Server IP
$username = "kodekloud_gem";
$password = "LQfKeWWxWD";
$dbname = "kodekloud_db4";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "App is able to connect to the database using user kodekloud_gem";
$conn->close();
?>
EOF
```

For stapp01

<img width="687" height="211" alt="image" src="https://github.com/user-attachments/assets/84da4652-5b0a-4739-bd62-ab15e4015045" />


For Stapp02

<img width="683" height="192" alt="image" src="https://github.com/user-attachments/assets/e70b9895-7ce3-44c5-aac4-d7c6b1a0df1f" />


For stapp03

<img width="725" height="204" alt="image" src="https://github.com/user-attachments/assets/24670788-be7a-4bcf-bf25-c20192dd661b" />



# Set proper permissions
```
sudo chown apache:apache /var/www/html/index.php
sudo chmod 644 /var/www/html/index.php
```

### Step 8: Configure Firewall and Start Services on stapp01

#### Configure firewall for port 8089

```bash
sudo firewall-cmd --permanent --add-port=8089/tcp
sudo firewall-cmd --reload
```

#### Start and enable httpd

```
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd
```

# Test locally

```
curl http://localhost:8089
```
# Exit from stapp01
exit


## Part C: Update Load Balancer Configuration

### Step 9: Update Nginx Configuration for Port 8089

```bash
# SSH to load balancer
ssh loki@stlb01

# Edit nginx configuration
#sudo yum update -y
sudo yum install epel-release -y
sudo yum install nginx -y
```

#### Update the upstream section to use port 8089:
sudo vi /etc/nginx/nginx.conf

```
 upstream app_servers {
     server 172.16.238.10:8089;
     server 172.16.238.11:8089;
     server 172.16.238.12:8089;
 }
```
<img width="521" height="119" alt="image" src="https://github.com/user-attachments/assets/473fd824-7d79-4507-b1b4-d1ebc721209d" />


# Test nginx configuration
```
sudo nginx -t
```
<img width="674" height="89" alt="image" src="https://github.com/user-attachments/assets/5cf3f0c0-4081-401c-a3d3-17caa0602ceb" />


# Restart nginx

sudo systemctl restart nginx

# Exit from load balancer
exit


## Part D: Final Verification

### Step 10: Test the Complete Setup

```bash
# From jump host, test individual app servers
curl http://stapp01:8089
curl http://stapp02:8089
curl http://stapp03:8089
```

<img width="755" height="141" alt="image" src="https://github.com/user-attachments/assets/8f1565ce-82b3-4ec8-a321-d97a44fb2dab" />


# Test through load balancer from host Server 

```
curl http://stlb01
```

<img width="718" height="50" alt="image" src="https://github.com/user-attachments/assets/3bc0ee4f-dcb6-492f-bc74-ecc8b80f9440" />

# Test database connectivity from jump host

```
mysql -u kodekloud_gem -p'LQfKeWWxWD' -h stdb01 kodekloud_db4 -e "SELECT 'Direct DB connection works' as Status;"
```

# Final Verification

<img width="593" height="258" alt="image" src="https://github.com/user-attachments/assets/fb8ef990-fa71-405d-a26c-37fd3a8a6c81" />


## Expected Result

After completing all steps, when you click the "App" button on the top bar, you should see:
**"App is able to connect to the database using user kodekloud_gem"**

This confirms that:
- Apache is serving PHP on port 8089 on all app servers
- Load balancer is correctly routing traffic
- MariaDB is configured and accessible
- Database user has proper permissions
- PHP can connect to the database successfully
