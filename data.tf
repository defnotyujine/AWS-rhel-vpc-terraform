# stuff I look up instead of create (my IP, AZs, RHEL images) and a few helper values

# grabs my public IP for the SSH rule (only used when ssh_allowed_cidr is empty)
# careful with the VPN, run terraform from the same connection I'll SSH from
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

data "aws_availability_zones" "available" {
  state = "available"
}

# latest pay-as-you-go RHEL image for each version in rhel_versions
# names look like RHEL-9.8.0_HVM-20260908-x86_64-0-Hourly2-GP3
data "aws_ami" "rhel" {
  for_each = var.rhel_versions

  most_recent = true

  # Red Hat's AWS account, so I only get official images
  owners = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-${each.value}.0_HVM-*-x86_64-*-Hourly2-GP3"]
  }
}

locals {
  name     = var.project_name
  az       = data.aws_availability_zones.available.names[0]
  ssh_cidr = coalesce(var.ssh_allowed_cidr, "${chomp(data.http.my_ip.response_body)}/32")
}
