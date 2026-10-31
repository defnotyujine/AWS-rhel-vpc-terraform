# the EC2 servers themselves, this is where everything comes together

# the RHEL servers, one per line in rhel_versions
resource "aws_instance" "web" {
  for_each = var.rhel_versions

  ami                    = data.aws_ami.rhel[each.key].id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.this.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  # first-boot script, runs once through cloud-init (basically a kickstart %post)
  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    name   = "${local.name}-${each.key}"
    region = var.region
  })
  user_data_replace_on_change = true

  # encrypted gp3 disk, size comes from the AMI (10 GiB)
  root_block_device {
    volume_type = "gp3"
    encrypted   = true
  }

  # IMDSv2 only, blocks the old token-less metadata requests
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = { Name = "${local.name}-${each.key}" }
}
