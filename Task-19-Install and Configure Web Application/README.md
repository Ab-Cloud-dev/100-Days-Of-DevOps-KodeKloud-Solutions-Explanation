# Apache Setup on App Server 2 - Complete Solution

Since you're already logged into the jump_host, here's the step-by-step solution:

## Step 1: Connect to App Server 2
```bash
# From jump_host, SSH to app server 2
ssh steve@stapp02.stratos.xfusioncorp.com
# Password: Am3ric@
```

## Step 2: Install httpd Package and Dependencies
```bash
# Switch to root user for installations
sudo su -

# Update the system
yum update -y

# Install httpd package and its dependencies
yum install httpd -y

# Check if httpd is installed successfully
httpd -v
```

## Step 3: Configure Apache to Run on Port 6000
```bash
# Edit the main Apache configuration file
vi /etc/httpd/conf/httpd.conf

# Find the line with "Listen 80" and change it to:
Listen 6000

# Save and exit the file (:wq in vi)
```

## Step 4: Copy Website Backups from Jump Host
```bash
# Exit from root back to steve user
exit

# Copy the website backups from jump_host to app server 2
# First, copy ecommerce backup
scp -r thor@jump_host.stratos.xfusioncorp.com:/home/thor/ecommerce /tmp/
# Password for thor: mjolnir123

# Copy demo backup
scp -r thor@jump_host.stratos.xfusioncorp.com:/home/thor/demo /tmp/
# Password for thor: mjolnir123
```

## Step 5: Set Up Website Directories
```bash
# Switch back to root
sudo su -

# Create directories for the websites in Apache document root
mkdir -p /var/www/html/ecommerce
mkdir -p /var/www/html/demo

# Copy the website files to Apache directories
cp -r /tmp/ecommerce/* /var/www/html/ecommerce/
cp -r /tmp/demo/* /var/www/html/demo/

# Set proper ownership and permissions
chown -R apache:apache /var/www/html/ecommerce
chown -R apache:apache /var/www/html/demo
chmod -R 755 /var/www/html/ecommerce
chmod -R 755 /var/www/html/demo
```

## Step 6: Start and Enable Apache Service
```bash
# Start httpd service
systemctl start httpd

# Enable httpd to start on boot
systemctl enable httpd

# Check the status
systemctl status httpd

# Verify Apache is listening on port 6000
ss -tlnp | grep :6000
# or
netstat -tlnp | grep :6000
```

## Step 7: Test the Configuration
```bash
# Test ecommerce website
curl http://localhost:6000/ecommerce/

# Test demo website  
curl http://localhost:6000/demo/

# You can also test with the full index.html if it exists
curl http://localhost:6000/ecommerce/index.html
curl http://localhost:6000/demo/index.html
```

## Alternative One-Liner Commands (if needed)
If you prefer to execute some commands in one go:

```bash
# Quick setup from jump_host
ssh steve@stapp02.stratos.xfusioncorp.com "sudo yum install httpd -y && sudo sed -i 's/Listen 80/Listen 6000/' /etc/httpd/conf/httpd.conf"

# Copy files and set permissions
scp -r /home/thor/ecommerce steve@stapp02.stratos.xfusioncorp.com:/tmp/
scp -r /home/thor/demo steve@stapp02.stratos.xfusioncorp.com:/tmp/

# Final setup on app server 2
ssh steve@stapp02.stratos.xfusioncorp.com "sudo cp -r /tmp/ecommerce/* /var/www/html/ecommerce/ && sudo cp -r /tmp/demo/* /var/www/html/demo/ && sudo chown -R apache:apache /var/www/html/ && sudo chmod -R 755 /var/www/html/ && sudo systemctl start httpd && sudo systemctl enable httpd"
```

## Troubleshooting Tips
- If curl commands don't work, check if there are index.html files in the directories
- Verify SELinux context if needed: `sudo setsebool -P httpd_can_network_connect 1`
- Check Apache error logs: `sudo tail -f /var/log/httpd/error_log`
- Ensure the directories have proper structure and files

## Verification Commands
```bash
# Check Apache status
sudo systemctl status httpd

# Check if port 6000 is listening
sudo ss -tlnp | grep :6000

# List files in website directories
ls -la /var/www/html/ecommerce/
ls -la /var/www/html/demo/

# Test websites
curl -I http://localhost:6000/ecommerce/
curl -I http://localhost:6000/demo/
```

The setup should now be complete with both websites accessible via the specified URLs on port 6000!