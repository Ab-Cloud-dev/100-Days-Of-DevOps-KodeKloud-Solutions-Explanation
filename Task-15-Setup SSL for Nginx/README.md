# Task:

1. Install and configure `nginx` on `App Server 3`.  

2. On `App Server 3` there is a self signed SSL certificate and key present at location `/tmp/nautilus.crt` and `/tmp/nautilus.key`. Move them to some appropriate location and deploy the same in Nginx.  

3. Create an `index.html` file with content `Welcome!` under Nginx document root.  

4. For final testing try to access the `App Server 3` link (either hostname or IP) from `jump host` using curl command. For example `curl -Ik https://<app-server-ip>/`.

## 1. Update the System

Begin by updating the package manager cache and upgrading all installed packages to their latest versions.

```bash
sudo dnf update -y
```

## 2. Install NGINX

Install the `nginx` package from the repositories.

```bash
sudo dnf install nginx -y
```

## 3. Enable and Start NGINX Service

Configure NGINX to start automatically on system boot and then start the service immediately.

```bash
sudo systemctl enable nginx
sudo systemctl start nginx
```

## 4. Check Service Status

Verify that the NGINX service is active and running without errors.

```bash
sudo systemctl status nginx
```

## 5. Set Up SSL Directory and Certificates

Create a directory to store SSL certificates and move the provided certificate and key files into it.

```bash
sudo mkdir -p /etc/nginx/ssl
sudo mv /tmp/nautilus.crt /etc/nginx/ssl/
sudo mv /tmp/nautilus.key /etc/nginx/ssl/
```

## 6. Set Secure Permissions for Key Files

Restrict permissions on the key files to ensure only privileged users can read them.

```bash
sudo chmod 600 /etc/nginx/ssl/nautilus.key
sudo chmod 644 /etc/nginx/ssl/nautilus.crt
```

<img width="1341" height="511" alt="image" src="https://github.com/user-attachments/assets/4f33bc76-e037-425d-a095-34945d312ecc" />

## 7. Set Secure Permissions for Key Files

then feed the cert and key location in the ngnix configuration And uncomment the whole paragraph.

<img width="1292" height="891" alt="image" src="https://github.com/user-attachments/assets/84dac02d-1eda-461c-a75c-8e0b6449f04e" />

## 7. Test NGINX Configuration

Before applying any changes, always test the NGINX configuration for syntax errors.

```bash
sudo nginx -t
```

## 8. Reload NGINX Service

If the configuration test is successful, reload NGINX to apply the new configuration without dropping connections.

```bash
sudo systemctl reload nginx
```

## 9. Create a Basic Welcome Page

Replace the default landing page with a simple "Welcome!" message.

```bash
echo "Welcome!" | sudo tee /usr/share/nginx/html/index.html
```

---

<img width="1480" height="583" alt="image" src="https://github.com/user-attachments/assets/ef7e364f-1b01-4f44-b47b-38da9d696b39" />

---
