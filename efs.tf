# Creating EFS file system
resource "aws_efs_file_system" "efs" {
  creation_token = "my-efs"

  tags = {
    Name = "MyProduct"
  }
}

resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_instance.web.subnet_id
  security_groups = [aws_security_group.ec2_security_group.id]

}

resource "null_resource" "configure_nfs" {
  depends_on = [aws_efs_mount_target.mount]
   connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.my_key.private_key_pem
    host     = aws_instance.web.public_ip
   }
  provisioner "remote-exec" {
    # inline = [
    #   "sudo yum install httpd php git -y -q ",
    #   "sudo systemctl start httpd",
    #   "sudo systemctl enable httpd",
    #   # "sudo yum -y install nfs-utils",     # Amazon ami has pre installed nfs utils
    #   "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  /var/www/html",
    #   "echo ${aws_efs_file_system.efs.dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab " ,
    #   "sudo chmod go+rw /var/www/html",
    #   "sudo git clone https://github.com/Apeksh742/EC2_instance_with_terraform.git /var/www/html",
    # ]

        inline = [
      "sudo yum install amazon-efs-utils httpd php git -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",
      "sudo setenforce 0",
      "sudo yum install nfs-utils -y",
      "sudo mount -t efs ${aws_efs_file_system.efs.dns_name}:/ /var/www/html",
      "sudo echo ${aws_efs_file_system.efs.dns_name}:/ /var/www/html efs defaults_netdev 0 0 >> sudo /etc/fstab",
      "sudo rm -f /var/www/html/",
      "sudo git clone https://github.com/Apeksh742/EC2_instance_with_terraform.git  /var/www/html/",

    ]
  }
}

# Creating New Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "new-acess-identity"
}