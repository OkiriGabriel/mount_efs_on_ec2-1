# mount_efs_on_ec2-1
Task Description:

Create Security group which allow the port 80.

Launch EC2 instance.

In this Ec2 instance use the existing key or provided key and security group which we have created in step 1.

Launch one Volume using the EFS service and attach it in your vpc, then mount that volume into /var/www/html

Developer have uploaded the code into github repo also the repo has some images.

Copy the github repo code into /var/www/html

Create S3 bucket, and copy/deploy the images from github repo into the s3 bucket and change the permission to public readable.

Create a Cloudfront using s3 bucket(which contains images) and use the Cloudfront URL to update in code in /var/www/html