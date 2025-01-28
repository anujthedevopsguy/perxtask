# perxtask

step 1: Have an AWS account and login as a admin user

step 2: Navigate to terraform folder and run **terraform plan** followed by **terraform apply --auto-approved**. This will create a EKS cluster along with a nodegroup having 2 worker nodes. also, it will take care of underlying network stack.

step 3: run **aws eks update-kubeconfig --name dev-perx-eks --region ap-south-1**. it will generate kubeconfig file and save to ~/.kube/config. check you are admin by running kubectl auth can-i "*" "*"

step 4: login to AWS console and navigate to EKS cluster -> look for add-ons tab. install Amazon EBS CSI Driver and Amazon EKS Pod Identity Agent add-ons.

step 5: run **kubectl apply manifest/secret_manifest.yaml**. this will create a secret object having mysql DB related information.

step 6: run following commands toc reate storage class and PVCs.
    
    kubectl apply manifest/storage_class.yaml
    kubectl apply manifest/pvcs.yaml. 

step 7: Update the terraform/values/mysql-values.yaml for desired configuration and run below commands
    
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install mysql -f terraform/values/mysql-values.yaml bitnami/mysql
This will install mysql cluster as one primary and one secondary (replica node)

## step 8: Run **kubectl apply -f service.yaml** . This is create service object for mysql write and read node. we can use write node service endpoint for write request and read node endpoint for read requests. 

step 9: update the manifest/app-deployment.yaml file as per need and run 
    
    kubectl apply -f manifest/app-deployment.yaml file.

step 10: run **kubectl apply -f manifest/hpa.yaml** . This will ensure that app scalability is managed by HPA. please look into hpa.yaml for minimum, desired and maximum count.

step 11: Run **kubectl apply -f network_policy.yaml** to setup a network policy which allow communication between backend app and database.

step 12: run **kubectl apply -f app-service.yaml** to expose app to the internet using loadbalancer service. we will configure SSL cert on ALB side to make sure that outside people are connecting to app through https.

ToDo:
    
    1.Mysql cluster vertical/horizontal scaling
    2.Runing mysql on TLS (should take less time)
    3.Load testing to see HPA in action
    4.prometheus operator installation and exposing grafana.

Architecture:

please find the image named as perx.jpg



Notes:

command to list latest verions of add-on


    aws eks describe-addon-versions --region ap-south-1 --addon-name eks-pod-identity-agent
