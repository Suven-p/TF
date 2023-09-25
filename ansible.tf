locals {
  num_master   = 1
  master_nodes = slice(aws_instance.app_server, 0, local.num_master)
  worker_nodes = slice(aws_instance.app_server, local.num_master, length(aws_instance.app_server))
}

resource "local_file" "ansible" {
  content = templatefile("${path.root}/ansible/ansible_hosts.tpl", {
    fqdns = {
      master = [for s in local.master_nodes : s.public_dns],
      worker = [for s in local.worker_nodes : s.public_dns],
    }
  })

  filename        = "${path.root}/ansible/hosts.yml"
  file_permission = 644
}
