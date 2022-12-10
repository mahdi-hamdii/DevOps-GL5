## Initializing the control-plane node
At this point, we have 3 nodes with docker, `kubeadm`, `kubelet`, and `kubectl` installed. Now we must initialize the Kubernetes master, which will manage the whole cluster and the pods running within the cluster `kubeadm init` by specifiy the address of the master node and the ipv4 address pool of the pods 

```bash
justk8s@justk8s-master:~$ sudo kubeadm init --apiserver-advertise-address=192.168.1.18 --pod-network-cidr=10.1.0.0/16
```
You should wait a few minutes until the initialization is completed. The first initialization will take a lot of time if your connexion speed is slow (pull the images of the cluster components)

#### Configuring kubectl 
As known, the `kubectl` is a command line tool for performing actions on your cluster. So we must to configure `kubectl`. Run the following command from your master node:
``` bash
justk8s@justk8s-master:~$ mkdir -p $HOME/.kube
justk8s@justk8s-master:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
justk8s@justk8s-master:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
#### Installing Calico CNI 
Calico provides network and network security solutions for containers. Calico is best known for its performance, flexibility and power. Use-cases: Calico can be used within a lot of Kubernetes platforms (kops, Kubespray, docker enterprise, etc.) to block or allow traffic between pods, namespaces

##### 1- Install Tigera Calico operator
``` bash 
justk8s@justk8s-master:~$ kubectl create -f "https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml"
```
The Tigera Operator is a Kubernetes operator which manages the lifecycle of a Calico or Calico Enterprise installation on Kubernetes. Its goal is to make installation, upgrades, and ongoing lifecycle management of Calico and Calico Enterprise as simple and reliable as possible.

##### 2- Download the custom-resources.yaml manifest and change it 
The Calico has a default pod's CIDR value. But in our example, we set the  `--pod-netwokr-cidr=10.1.0.0/16`. So we must change the value of pod network CIDR in `custom-resources.yaml`

``` bash 
justk8s@justk8s-master:~$ wget  "https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml"
```
Now we edit this file before create the Calico pods

``` yaml
# This section includes base Calico installation configuration.
# For more information, see: https://projectcalico.docs.tigera.io/v3.23/reference/installation/api#operator.tigera.io/v1.Installation
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    # Note: The ipPools section cannot be modified post-install.
    ipPools:
    - blockSize: 26
      cidr: 10.1.0.0/16 #change this value with yours
      encapsulation: VXLANCrossSubnet
      natOutgoing: Enabled
      nodeSelector: all()

---

# This section configures the Calico API server.
# For more information, see: https://projectcalico.docs.tigera.io/v3.23/reference/installation/api#operator.tigera.io/v1.APIServer
apiVersion: operator.tigera.io/v1
kind: APIServer 
metadata: 
  name: default 
spec: {}
```
After Editing the `custom-resources.yaml` file. Run the following command:
``` bash
justk8s@justk8s-master:~$ kubectl create -f "custom-resources.yaml" 
```
Before you can use the cluster, you must wait for the pods required by Calico to be downloaded. You must wait until you find all the pods running and ready! 
``` bash
justk8s@justk8s-master:~$ kubectl get pods --all-namespaces
NAMESPACE          NAME                                       READY   STATUS    RESTARTS       AGE
calico-apiserver   calico-apiserver-5989576d6d-5nw7n          1/1     Running   1 (4min ago)    4min
calico-apiserver   calico-apiserver-5989576d6d-h677h          1/1     Running   1 (4min ago)    4min
calico-system      calico-kube-controllers-69cfd64db4-9hnh5   1/1     Running   1 (4min ago)    4min
calico-system      calico-node-lshdl                          1/1     Running   1 (4min ago)    4min
calico-system      calico-typha-76dd7c96d7-88826              1/1     Running   1 (4min ago)    4min
kube-system        coredns-64897985d-jkpwh                    1/1     Running   1 (4min ago)    4min
kube-system        coredns-64897985d-zk9wx                    1/1     Running   1 (4min ago)    4min
kube-system        etcd-master                                1/1     Running   1 (4min ago)    4min
kube-system        kube-apiserver-master                      1/1     Running   1 (4min ago)    4min
kube-system        kube-controller-manager-master             1/1     Running   1 (4min ago)    4min
kube-system        kube-proxy-4nf4q                           1/1     Running   1 (4min ago)    4min
kube-system        kube-scheduler-master                      1/1     Running   1 (4min ago)    4min
tigera-operator    tigera-operator-7d8c9d4f67-j5b2g           1/1     Running   2 (103s ago)    4min
```

## Join the worker nodes
Now our cluster is ready to work! let's join the worker nodes to this cluster by getting the token from the master node 
``` bash
justk8s@justk8s-master:~$ sudo kubeadm token create --print-join-command
kubeadm join 192.168.1.18:6443 --token g4mgtb.e8zgs1c0kpkaj9wt --discovery-token-ca-cert-hash sha256:047628de2a0a43127b7c4774093203631d315451874efc6b63421a4da9bee2ec
```
Now let's move to the worker node and run the following command given by `kubeadm token create`

``` bash 
justk8s@justk8s-worker1:~$ sudo kubeadm join 192.168.1.18:6443 --token g4mgtb.e8zgs1c0kpkaj9wt 
\--discovery-token-ca-cert-hash sha256:047628de2a0a43127b7c4774093203631d315451874efc6b63421a4da9bee2ec
``` 
The output must be similar to the following 
``` bash
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
W0623 12:45:07.940655   23651 utils.go:69] The recommended value for "resolvConf" in "KubeletConfiguration" is: /run/systemd/resolve/resolv.conf; the provided value is: /run/systemd/resolve/resolv.conf
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

```
Now let's Check the cluster by running `kubectl get nodes` command on the master node.

``` bash
justk8s@justk8s-master:~$ kubectl get nodes

NAME              STATUS     ROLES                  AGE    VERSION
justk8s-master    Ready      control-plane,master   40m5s  v1.23.1
justk8s-worker1   Ready      <none>                 3m7s   v1.23.1
justk8s-worker2   Ready      <none>                 2m3s   v1.23.1
