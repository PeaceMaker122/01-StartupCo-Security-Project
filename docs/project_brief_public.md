# Project Brief: StartupCo AWS Security Hardening

## Client Background

**StartupCo** is a fast-growing tech startup that recently launched their first product, a fitness tracking application.

They have been using AWS for three months, initially setting up infrastructure quickly to meet launch deadlines. Now that their product is live, they need to address their cloud security fundamentals.

The company has **10 employees** who all currently share the AWS root account credentials to access and manage cloud resources. This practice started during the rush to launch, but their CTO now recognises the security risks it poses.

---

## Current Security Issues

- Everyone uses the root account
- No separate permissions for different teams
- No MFA or password policies enforced
- AWS credentials shared via team chat

---

## Current Infrastructure

| Service | Purpose |
|---|---|
| EC2 | Application hosting |
| S3 | User data and application asset storage |
| RDS | User database |
| CloudWatch | Monitoring |

Environments: development and production.

---

## Team Structure & Access Requirements

| Team | Headcount | Access Needed |
|---|---|---|
| Developers | 4 | EC2, S3 |
| Operations | 2 | Full infrastructure access |
| Finance | 1 | Cost management |
| Data Analysts | 3 | Read-only access to data resources |

---

## Additional Security Direction

The company also wants to strengthen its security posture by incorporating AI-driven protection into the broader security layer of the environment. In practice, this means introducing intelligent monitoring and threat detection capabilities that can support the existing preventative controls.

> As an additional design decision, I interpreted this as an opportunity to introduce AWS GuardDuty as a detective layer for identifying suspicious activity, unusual behavior, and potential threats across the environment.

> Note: This was added as my decision and is an extension of the brief to strengthen the overall security design, rather than being part of the original stated requirements.

