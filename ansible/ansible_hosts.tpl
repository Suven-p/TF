ec2instances:
  hosts:
%{ for fqdn in fqdns ~}
    ${fqdn}
%{ endfor ~}
