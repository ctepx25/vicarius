## Simple flask app displays all running pods in the "kube-system" namespace.

###  Infrastructure provision and code deploy:

#### 1. Create aws infrastructure (vpc & eks cluster):
```sh
cd terraform-infra
terraform init
terraform apply
```
#### 2. Create flask app docker image (this will return the image ECR url):
```sh
cd terraform-docker-image
terraform init
terraform apply
```
#### 3. Update kubeconfig:
```sh
aws eks --region us-east-1 update-kubeconfig --name <cluster name>
```
#### 4. Deploy flask-app.
```
cd terraform-helm
terraform init
terraform apply
```
This will return output with DNS record for ALB:

```sh
Outputs:

`Service = "a4ee0837dd64a4a45a1fda839fd8c0c0-4cd991cc64d4abfb.elb.us-east-1.amazonaws.com"`
```

Flask app example output:
```
1. aws-load-balancer-controller-6c64cfc959-jc9ff
2. aws-node-9rlj5
3. coredns-54d6f577c6-l7m95
4. coredns-54d6f577c6-m89jf
5. ebs-csi-controller-55875f8945-tspj4
6. ebs-csi-controller-55875f8945-txz77
7. ebs-csi-node-cs7r2
8. kube-proxy-j4hrw
```
