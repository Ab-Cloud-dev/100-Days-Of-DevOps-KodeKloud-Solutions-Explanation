# Apache Service Troubleshooting on stapp01

## Step 1: Initial Connectivity Check from Jump Host

First, let's test the connectivity to stapp01 on port 8086:

```bash
# Test connectivity using telnet
telnet stapp01 8086

# Alternative test using nc (netcat)
nc -zv stapp01 8086

# Test HTTP response
curl http://stapp01:8086
```

## Step 2: Connect to stapp01 and Check Apache Service

```bash
# SSH to stapp01 from jump host
ssh tony@stapp01

# Check Apache service status
sudo systemctl status httpd
# or
sudo systemctl status apache2

# Check if Apache is running
ps aux | grep httpd
# or
ps aux | grep apache2
```

## Step 3: Check Apache Configuration and Port Binding

```bash
# Check what ports Apache is configured to listen on
sudo netstat -tlnp | grep httpd
# or
sudo ss -tlnp | grep httpd

# Check Apache configuration for port 8086
sudo grep -r "Listen" /etc/httpd/conf/
sudo grep -r "Listen" /etc/httpd/conf.d/
# or for Ubuntu/Debian systems:
sudo grep -r "Listen" /etc/apache2/

# Check the main Apache configuration
sudo cat /etc/httpd/conf/httpd.conf | grep Listen
# or
sudo cat /etc/apache2/ports.conf | grep Listen
```

## Step 4: Check Firewall Settings

```bash
# Check firewall status
sudo systemctl status firewalld
# or
sudo systemctl status iptables

# Check firewall rules
sudo firewall-cmd --list-all
# or
sudo iptables -L -n

# Check if port 8086 is allowed
sudo firewall-cmd --list-ports
sudo netstat -tlnp | grep :8086
```

## Step 5: Troubleshooting Actions

### If Apache is not running:
```bash
# Start Apache service
sudo systemctl start httpd
# or
sudo systemctl start apache2

# Enable Apache to start on boot
sudo systemctl enable httpd
# or
sudo systemctl enable apache2
```

### If Apache is not listening on port 8086:
```bash
# Edit Apache configuration to listen on port 8086
sudo vi /etc/httpd/conf/httpd.conf
# Add or modify: Listen 8086

# Or create a new configuration file
echo "Listen 8086" | sudo tee /etc/httpd/conf.d/port8086.conf

# Restart Apache
sudo systemctl restart httpd
```

### If firewall is blocking port 8086:
```bash
# Allow port 8086 through firewall
sudo firewall-cmd --permanent --add-port=8086/tcp
sudo firewall-cmd --reload

# Or for iptables
sudo iptables -A INPUT -p tcp --dport 8086 -j ACCEPT
sudo service iptables save
```

## Step 6: Verification

```bash
# From stapp01, verify Apache is listening on port 8086
sudo netstat -tlnp | grep :8086
sudo ss -tlnp | grep :8086

# Test locally on stapp01
curl http://localhost:8086

# Exit stapp01 and test from jump host
exit
curl http://stapp01:8086
```

## Common Issues and Solutions

1. **Apache not installed**: `sudo yum install httpd` (CentOS)
2. **SELinux blocking**: `sudo setsebool -P httpd_can_network_connect 1`
3. **Wrong port configuration**: Edit `/etc/httpd/conf/httpd.conf` or `/etc/httpd/conf.d/`
4. **Firewall blocking**: Add port 8086 to firewall rules
5. **Service not enabled**: `sudo systemctl enable httpd`

## Security Considerations

- Only open port 8086, don't disable the entire firewall
- Use specific firewall rules rather than broad permissions
- Ensure Apache is running with proper user permissions
- Check that only necessary Apache modules are enabled