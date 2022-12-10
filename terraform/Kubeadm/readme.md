# What is Kubeadm
> kubeadm performs the actions necessary to get a minimum viable cluster up and running. 
>By design, it cares only about bootstrapping, not about provisioning machines.
<img src="https://d33wubrfki0l68.cloudfront.net/e4a8ddb49f07de8b2c2dbbfc7c9bedcfe0816701/600b1/images/kubeadm-stacked-color.png" width="100" height="100" />

## provisionnig infrastructure
> We will use Terraform to provision a Master node and n worker nodes:
| Modules  | Roles | Variables | outputs |
| ------------- | ------------- | ------------- | ------------- |
| Master | Create the master node for the K8s cluster and assign it a public ip | subnet_id,resource_group_location, resource_group_name, master_size | master_public_ip |
| Workers  | creates n worker nodes | workers, subnet_id,resource_group_location, resource_group_name, worker_size, worker-admin-username, worker-nic-names | public_ips |
| SG | Network security group rules | security_rule, resource_group_location, resource_group_name, security_group_name, subnet_id | |
| VNET | creates clusters Virtual Network and subnets | subnet_name, vnet_name, resource_group_location, resource_group_name | subnet_id |
