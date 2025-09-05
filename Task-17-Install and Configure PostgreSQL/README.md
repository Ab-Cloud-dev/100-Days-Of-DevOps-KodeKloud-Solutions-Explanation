# Task 04: Install and Configure Tomcat Server on App Server 2

## Objective

1. Install Tomcat server on App Server 2
2. Configure it to run on port 3003
3. Deploy ROOT.war file from Jump host
4. Ensure webpage works on base URL: `curl http://stapp02:3003`


## Step-by-Step Solution


Phase 1: Copy WAR File from Jump Host to App Server 2

#### Step 1: Verify WAR File on Jump Host

From jump_host, check if the ROOT.war file exists:

```bash
ls -la /tmp/ROOT.war
```

#### Step 2: Copy ROOT.war to App Server 2

From jump_host, copy the WAR file to App Server 2:

```bash
scp /tmp/ROOT.war steve@stapp02.stratos.xfusioncorp.com:/tmp/
```

### Phase 2: Install and Configure Tomcat on App Server 2

#### Step 3: Connect to App Server 2

```bash
ssh steve@stapp02.stratos.xfusioncorp.com
```


<img width="1577" height="405" alt="image" src="https://github.com/user-attachments/assets/9d623bfb-969c-4503-9339-369a544d9ae3" />


#### Step 4: Installing Tomcat Server

```bash
 sudo yum install tomcat -y
```


#### Step 5: Configure Tomcat Port

Edit the server configuration to use port 3001:

```bash
cp /opt/tomcat/conf/server.xml /opt/tomcat/conf/server.xml.backup
```

Edit server.xml:

```bash
vi /opt/tomcat/conf/server.xml
```

Find the Connector section and change port from 8080 to 3001:

```xml
<!-- Change this line: -->
<Connector port="8080" protocol="HTTP/1.1"

<!-- To: -->
<Connector port="3001" protocol="HTTP/1.1"
```

#### Step 6: Alternative Method Using sed

```bash
sed -i 's/port="8080"/port="3003"/g' /opt/tomcat/conf/server.xml
```

#### Step 7: Verify Port Configuration

```bash
grep -n "port.*3003" /opt/tomcat/conf/server.xml
```

<img width="1188" height="570" alt="image" src="https://github.com/user-attachments/assets/304c7671-bdbe-416c-bf95-80c8a1fa54cb" />


#### Step 8: Enable and Start Tomcat Service

```bash
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat
```

#### Step 9: Check Tomcat Status

```bash
systemctl status tomcat
```


#### Step 10: Test from Jump Host

Return to jump_host and test:

<img width="1188" height="641" alt="image" src="https://github.com/user-attachments/assets/e24a74b7-26a0-4478-9782-07f35d32dcf4" />

