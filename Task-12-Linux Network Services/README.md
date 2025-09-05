# Apache Service Troubleshooting on stapp01

## Step 1: Initial Connectivity Check from Jump Host

First, let's test the connectivity to stapp01 on port 8086:

```bash
# Test connectivity using telnet
telnet stapp01 8086

# Test HTTP response
curl http://stapp01:8086
```
<img width="841" height="174" alt="image" src="https://github.com/user-attachments/assets/54871c9d-9dff-4102-a817-4f283a9356fe" />

all getting failed 



## Step 2: Connect to stapp01 and Check Apache Service

```bash
# SSH to stapp01 from jump host
ssh tony@stapp01

# Check Apache service status
sudo systemctl status httpd
```
<img width="1227" height="476" alt="image" src="https://github.com/user-attachments/assets/9b40acb3-fbfe-4a2c-9916-64ddf4b5fa3b" />

```
# or
ps aux | grep apache2
```

## Step 3: Check Apache Configuration and Port Binding

```bash
# Check what ports Apache is configured to listen on
sudo netstat -tlnp | grep httpd

```

Checking which service is running on port 8086

```
sudo netstat -tlnp | grep ":8086"
```

And stopping that service and restarting the httpd

<img width="855" height="206" alt="image" src="https://github.com/user-attachments/assets/23b15452-3387-4106-906a-2659e88535b9" />

But Still not able to access over 8085

<img width="1326" height="142" alt="image" src="https://github.com/user-attachments/assets/4b202ba5-c9ad-465c-ba9d-9880400c229a" />

Apache is listening 8086 ✅
You can SSH from jumphost → stapp01 ✅

That means there is no issue in connectivity and at application level, Need to check whether are restriction at OS level

## Step 4: Check Firewall Settings

# or
sudo iptables -L -n

<img width="1589" height="387" alt="image" src="https://github.com/user-attachments/assets/bbe5ef0b-c520-405b-a90f-0b7211fe52d9" />

Port 22 (SSH) is explicitly allowed. ✅

Everything else (any protocol/port not matched earlier) is being REJECTED by the last rule. ❌

That’s why:

SSH works (22 is allowed).

HTTP on 8086 fails (No route to host) because the packet hits the final REJECT rule.

✅ How to Fix

You need to add an ACCEPT rule for port 8086 before the REJECT rule.

```
sudo iptables -I INPUT -p tcp --dport 8086 -j ACCEPT
sudo service iptables save
sudo iptables -L -n | grep 8086

```

<img width="1589" height="387" alt="image" src="https://github.com/user-attachments/assets/1c5f0080-15e4-4b84-9a61-9de550084b93" />


# Check if port 8086 is allowed



## Step 6: Verification--Testing from jumphost

```bash
# From stapp01, verify Apache is listening on port 8086
telnet stapp01 8086

# Test locally on stapp01
curl http://localhost:8086

# Exit stapp01 and test from jump host
exit
curl http://stapp01:8086
```
<img width="814" height="127" alt="image" src="https://github.com/user-attachments/assets/d0318495-1057-4652-9829-7a1b4fe37236" />
