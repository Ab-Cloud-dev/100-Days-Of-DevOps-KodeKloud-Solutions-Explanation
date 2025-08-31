# Task 02: MariaDb Troubleshooting

## Objective

Identifying and resloving the issues with the MariaDb





## Step-by-Step Solution



#### Step 1: Verifying the Status 


```bash
sudo systemctl status mariadb
```

the systemctl status confirms MariaDB exits right after starting, but it’s not showing the real reason (status=1 is just a generic failure).

The actual cause will almost always be in the MariaDB error log.

#### Step 2: Trying to Start the Service but unable to do so
```bash
sudo systemctl start mariadb
```

#### Step 3: Checking Logs 

```bash
sudo tail -n 50 /var/log/mariadb/mariadb.log
```

Can't create/write to file '/run/mariadb/mariadb.pid' (Errcode: 13 "Permission denied")
Can't start server: can't create PID file: Permission denied


That means MariaDB cannot write its PID file in /run/mariadb/.

#### Step 4: Edit SSH Configuration
```bash
ls -ld /run/mariadb
#If it doesn’t exist, create it
sudo mkdir -p /run/mariadb
sudo chown mysql:mysql /run/mariadb
```


This command gives MariaDB’s own user (mysql) ownership of the /run/mariadb folder so that the database server can create its necessary PID/socket files when it starts.


