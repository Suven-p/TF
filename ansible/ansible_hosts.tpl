k3s_cluster:
  children:
    master:
      hosts:
%{ for fqdn in fqdns.master ~}
        ${fqdn}
%{ endfor ~}
    worker:
      hosts:
%{ for fqdn in fqdns.worker ~}
        ${fqdn}
%{ endfor ~}
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: "~/.ssh/TerraformTestKey2.pem"
