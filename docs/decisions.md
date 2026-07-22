# Decisions & Reasoning

---

## Assumptions — Current Infrastructure

Before starting the tasks, the following assumptions were made based on the project brief:

- No app or web instances were mentioned separately, only general EC2 instances running the application. I decided to implement 2 app servers accessed directly by the public via IP addresses. No ALB was mentioned.
- Only one RDS database is mentioned for user information. I am assuming it is in a single AZ with no high availability or read replicas.
- Several development and production environments are mentioned, but I am assuming this is an operational/logical separation, not an infrastructure separation.
- No specific security groups are mentioned. Default security groups will be used.

---

## Tasks

### 1. Create the Current Architecture

**What this task is solving**

Establishing a clear visual representation of the current infrastructure to understand what exists, identify security flaws, and create a baseline to work from before making any changes.

**What I did**
- Created the current infrastructure as a diagram to get a visual overview, identify flaws, and spot security risks.
- No corrections were made to the current infrastructure, the goal was to accurately represent the existing situation before addressing it.

**Why I did it**
- Without a clear picture of the current state, it is difficult to identify risks or plan improvements. The diagram serves as the starting point for all subsequent tasks.

**What I rejected**
- Making corrections to the infrastructure at this stage, doing so would misrepresent the actual current state and undermine the purpose of the diagram.

---

### 2. Secure the Root Account

**What this task is solving**

The root account has unrestricted access to all AWS features and services. Leaving it unsecured or using it for daily operations poses a critical security risk that could lead to full account compromise.

**What I did**
- Enabled MFA on the root account as a mandatory first step.
- Stored root credentials in a dedicated, encrypted password manager, with access limited to only those who absolutely require it - in line with the principle of least privilege.
- Ensured access keys are only attached to IAM users, not the root user.

**Why I did it**
- MFA adds a second layer of protection, meaning stolen credentials alone are not enough to access the account.
- Restricting who can access the root credentials reduces the risk of accidental or malicious misuse.
- Avoiding root access keys eliminates the risk of long-lived, highly privileged credentials being exposed.

**What I rejected**
- Continuing to use the root account for daily operations, its unrestricted access makes any mistake or compromise catastrophic.
- Skipping MFA on the root account, this is a non-negotiable security baseline for any AWS account.

---

### 3. Create IAM Users and Groups

**What this task is solving**

Replacing the shared root account with individual IAM users and structured groups ensures that each person only has the access they need, making the environment more secure and easier to manage.

**What I did**
- Created individual IAM users for each employee, removing the shared root account access.
- Created IAM groups aligned to each team (Developers, Operations, Finance, Analysts) and assigned users to their respective groups.
- Attached permission policies to each group based on the access requirements defined in the project brief.

**Why I did it**
- Individual IAM users allow permissions to be scoped per person, based on their role and responsibilities.
- Managing permissions at the group level is scalable, changes to a group automatically apply to all its members.
- This enforces the principle of least privilege, ensuring each user can only access what they need.

**What I rejected**
- Continuing to use the root account for daily operations. The root account has unrestricted access to everything and should not be used for routine tasks.
- Assigning permissions directly to individual users. This becomes unmanageable at scale and makes auditing significantly harder.

---

### 4. Set Up Security Baseline

**What this task is solving**

Implementing standard security practices to ensure IAM users are not easily compromised and that the principle of least privilege is enforced.

**What I did**
- Created a JSON policy that forces all IAM users to enable MFA before they can perform any action in AWS, including actions on resources.
- The JSON policy is saved under the IaC folder, with a screenshot of the created policy in the console also included.
- Added a screenshot showing where a user enables MFA on their account. It should be done for every single user. 

**Why I did it**
- Without MFA, IAM users can easily be compromised. If credentials are stolen, an attacker gains full access to that user's permissions, potentially exposing the entire AWS environment.

**What I rejected**
- Leaving IAM users without MFA goes against security best practices and leaves user permissions exposed to abuse and misuse.

---

### 5. Implement User Group Permissions

**What this task is solving**

Assigning permissions at the group level rather than the user level makes access management more scalable and easier to maintain, while ensuring each user can only access what they need to fulfil their role.

**What I did**
- Added the correct permission policies to each IAM group (Developers, Operations, Finance, Data Analysts).
- Added a screenshot for each group as evidence of the correct permissions being applied.
- Ensured that IAM user access to billing is activated in the root account settings for billing-related permissions.

**Why I did it**
- Group-level permissions enforce the principle of least privilege across all users in a group, ensuring access is limited to what is needed to fulfil their duties.
- If the billing setting in the root account is disabled, even a correctly permissioned IAM user won't see the billing console.

**What I rejected**
- Not adding permissions to groups. This would result in users being unable to do anything, since AWS denies all actions by default.
- Applying permissions directly to individual users. This approach does not scale and makes access management significantly harder to maintain and audit.

---

### 6. Recreating the Solution as Infrastructure as Code

**What this task is solving**

Recreating the console-based solution as Infrastructure as Code simplifies it into a repeatable template, making it easy for any team member to implement the same solution without manually clicking through the AWS console. It can be adjusted and modified as needed, making it straightforward to apply at scale.

**What I did**
- Created four Terraform files to implement the full solution:
  - `main.tf` — backend and provider configuration, using S3 for remote state storage with S3 native locking.
  - `iam_groups.tf` — four IAM groups (Developers, Operations, Finance, Data Analysts) with their respective permission policies attached.
  - `iam_users.tf` — all ten IAM users created and assigned to their respective groups.
  - `iam_policies.tf` — custom MFA enforcement policy, attached to all groups so every user inherits it.
- Updated `.gitignore` to exclude Terraform-generated files that should not be committed, such as state files, provider binaries, and crash logs.

**Why I did it**
- IaC makes the solution repeatable and consistent. Anyone on the team can apply it without needing to follow manual steps through the console.
- It prevents solution drift, where manual changes over time cause the actual infrastructure to diverge from the original intent.
- It reduces the risk of human error that comes with manually configuring resources through the console.

**What I rejected**
- Relying solely on the console implementation — this requires every team member to manually replicate the solution, which is time-consuming, error-prone, and difficult to audit or version control.
- Using S3 with DynamoDB for state locking — S3 native locking achieves the same result with less infrastructure overhead, eliminating the need to maintain a separate DynamoDB table. This approach requires Terraform 1.10 or above and S3 bucket versioning to be enabled.