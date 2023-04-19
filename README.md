# Secure EC2 and RDS Infrastructure
This Terraform project creates a secure infrastructure on AWS that includes an EC2 instance and a PostgreSQL RDS instance in one click. The instances are connected through security groups in a VPC.<br>
I created this infrastructure using modules that I wrote myself according to the best practice. Also I tried to keep the folder hierarchy as it should be.<br>

<h2 align="left">Website</h2>
I have a simple web page with two input fields in html and one simple php script that connects to the database.<br>
When user inserts their data and clicks "Send" button, this data is being sent to the database in private subnet.<br>
<br>

![image](https://user-images.githubusercontent.com/114437342/233077896-d6a70872-96c4-42ae-a9cd-230fc501f3b4.png)

<br>
Also, after sending the data, the next page shows all the rows from database. I did it to ensure that everything that is sent to a db is stored there.<br>
<br>

![image](https://user-images.githubusercontent.com/114437342/233077982-28154d67-1ec0-42a6-a88b-5aa57679048b.png)

<br>

<h2 align="left">Architecture</h2>
The architecture consists of the following components:<br>
<br>
<ul>
<li>VPC with two public and two private subnets</li>
<li>Internet Gateway for public subnet communication</li>
<li>EC2 instance in public subnet</li>
<li>PostgreSQL RDS instance in private subnets group</li>
<li>Security groups to control traffic between resources</li>
<br>
