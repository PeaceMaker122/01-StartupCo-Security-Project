
Justification for Terraform resources used in this project. Each resource is justified with reference to the relevant task(s).

---

## iam_groups.tf

**The four group resources (`aws_iam_group`)**
> Justified by Task 3 — *"Created IAM groups aligned to each team (Developers, Operations, Finance, Analysts)"*

**Permissions managed at group level, not user level**
> Justified by Task 3 — *"Managing permissions at the group level is scalable — changes to a group automatically apply to all its members"* and Task 5 — *"Assigning permissions at the group level rather than the user level makes access management more scalable and easier to maintain"*

**Developers — EC2, S3, CloudWatch policies**
> Justified by Task 5 — *"Added the correct permission policies to each IAM group"*, with the specific access requirements coming from the project brief: *"EC2 management, S3 access for application files, CloudWatch log viewing"*

**Operations — EC2, CloudWatch, SSM, RDS policies**
> Justified by Task 5 and the project brief: *"Full EC2 and CloudWatch access, Systems Manager access, RDS management"*

**Finance — Billing + ReadOnlyAccess policies**
> Justified by Task 5 and the project brief: *"Cost Explorer, AWS Budgets, read-only resource access"*. The specific choice of the `Billing` managed policy was confirmed during our conversation: *"The Billing AWS managed policy covers both Cost Explorer and AWS Budgets."* The `ReadOnlyAccess` policy covers the read-only resource access requirement.

**Data Analysts — S3 read-only + RDS read-only policies**
> Justified by Task 5 and the project brief: *"Read-only S3 access, read-only database access"*

---

## iam_users.tf

**Individual user resources (`aws_iam_user`)**
> Justified by Task 3 — *"Created individual IAM users for each employee, removing the shared root account access"*

**User counts per team (4 developers, 2 operations, 1 finance, 3 analysts)**
> Justified directly by the project brief team structure table

**No permissions attached directly to users**
> Justified by Task 3 — *"Assigning permissions directly to individual users — this becomes unmanageable at scale and makes auditing significantly harder"* (listed under What I rejected)

**Group membership resources assigning users to groups**
> Justified by Task 3 — *"Assigned users to their respective groups"* and Task 5 — *"ensuring each user can only access what they need to fulfil their role"*

---

## iam_policies.tf

**The MFA enforcement policy (`aws_iam_policy`)**
> Justified by Task 4 — *"Created a JSON policy that forces all IAM users to enable MFA before they can perform any action in AWS, including actions on resources"*

**`AllowMFASelfManagement` statement**
> Justified by Task 4 — *"Added a screenshot showing where a user enables MFA on their account. It should be done for every single user."* Without this statement, users would be locked out of the console before they could even set up their MFA device.

**`DenyAllWithoutMFA` statement**
> Justified by Task 4 — *"Without MFA, IAM users can easily be compromised. If credentials are stolen, an attacker gains full access to that user's permissions, potentially exposing the entire AWS environment"*

**MFA policy attached to all four groups**
> Justified by Task 4 — the policy must cover every user, and since all users belong to a group, attaching it at the group level is consistent with Task 3's decision to manage everything at the group level rather than the user level. Also reinforced by Task 5 — *"Group-level permissions enforce the principle of least privilege across all users in a group"*