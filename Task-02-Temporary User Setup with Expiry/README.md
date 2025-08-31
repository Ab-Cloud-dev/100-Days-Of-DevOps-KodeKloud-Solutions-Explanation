# Creating a Temporary User with Expiry Date

This guide explains how to create a temporary user account named **`anita`** with an expiry date set to **2024-04-15**.

---

## Step 1: Create the User with Expiry Date
Run the following command:

```bash
sudo useradd -e 2024-04-15 anita
```

<img width="1546" height="259" alt="image" src="https://github.com/user-attachments/assets/38514869-0f3b-4c0d-aaa7-cae4b58ca380" />



## Step 2 : Verify the User Expiry Date

To check the details of the created user:

```bash
sudo chage -l anita
```

## Step 3: Confirm User Exists


```bash
getent passwd anita

```

<img width="1192" height="374" alt="image" src="https://github.com/user-attachments/assets/20c25ae8-c1b1-45a2-9c4f-ff52211c07d1" />

This will display the user entry in /etc/passwd.




## Use Cases for Temporary Accounts

Temporary accounts with expiry dates are useful in many real-world scenarios:


### Testing Purposes

✅For trial runs, CI/CD testing, or application deployments.

✅Accounts expire automatically, keeping the system clean.


### Training Sessions or Workshops

✅Provide temporary login credentials for participants.

✅Accounts vanish after the training period.

### Compliance and Security Policies

✅Reduces risk of orphan accounts and enforces least privilege + time-bound access.
