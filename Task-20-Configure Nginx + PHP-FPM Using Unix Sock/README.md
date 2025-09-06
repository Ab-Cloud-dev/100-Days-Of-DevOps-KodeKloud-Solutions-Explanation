# Configure Nginx + PHP-FPM Using Unix Sock


a. Install nginx on app server 1 , configure it to use port 8092 and its document root should be /var/www/html.


b. Install php-fpm version 8.1 on app server 1, it must use the unix socket /var/run/php-fpm/default.sock (create the parent directories if don't exist).


c. Configure php-fpm and nginx to work together.


d. Once configured correctly, you can test the website using curl http://stapp01:8092/index.php command from jump host.

NOTE: We have copied two files, index.php and info.php, under /var/www/html as part of the PHP-based application setup. Please do not modify these files.

## Step 1: Connect to App Server 1 and install the  PHP-FPM (PHP FastCGI Process Manager) 
```bash
# From jump_host, SSH to app server 1
ssh steve@stapp01
sudo yum install -y php-fpm php-cli php-mysqlnd
sudo yum install -y nginx

```

###Please NOTE

```
Unlike Apache, which has a built-in module to process PHP (mod_php), Nginx cannot process PHP files by itself. 
Nginx is a high-performance web server and reverse proxy, but it needs to hand off PHP requests to a separate, specialized processor.

This is where PHP-FPM comes in. You install these components together so that Nginx can serve static content (images, CSS, JS) incredibly fast
 and delegate the dynamic PHP processing to PHP-FPM, resulting in a very efficient and scalable system.
```

## Step 2: Install httpd Package and Dependencies
```bash
sudo vi /etc/php-fpm.d/www.conf
```
and Changing to **"Listen 8092"**

This opens the main PHP-FPM pool configuration file (www.conf). 
The goal is to change how PHP-FPM listens for incoming requests from Nginx.

## 3. Configure PHP-FPM
Edit the pool configuration:

```
sudo vi /etc/php-fpm.d/www.conf
```

```bash
listen = /var/run/php-fpm/default.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0660
```
Creates a new configuration file for your website (or application) inside the /etc/nginx/conf.d/ directory, which is automatically loaded by Nginx. 
This file defines how Nginx should handle requests for your site.
- listen: Changes the listening method from a network port to a Unix socket file. This is more efficient for communication on the same server.

- listen.owner & listen.group: Ensures the socket file is owned by the nginx user and group, granting Nginx permission to use it.

- listen.mode: Sets secure file permissions (0660) so that only the nginx user and group can read from and write to the socket.

## Configure Nginx
Create config file /etc/nginx/conf.d/stapp01.conf:
```bash
server {
    listen 8092;
    root /var/www/html;
    index index.php index.html;

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php-fpm/default.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```
This defines a server block (virtual host).

listen 8099;: Tells Nginx to listen for incoming requests on port 8092.

root /var/www/html;: Sets the directory from which to serve the website's files.

index ...;: Defines the default files to look for when a directory is requested.

The location block is the most crucial part:

fastcgi_pass ...: Directs Nginx to forward any request for a .php file to the PHP-FPM process using the socket file you configured earlier.

include fastcgi_params; & fastcgi_param ...: Passes necessary parameters to PHP-FPM so it knows which script to execute.

## Step 5: Enable and Start Services
```bash
sudo systemctl enable php-fpm --now
sudo systemctl enable nginx --now
```

These commands use systemctl to manage the system services.

enable: Configures the service to start automatically when the server boots up. This ensures persistence after a reboot.

--now: This flag immediately starts the service in addition to enabling it. It's a combination of systemctl start and systemctl enable.

The services are started in this order: php-fpm first (to create the socket), then nginx (which will connect to it).

## Overall Flow Summary:
Install: Get the necessary software.

Configure PHP-FPM: Tell PHP how to listen for requests (via a socket) and who can access it (Nginx).

Configure Nginx: Tell Nginx where to find the website files and how to pass PHP requests to the PHP-FPM socket.

Start Services: Activate and persist the configuration. PHP-FPM must be running first so its socket exists for Nginx to


