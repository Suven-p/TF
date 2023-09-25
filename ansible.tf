resource "local_file" "ansible" {
  content = templatefile("${path.root}/ansible/ansible_hosts.tpl", {
    fqdns = [for s in aws_instance.app_server : s.public_dns]
  })

  filename        = "${path.root}/ansible/hosts.yml"
  file_permission = 644
}
