locals {
  num_master   = 1
  master_nodes = slice(aws_instance.app_server, 0, local.num_master)
  worker_nodes = slice(aws_instance.app_server, local.num_master, length(aws_instance.app_server))
}

resource "local_file" "ansible_hosts" {
  count = 2
  content = templatefile("${path.root}/ansible/ansible_hosts.tpl", {
    fqdns = {
      master = [for s in local.master_nodes : s.public_dns],
      worker = [for s in local.worker_nodes : s.public_dns],
    }
  })

  filename        = ["${path.root}/ansible/hosts.yml", "${path.root}/ansible/k3s-ansible/inventory/cluster/hosts.yml"][count.index]
  file_permission = 644

  depends_on = [aws_instance.app_server]
}

resource "local_file" "os_hosts" {
  content = templatefile("${path.root}/ansible/os_hosts.tpl", {
    hosts = [for s in aws_instance.app_server : {
      ip   = s.private_ip
      name = s.tags.HostName
    }]
  })
  filename = "${path.root}/ansible/os_hosts"

  file_permission = 544

  depends_on = [aws_instance.app_server]
}
