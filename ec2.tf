data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                   = local.ec2.name
  ami                    = data.aws_ami.amazon.image_id
  instance_type          = local.ec2.type
  key_name               = local.ec2.key_name
  monitoring             = local.ec2.monitoring
  vpc_security_group_ids = local.ec2.vpc_security_group_ids
  subnet_id              = local.ec2.subnet_id
  user_data              = local.ec2.user_data

  iam_instance_profile = aws_iam_instance_profile.ec2.name


  tags = merge(local.common_tags, { Name = local.ec2.name })

  depends_on = [
    module.sg,
    aws_iam_instance_profile.ec2
  ]
}

resource "aws_eip" "ec2" {
  instance = module.ec2.id
  vpc      = true

  depends_on = [
    module.ec2
  ]
}

resource "null_resource" "ec2" {
  triggers = {
    ec2_public_ip = aws_eip.ec2.public_ip
  }

  provisioner "local-exec" {
    command = "if [ -z \"$(ssh-keygen -F ${aws_eip.ec2.public_ip})\" ]; then  ssh-keyscan -H ${aws_eip.ec2.public_ip} >> ~/.ssh/known_hosts; fi"
  }
}