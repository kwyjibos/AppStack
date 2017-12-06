
## AppStack ##

This repo runs a stack of docker containers using docker-compose with mongodb, nginx, redis and php with phalcon.

### Requirements: ###
Either one of the following setups;

 - Vagrant and VirtualBox
 - Clean install of Ubuntu 16.04

### Guide to usage ###
 Clone the repo to your local machine.
 
 **Vagrant**
Run the vagrant up command in the main directory
 
     $ vagrant up
  
You should now have a dev box running whatever code was in the workspace directory on port 8080
http://localhost:8080

Note: The working directory will be the default vagrant one /vagrant

**Direct on Ubuntu**
If you already have docker installed, then install the docker compose script using pip, or from the [docker repo](https://docs.docker.com/compose/install/#install-compose) 

You can now start the stack with **docker-compose up** , other commands docs are [here](https://docs.docker.com/compose/gettingstarted/)

 
### Terraform Deploy ###
 The config provided deploys an auto-scaling group, fronted by an elastic loadbalancer and accompanying security groups.

By default it launches into the default vpc for your environment, this is not reccomended for production and it would be expected to have a full vpc setup with private subnets and external services.

This requires the terraform  cli tool ([here](https://www.terraform.io/intro/getting-started/install.html)) and an aws account with credentials to the required aws services.

Initiate the terraform setup;

    $terraform init
Run the plan ;

    $terraform plan
Apply the changes;

    $terraform deploy

The output of **terraform show**, should now show your environment including the external dns name of your new load balancer.
 
### Notes ###

This is a very simplified stack missing a code deployment pipeline, a systemd service, clustered redis, enviroment variables, terraform state storage and SSL setup.

Elastic Container Service would be a much better solution then running the same stack in both dev and prod, this is just an experimental deploy.

