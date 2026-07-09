
# Current infrastructure decisions:

No app or web instances mentioned separately; only general EC2 instances running their app. I decided to implement 2 App servers accessed directly by the public via IP addresses. No ALB mentioned. 

Only one RDS database is mentioned for user info. I'm assuming it's in a single AZ with no High-Availability or read replicas.

Several development and production environments are mentioned, but I assume this is just an operational/logical discipline separation, not an infrastructure separation.

No specific Security Groups mentioned. Default security groups will be used.



# Tasks:

1. Create the current Architecture:

- I created the current infrastructure in a diagram to have a visual idea of what it looks like, to spot all the flaws and risks present.

- I prevented myself from making any corrections on the current infrastructure to emphasize the current bad situation and enable myself to fix it later.


2. Secure the Root Account

- I enabled MFA on the root account as a mandatory step.

- I used a dedicated, encrypted password manager to store the root account credentials securely, and made sure that only the absolutely necessary individuals have access to these credentials to emphasize the principle of least privilege.

- Access keys are only attached to IAM users instead of the root user to improve security.

- The root account has unrestricted access to all the features of your AWS account, and leaving it unsecured can compromise your entire account.


3. Create IAM Users and Groups

**What I did:**
- Created individual IAM users for each employee, removing shared root account access.
- Created IAM groups aligned to each team (Developers, Operations, Finance, Analysts) and assigned users to their respective groups.
- Attached permissions policies to each group based on the access requirements defined in the project brief.

**Why I did it:**
- Individual IAM users enable the separation of permissions per person, scoped to their responsibilities and team.
- Assigning permissions at the group level rather than the user level makes access management scalable - changes to a group's permissions automatically apply to all members.
- This enforces the principle of least privilege, ensuring each user can only access what they need to do their job.

**What I rejected:**
- Continuing to use the root account for daily operations - the root account has unrestricted access to everything in the AWS account and should not be used for routine tasks.
- Assigning permissions directly to individual users - this becomes unmanageable at scale and makes auditing access significantly harder.


4. Set Up Security Baseline

**What is this task actually solving:**
Standard security-based practices to ensure users are not compromised and the principle of least privilege is implemented.

**What I did:**
I created a policy that forces all IAM users to enable MFA on their account before they can take any action in AWS, including any actions on resources. 

I then outline the steps on how a user enables MFA on their account.

**Why I did it:**
If this is not done, then IAM users can be easily compromised, and their permissions can be abused, leading to the AWS environment security being compromised.

**What I rejected:**
Leaving IAM users without MFA goes against security-based practices and compromises the users' permissions, which can be abused and misused.