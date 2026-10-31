# what terraform prints after apply (IPs, URLs, SSH commands)

output "amis_used" {
  value = { for k, ami in data.aws_ami.rhel : k => "${ami.name} (${ami.id})" }
}

output "instance_ids" {
  value = { for k, vm in aws_instance.web : k => vm.id }
}

output "public_ips" {
  value = { for k, vm in aws_instance.web : k => vm.public_ip }
}

output "private_ips" {
  value = { for k, vm in aws_instance.web : k => vm.private_ip }
}

output "web_urls" {
  value = { for k, vm in aws_instance.web : k => "http://${vm.public_ip}" }
}

output "ssh_commands" {
  value = { for k, vm in aws_instance.web : k => "ssh -i ${trimsuffix(var.ssh_public_key_path, ".pub")} ec2-user@${vm.public_ip}" }
}

output "ssh_allowed_from" {
  value = local.ssh_cidr
}
