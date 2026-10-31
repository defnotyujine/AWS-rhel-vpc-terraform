# every setting I can change, with its default

variable "region" {
  description = "AWS region to deploy into (Singapore)"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Prefix used for every resource name"
  type        = string
  default     = "tf-lab"
}

variable "owner" {
  description = "Owner tag value"
  type        = string
  default     = "vvolf"
}

variable "vpc_cidr" {
  description = "CIDR block for the whole VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet (routed to the internet gateway)"
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet (no internet route)"
  type        = string
  default     = "10.20.2.0/24"
}

# one server per line, name = RHEL release
# pinned the minor release because "most recent" picked 9.6 over 9.8 (Red Hat still refreshes older ones)
variable "rhel_versions" {
  description = "RHEL release to deploy for each instance"
  type        = map(string)
  default = {
    rhel8  = "8.10"
    rhel9  = "9.8"
    rhel10 = "10.2"
  }
}

variable "instance_type" {
  description = "EC2 instance type (t3.small has 2 GiB RAM, enough for dnf on first boot)"
  type        = string
  default     = "t3.small"
}

variable "ssh_public_key_path" {
  description = "Path to the local SSH public key uploaded as the EC2 key pair"
  type        = string
  default     = "~/.ssh/tf-lab.pub"
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH in. Leave null to auto-detect your current public IP."
  type        = string
  default     = null
}

variable "cpu_alarm_threshold" {
  description = "CPU % that triggers the CloudWatch alarm"
  type        = number
  default     = 50
}
