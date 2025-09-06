# Task-19: Apache Setup on App Server 2 - Complete Solution

a. Install httpd package and dependencies on app server 2.


b. Apache should serve on port 6000.


c. There are two website's backups /home/thor/ecommerce and /home/thor/demo on jump_host. Set them up on Apache in a way that ecommerce should work on the link http://localhost:6000/ecommerce/ and demo should work on link http://localhost:6000/demo/ on the mentioned app server.


d. Once configured you should be able to access the website using curl command on the respective app server, i.e curl http://localhost:6000/ecommerce/ and curl http://localhost:6000/demo/



## Step 1: Connect to App Server 2
```bash
# From jump_host, SSH to app server 2
ssh steve@stapp02
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
<img width="362" height="84" alt="image" src="https://github.com/user-attachments/assets/016c9d99-400f-4822-ad99-aa84456a5090" />


## Step 4: Copy Website Backups from Jump Host, 
First login at the jump host:
```bash
scp -r /home/thor/ecommerce steve@stapp02.stratos.xfusioncorp.com:/tmp/
scp -r /home/thor/demo steve@stapp02.stratos.xfusioncorp.com:/tmp/
```

## Step 5: On Stapp02 Set Up Website Directories
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
<img width="967" height="218" alt="image" src="https://github.com/user-attachments/assets/524c3163-5411-4e1f-be55-6bd071fe3c29" />

## Step 6: Start and Enable Apache Service
```bash
# Start httpd service
systemctl start httpd

# Enable httpd to start on boot
systemctl enable httpd

# Check the status
systemctl status httpd
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

<img width="670" height="303" alt="image" src="https://github.com/user-attachments/assets/98daba5b-cf1c-42ab-a45d-8281b814c0cf" />

And the from Jump host




## Troubleshooting Tips
- If curl commands don't work, check if there are index.html files in the directories
- Verify SELinux context if needed: `sudo setsebool -P httpd_can_network_connect 1`
- Check Apache error logs: `sudo tail -f /var/log/httpd/error_log`
- Ensure the directories have proper structure and files

<img width="817" height="414" alt="image" src="https://github.com/user-attachments/assets/d5698435-189c-4beb-ba84-fc86da541e83" />

## Verification Commands
```bash
# Check Apache status
sudo systemctl status httpd


# List files in website directories
ls -la /var/www/html/ecommerce/
ls -la /var/www/html/demo/

# Test websites
curl -I http://localhost:6000/ecommerce/
curl -I http://localhost:6000/demo/
```

The setup should now be complete with both websites accessible via the specified URLs on port 6000!
