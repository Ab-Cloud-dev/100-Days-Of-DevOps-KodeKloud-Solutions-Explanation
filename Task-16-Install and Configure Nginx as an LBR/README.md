# Task
a. Install nginx on LBR (load balancer) server.
b. Configure load-balancing with the an http context making use of all App Servers. Ensure that you update only the main Nginx configuration file located at /etc/nginx/nginx.conf.
c. Make sure you do not update the apache port that is already defined in the apache configuration on all app servers, also make sure apache service is up and running on all app servers.
d. Once done, you can access the website using StaticApp button on the top bNginx Load Balancer Setup on LBR Server

## Step 1: Connect to LBR Server

```bash
# From jump host, SSH to the load balancer server
ssh loki@stlb01
```

## Step 2: Install Nginx

```bash
# Update the system
sudo yum update -y

# Install nginx
sudo yum install nginx -y

# Check if nginx is installed successfully
nginx -v
```

## Step 3: Check on which Port Apache service is configured on App Server

configuring the load balancer, let's verify Apache is running on all app servers:

```bash
 sudo cat  /etc/httpd/conf/httpd.conf | grep "Listen"
curl http://localhost:8084
```
<img width="1059" height="240" alt="image" src="https://github.com/user-attachments/assets/d09c48a1-e71c-4bdb-ac19-45b67a5b42af" />

## Step 4: Then Configuring Nginx Load Balancer

Back on the LBR server (stlb01), edit the main nginx configuration as per the port configured for the Apache service on App server, so that LB can relay the traffic to AppServers:

```bash
# Backup the original configuration
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Edit the main nginx configuration file
sudo vi /etc/nginx/nginx.conf
```

<img width="1260" height="442" alt="image" src="https://github.com/user-attachments/assets/da019e4e-b76b-48dd-ab3e-5de58c536fbc" />


## Step 5: Nginx Configuration Content

Replace the content of `/etc/nginx/nginx.conf` with the following configuration:

```nginx
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load balancer upstream configuration
    upstream app_servers {
        server 172.16.238.10:8084;    # stapp01
        server 172.16.238.11:8084;    # stapp02
        server 172.16.238.12:8084;    # stapp03
    }

    # Default server configuration
    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load balancer location
        location / {
            proxy_pass http://app_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        error_page   404              /404.html;
            location = /40x.html {
        }

        error_page   500 502 503 504  /50x.html;
            location = /50x.html {
        }
    }
}
```

## Step 6: Test Nginx Configuration

```bash
# Test the nginx configuration for syntax errors
sudo nginx -t

# If the test is successful, you should see:
# nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
# nginx: configuration file /etc/nginx/nginx.conf test is successful
```
<img width="1369" height="340" alt="image" src="https://github.com/user-attachments/assets/aa663f5c-edea-488b-a4f8-5c1a8a01a8eb" />

## Step 7: Start and Enable Nginx

```bash
# Start nginx service
sudo systemctl start nginx

# Enable nginx to start on boot
sudo systemctl enable nginx

# Check nginx status
sudo systemctl status nginx

# Verify nginx is listening on port 80
sudo netstat -tlnp | grep :80
sudo ss -tlnp | grep :80
```


## Step 8: Verify Load Balancer is Working

```bash
# Test locally from LBR server
curl http://localhost
```
<img width="763" height="148" alt="image" src="https://github.com/user-attachments/assets/15d6c29a-374d-4407-a7de-5770acaccc27" />


## Step 10: Final Verification from Jump Host and clicking on provided link

Exit from LBR server and test from jump host:

<img width="934" height="175" alt="image" src="https://github.com/user-attachments/assets/0aef6cbd-ec10-4e75-874c-b45c24bc05da" />


## Troubleshooting Commands

If you encounter issues:

```bash
# Check nginx error logs
sudo tail -f /var/log/nginx/error.log

# Check nginx access logs  
sudo tail -f /var/log/nginx/access.log

# Check if app servers are reachable from LBR
telnet 172.16.238.10 8084
telnet 172.16.238.11 8084 
telnet 172.16.238.12 8084

# Restart nginx if needed
sudo systemctl restart nginx

# Check nginx process
ps aux | grep nginx
```

## Important Notes

1. **Apache Port**: The configuration uses port 8084 for Apache. Do not change Apache configuration.

2. **Load Balancing Method**: Using default round-robin load balancing.

3. **Health Checks**: Nginx will automatically detect if a server is down and route traffic to healthy servers.

4. **StaticApp Button**: Once configured, the StaticApp button on the top bar should work and show content from the app servers through the load balancer.

5. **Persistence**: All configurations will persist after reboot since nginx service is enabled.
