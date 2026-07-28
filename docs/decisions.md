# Decisions & Reasoning

---

## Assumptions: Current Infrastructure

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
- Using AWS Organizations with Service Control Policies (SCPs) at this stage. While Organizations is the recommended approach at scale - where each team or environment gets its own AWS account, and SCPs act as guardrails across all accounts - it is unnecessary overhead for a 10-person startup operating in a single account. The single-account model with IAM groups and least-privilege policies is the appropriate starting point here.

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
  - `main.tf`: backend and provider configuration, using S3 for remote state storage with S3 native locking.
  - `iam_groups.tf`: four IAM groups (Developers, Operations, Finance, Data Analysts) with their respective permission policies attached.
  - `iam_users.tf`: all ten IAM users created and assigned to their respective groups.
  - `iam_policies.tf`: custom MFA enforcement policy, attached to all groups so every user inherits it.
- Updated `.gitignore` to exclude Terraform-generated files that should not be committed, such as state files, provider binaries, and crash logs.

**Why I did it**
- IaC makes the solution repeatable and consistent. Anyone on the team can apply it without needing to follow manual steps through the console.
- It prevents solution drift, where manual changes over time cause the actual infrastructure to diverge from the original intent.
- It reduces the risk of human error that comes with manually configuring resources through the console.

**What I rejected**
- Relying solely on the console implementation, as this requires every team member to manually replicate the solution, which is time-consuming, error-prone, and difficult to audit or version control.
- Using S3 with DynamoDB for state locking, as S3 native locking achieves the same result with less infrastructure overhead, eliminating the need to maintain a separate DynamoDB table. This approach requires Terraform 1.10 or above and S3 bucket versioning to be enabled.

---

### 7. Enable AWS GuardDuty: AI Threat Detection Layer

**What this task is solving**

The preventative controls already in place (IAM, least-privilege permissions, and MFA enforcement) reduce the attack surface but cannot detect threats that emerge after access is granted. GuardDuty adds a detective layer by using machine learning to continuously analyse CloudTrail logs, VPC Flow Logs, and DNS logs for anomalous or malicious activity, catching threats that slip through or develop over time.

**What I did**
- Activated GuardDuty to continuously monitor and identify security threats across all AWS resources in the architecture.
- Added a screenshot of GuardDuty activated in the console as evidence.
- Implemented GuardDuty enablement in Terraform via a dedicated `guardduty.tf` file, consistent with the IaC approach taken throughout the project.

- Sidenote: GuardDuty specified in design but not deployed in this phase due to cost; Terraform config (`guardduty.tf`) reflects target-state architecture, console/import reflects actually-deployed subset.

**Why I did it**
- In an environment where AI-driven attacks are becoming more sophisticated, using ML-powered threat detection is no longer optional, it is a security baseline.
- GuardDuty complements the existing preventative controls by acting as a safety net. If credentials are compromised or an insider threat emerges, GuardDuty can detect the anomalous behaviour and reduce the blast radius of a breach.
- It requires no agents or additional infrastructure, it works passively in the background, making it low overhead and high value.

**What I rejected**
- Relying solely on preventative controls without any detective layer, as this leaves the architecture blind to threats that develop after access is granted, which is increasingly inadequate given the pace at which security threats are evolving.
- Ignoring AI and ML capabilities available natively in AWS, as failing to utilise these tools goes against modern security best practices and leaves a significant gap in the overall security posture.

---

### 8. Terraform Import Verification

**What this task is solving**

Ensuring that the Terraform configuration accurately reflects the IAM resources that were originally created in the AWS console. This closes the gap between a theoretically correct IaC design and a verified, production-safe representation of the actual AWS environment.

**What I did**
- Used Terraform import blocks to reconcile existing AWS IAM resources with the Terraform resource definitions.
- Worked through the import process one resource at a time and reviewed each Terraform plan diff before proceeding.
- Verified that the IAM groups, users, policies, and group-policy attachments matched the intended console configuration.
- Left GuardDuty as a future-ready configuration rather than enabling it in the live account because of the cost decision.

**Why I did it**
- A security-focused project cannot rely on assumptions alone; the Terraform code needed to be proven against the real AWS environment.
- Importing existing resources into state prevents drift and ensures Terraform manages the same objects that were created manually in the console.
- Reviewing each plan diff before applying it made the process safer and more explicit.

**What I rejected**
- Treating the Terraform configuration as correct just because it looked consistent in code.
- Using a bulk import or apply approach without reviewing the plan first, which would have reduced visibility and increased the chance of misconfiguration.
- Enabling GuardDuty in the live account at this stage, because the project scope was intentionally kept cost-conscious and the service was documented as a future enhancement rather than a current deployment.

---

### 9. Target-State Architecture

**What this task is solving**

Turning the “what exists today” view into a clear future architecture for StartupCo. This makes the gap between the current console-based setup and the security/availability target explicit, instead of leaving it as an abstract improvement idea.

**What I did**
- Drew the improved target-state architecture after completing the IaC work, rather than before.
- Expanded the simple current setup into a multi-AZ design with separate public and private subnets.
- Added an ALB in front of the web tier, private app servers in a non-public subnet, a NAT gateway for outbound access, and a multi-AZ RDS primary/standby pair.
- Added a decoupled multi-tier architecture with separate Web and Application tiers in different Auto Scaling Groups spanning two Availability Zones.
- Restricted all public ingress to the ALB in public subnets, while placing backend Web servers, app servers, and database instances in private subnets with outbound-only internet access via NAT Gateways.
- Included a private S3 gateway endpoint for secure internal S3 access, CloudWatch monitoring, and IAM/authorization controls.
- Designed layered Security Groups at every tier (ALB -> Web Tier -> App Tier -> Database) to strictly restrict inbound and outbound communication paths.
- Represented GuardDuty as a future-ready detection layer in the architecture, documented as intentionally not deployed in the live account for cost reasons.

**Why I did it**
- The target-state diagram should be created after the console/IaC work, once you understand the real limitations of the existing build.
- It allowed me to separate “what we actually built today” from “what the architecture should evolve into”.
- Multi-AZ deployment and tiered isolation reduce single points of failure and significantly improve security posture.
- Routing S3 traffic through a VPC Gateway Endpoint improves privacy and avoids unnecessary NAT Gateway data transfer costs.
- GuardDuty and CloudWatch integration bridges the gap between preventative controls (IAM/MFA) and detective capabilities, ensuring real-time visibility into anomalous activity.

**What I rejected**
- Treating the current single-AZ App + RDS view as if it were already the ideal design.
- Drawing a target-state diagram too early, before the actual build and Terraform reconciliation were complete.
- Enabling GuardDuty in the live account just to match the diagram; instead, I kept it as a documented future capability (`guardduty.tf`) and did not apply it due to cost constraints.

---

### 10. IAM Structure Diagram

**What this task is solving**

Making the current IAM design easier to understand at a glance by turning the group/user/policy relationships into a simple visual reference.

**What I did**
- Created an IAM structure diagram that shows each group, its users, and the permissions attached to that group.
- Included the custom `Force-MFA` policy as a shared enforcement layer across all groups.
- Kept the diagram aligned with the Terraform implementation so it represents the actual deployed state.

**Why I did it**
- A diagram helps stakeholders and reviewers quickly verify that the IAM model is role-based and least-privilege.
- It clarifies that permissions are attached at the group level, not directly to users, which is an important security and maintainability distinction.
- Keeping the diagram tied to Terraform means it supports the same infrastructure-as-code narrative used elsewhere in the project.

**What I rejected**
- Creating a separate IAM diagram that doesn’t match the actual Terraform resources. Visual documentation only adds value if it accurately reflects the deployed design.
- Treating the diagram as a replacement for the code. The diagram is a supplementary reference, not the source of truth.
