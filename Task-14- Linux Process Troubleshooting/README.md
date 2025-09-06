

# Task::  Linux Process Troubleshooting


The production support team of xFusionCorp Industries has deployed some of the latest monitoring tools to keep an eye on every service, application, etc. running on the systems. One of the monitoring systems reported about Apache service unavailability on one of the app servers in Stratos DC.



a. Identify the faulty app host and fix the issue. Make sure Apache service is up and running on all app hosts.

b. They might not have hosted any code yet on these servers, so you don’t need to worry if Apache isn’t serving any pages.

c. Just make sure the service is up and running. Also, make sure Apache is running on port 8083 on all app servers.



## Step 1: Checking the Apache service on each server 

```
systemctl status httpd
```
<img width="822" height="83" alt="image" src="https://github.com/user-attachments/assets/34760ecb-0547-45a9-8a65-b28ba11f3ea1" />

<img width="777" height="213" alt="image" src="https://github.com/user-attachments/assets/80bb3d9e-d146-4ef2-8d56-031cdcf450ec" />

<img width="818" height="86" alt="image" src="https://github.com/user-attachments/assets/46ff10b3-18cd-4cda-b001-eecbd4cc24a5" />



As we can see the issue is with the stapp01 only and reason given is " no listening sockets available, shutting down"


<img width="1341" height="402" alt="image" src="https://github.com/user-attachments/assets/f41a76fe-6e76-48d7-8d5c-b32940324bae" />


and we see it says 

Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8083

That means apache2 service is already configured with the port 8083
 
First we have to verify whether any other service is using that port and  as we can see the sendmail service is using that port. Our task is run the apache server over the port 8083. SO we will be Stopping the sendmail service. And then restarting the httpd service. This should  be enough, as we don't have to worry if Apache isn’t serving any pages. Our task is to ensure the service is up and running over port 8083. 

```bash
# Test connectivity using telnet
sudo netstat -tlnp | grep ":8083"
systemctl stop sendmail 
systemctl restatus httpd

```


<img width="967" height="133" alt="image" src="https://github.com/user-attachments/assets/a9b269ac-775e-42ee-a163-51d69cf1b2e5" />

<img width="2000" height="627" alt="image" src="https://github.com/user-attachments/assets/4b2e2d22-4e8d-41ff-bc2d-5a44b51f97bc" />

