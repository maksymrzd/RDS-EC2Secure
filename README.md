# Secure EC2 and RDS Infrastructure
This Terraform project creates a secure infrastructure on AWS that includes an EC2 instance and a PostgreSQL RDS instance. The instances are connected through security groups in a VPC.

<h2 align="left">Architecture</h2>
The architecture consists of the following components:<br>
<ul>
<li>VPC with two public and two private subnets</li>
<li>Internet Gateway for public subnet communication</li>
<li>EC2 instance in public subnet</li>
<li>PostgreSQL RDS instance in private subnets group</li>
<li>Security groups to control traffic between resources</li>

