resource "aws_instance" "ec2_9_5" {
  ami = data.aws_ami.dyanamic-Ec2.id
  instance_type = var.aws_instance_type

  tags = {
    name = "Ec2-instance"
    WorkingHoursFlag = "True"
  }

}


