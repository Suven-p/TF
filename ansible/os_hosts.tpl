%{ for host in hosts ~}
${host.ip} ${host.name}
%{ endfor ~}
