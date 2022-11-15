# Terraform + Ansible Project for ACIT4640 - System/Network Provisioning

Provision an AWS EC2 instance to run a Flask app with another EC2 instance running MySQL.

Terraform creates the infrastructure including:

- VPC
- Subnets
- Internet Gateway
- Route Table
- Security Groups
- EC2 Instances

Ansible provision 2 EC2 instances based on whether if it is for running the app, or running the database. This was implemented by giving the EC2 instances tags, then assign EC2 instances into different groups based on the tags in ansible.
