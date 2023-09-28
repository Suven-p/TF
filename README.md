1. Create a ssh key. Download key and add it to ssh agent
2. Update key name for instance in file ec2.tf
3. Run `terraform init`
4. Run `terraform plan` and `terraform apply`
5. Verify that hosts file under ansible/ec2.yml is correct
6. Run `ansible-playbook -i ansible/hosts.yml ansible/k3s.yml`
