[master]
kubemaster01 ansible_host=${master_ip}

[workers]
%{ for ip in worker_ips ~}
kubenode${format("%02d", index(worker_ips, ip)+1)} ansible_host=${ip}
%{ endfor ~}

[k8s:children]
master
workers

[k8s:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=../terraform/k8s-lab
