# Task 17: Install and Configure Tomcat Server on App Server 2


PostgreSQL database server is already installed on the Nautilus database server.


a. Create a database user kodekloud_pop and set its password to TmPcZjtRQx.


b. Create a database kodekloud_db4 and grant full permissions to user kodekloud_pop on this database.


Note: Please do not try to restart PostgreSQL server service.


## Step-by-Step Solution

## 1. Access the PostgreSQL Interactive Terminal

Start by accessing the PostgreSQL command-line interface as the default superuser (usually `postgres`).

```bash
ssh peter@stdb01
psql -U postgres
```

## 2. Create a New User

Create a new user named `kodekloud_pop` with the specified password.

```sql
CREATE USER kodekloud_pop WITH PASSWORD 'TmPcZjtRQx';
```

## 3. Create a New Database

Create a new database named `kodekloud_db8`.
```
CREATE DATABASE kodekloud_db4;
```
## 4. Grant Privileges

Grant all privileges on the newly created database to the new user.

```
GRANT ALL PRIVILEGES ON DATABASE kodekloud_db4 TO kodekloud_pop;
```



## 5. Verify User Creation

List all users and their roles to confirm the new user was created successfully.

```sql
\du
```
## 6. List All Databases

List all databases to confirm the new database was created and to see its privileges.

```sql
\l
```

<img width="951" height="765" alt="image" src="https://github.com/user-attachments/assets/9c73e282-1775-4df1-8dfa-74e869f4e82e" />
