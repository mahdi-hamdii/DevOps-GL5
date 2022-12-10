# What is Kubeadm
> kubeadm performs the actions necessary to get a minimum viable cluster up and running. 
>By design, it cares only about bootstrapping, not about provisioning machines.
<img src="https://d33wubrfki0l68.cloudfront.net/e4a8ddb49f07de8b2c2dbbfc7c9bedcfe0816701/600b1/images/kubeadm-stacked-color.png" width="100" height="100" />

## provisionnig infrastructure
> We will use Terraform to provision a Master node and n worker nodes:
| Modules  | Roles | 
| ------------- | ------------- |
| Master | Create the master node for the K8s cluster and assign it a public ip |
| Workers  | creates n worker nodes |
| SG | Network security group rules | 
| VNET | creates clusters Virtual Network and subnets |
