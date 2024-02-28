resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.rr-tf.key_name
  tenancy                     = "default"
  subnet_id                   = aws_subnet.external_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.aurora_sg.id]
  associate_public_ip_address = true
#   user_data                   = file("${path.module}/jenkins.sh")

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/tehila/.ssh/id_rsa")
    host        = self.public_ip
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "${path.module}/jenkins.sh"
    destination = "/tmp/jenkins.sh"  # Adjust destination path as needed
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jenkins.sh",
      "/tmp/jenkins.sh"
    ]
  }
  depends_on = [aws_instance.ec2]
}

  


  


