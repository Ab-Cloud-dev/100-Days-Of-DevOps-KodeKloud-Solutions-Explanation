# Task-97


Create an IAM policy named `iampolicy_anita` in `us-east-1` region using Terraform. It must allow read-only access to the EC2 console, i.e., this policy must allow users to view all instances, AMIs, and snapshots in the Amazon EC2 console.

The Terraform working directory is `/home/bob/terraform`. Create the `main.tf` file (do not create a different `.tf` file) to accomplish this task.


---

# Solution:

```hcl
# Create IAM Policy for EC2 Read-Only Access
resource "aws_iam_policy" "iampolicy_anita" {
  name        = "iampolicy_anita"
  description = "Read-only access to view EC2 instances, AMIs, and snapshots in the console"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "EC2ReadOnlyAccess"
        Effect   = "Allow"
        Action   = [
          # EC2 read-only permissions
          "ec2:Describe*",
          "ec2:GetConsoleOutput",
          "ec2:GetPasswordData",
          # Related resources (like AMIs and snapshots)
          "ec2:DescribeImages",
          "ec2:DescribeSnapshots"
        ]
        Resource = "*"
      },
      {
        Sid      = "EC2ConsoleAccess"
        Effect   = "Allow"
        Action   = [
          # Console-specific actions for viewing EC2
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}
```
