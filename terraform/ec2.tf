resource "aws_instance" "build_server" {
  ami                    = "ami-00f34bf9aeacdf007" # Amazon Linux
  instance_type          = "t3.micro"
  subnet_id                   = aws_subnet.subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.generated_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "${var.project_name}-${var.environment}-build_server"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
      timeout     = "5m"
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install -y epel-release",
      "sudo yum install -y python3 python3-pip",
      "sudo yum install -y ansible",
      # Install kubectl and aws-iam-authenticator
      "sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl",
      "sudo chmod +x ./kubectl",
      "sudo mv ./kubectl /usr/local/bin",
      "sudo curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator",
      "sudo chmod +x ./aws-iam-authenticator",
      "sudo mv ./aws-iam-authenticator /usr/local/bin"
    ]
  }
}

resource "local_file" "hosts_file" {
  filename = "/Users/shravanchandraparikipandla/Documents/repo/adcash-test/exercise/hosts.txt"
  content  = <<-EOT
    [dkr-prom]
    localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3.9
  EOT

  depends_on = [aws_instance.build_server]
}


resource "null_resource" "copy_files" {
  depends_on = [local_file.hosts_file]

  provisioner "file" {
    source      = "/Users/shravanchandraparikipandla/Documents/repo/adcash-test/exercise/ansible/ansible.cfg"
    destination = "/tmp/ansible.cfg"

    connection {
      type        = "ssh"
      user        = var.user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = aws_instance.build_server.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/ansible.cfg /etc/ansible/ansible.cfg",
      "sudo chmod 644 /etc/ansible/ansible.cfg",
      "sudo chmod 755 /etc/ansible",
      "sudo chown -R ${var.user}:${var.user} /etc/ansible"
    ]

    connection {
      type        = "ssh"
      user        = var.user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = aws_instance.build_server.public_ip
    }
  }

  provisioner "file" {
    source      = "/Users/shravanchandraparikipandla/Documents/repo/adcash-test/exercise/hosts.txt"
    destination = "/tmp/hosts.txt"

    connection {
      type        = "ssh"
      user        = var.user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = aws_instance.build_server.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/hosts.txt /etc/ansible/hosts",
      "sudo chmod 644 /etc/ansible/hosts"
    ]

    connection {
      type        = "ssh"
      user        = var.user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = aws_instance.build_server.public_ip
    }
  }

  provisioner "file" {
    source      = "/Users/shravanchandraparikipandla/Documents/repo/adcash-test/exercise/ansible"
    destination = "/tmp/ansible"

    connection {
      type        = "ssh"
      user        = var.user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = aws_instance.build_server.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/ansible/* /etc/ansible/roles"
    ]

    connection {
      type        = "ssh"
      user        = var.user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = aws_instance.build_server.public_ip
    }
  }
}
