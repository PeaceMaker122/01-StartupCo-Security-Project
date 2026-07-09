
How do I create a strong password policy? 


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

- The root account has unrestricted access to all the features of your AWS account, and leaving it unsecured can compromise your entire account.
