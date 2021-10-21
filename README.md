# gcp-setup

This repo includes some terraform that creates infrastucture in google cloud that can host a kubernetes cluster and also a jenkins server. The jenkins server can then be used to configure kubernetes through ansible playbooks on the instances created. Below are a brief description of the resources created in the modules:

- Networking - vpc network, subnets, external address, firewall and a NAT gateway
- Application - 2 compute instances for controller and node
- Tools - 1 compute instance for the jenkins server

Also included in the repo is ansible playbooks that setup tools like docker, kubectl, kubeadm etc that are needed for kubernetes setup. These should be run from the Jenkins instance with the use of the Jenkinsfile attached.

# To run 

:warning: **Warning**: By default the Jenkins server can be accessed from anywhere so no personal information should be added to the server. The source range can be narrowed down to your own public IP through the console or by overwriting the variable in terraform [here](./modules/networking/variables.tf)

Currently terraform uses the local backend to store the state and gcp credentails are needed to be set as environment variables to run, this can be done by adding the json creds to the folder and running: 

```
source ./setupCreds.sh
```
Once this is done you can run   
```
terraform init
```
Now should be okay to run plan then apply
```
terraform plan -out tfplan
```
```
terraform apply tfplan
```

This will create the infrastructure needed for the kubernetes cluster and Jenkins :seedling:

# Jenkins setup

The Jenkins setup is currently manual :grimacing:  First we need to log into the Jenkins instance called grafter:

```
gcloud compute ssh grafter
```

[Install docker](https://docs.docker.com/engine/install/ubuntu/) and then run the docker container for the jenkins image 

```
docker run -p 8080:8080 -p 50000:50000 --restart=always -d -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

Admin token can be fetched from docker logs and used to sign in through public address:8080 created by terraform in the networking module, this can fetched either from the console or terraform outputs. 

# Ansible connection

Now for ansible to be able to configure the controller or any node we need access from the Jenkins server. This can be done by generating a ssh key on the grafter instance:
```
gcloud compute ssh grafter
```
Then

```
ssh-keygen -t rsa
```

This will produce a private and public key. We need to add the public key generated to the authorized_keys file in the other nodes. This can be done by:

```
gcloud compute ssh controller
```

And creating the authorized_keys file under the ~/.ssh directory with the public key from the grafter instance added. We should be able to ssh from grafter to the controller instance now without password.

# Jenkins Job setup

Now our Jenkins instance can connect to the controller, we just need to add the ansible plugin [Step2 here shows how](https://medium.com/appgambit/ansible-playbook-with-jenkins-pipeline-2846d4442a31)

After that we setup the Jenkins job that pulls down and Jenkinsfile then can run :grin: 

After run completed should have a running kubernetes cluster with a controller node 

