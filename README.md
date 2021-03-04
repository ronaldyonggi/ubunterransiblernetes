# Ubunterransiblernetes

A CI/CD pipeline project utilizing Terraform, Jenkins, Ansible Playbook, Docker, Microk8s, and AWS EC2.
- Terraform automatically provision AWS EC2 instances
- Terraform executes Ansible Playbook scripts that configure and set up dockerized Jenkins within the created instances.


<p align="center">
<img
    alt="Pipeline"
    src="https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/mario.jpg"
    width="300"
/>
<h2>
"No, not *this* pipeline. I'm talking about DevOps pipeline..."
</h2>
</p>

## Deployment Architecture

## Install Terraform and Ansible in Local Machine

Local machine runs on Lubuntu OS.

1. [Terraform Installation in Ubuntu](https://www.terraform.io/docs/cli/install/apt.html#repository-configuration)
2. [Ansible Installation in Ubuntu](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)

## Use Terraform to provision AWS infrastructure 

The following components are created using Terraform. See `main.tf` file.

1. VPC
2. Internet gateway
3. Route table
4. Subnet
5. Route table association
6. Security group
7. Network interface
8. An EC2 instance with the resources above associated, using Ubuntu 20.04

## Use Ansible Playbook to automate EC2 instance configuration

Ansible Playbook is used to automate configuration and installation of the following within the provisioned EC2 instance:

1. Git
2. Stress
3. Docker
4. Jenkins
5. Microk8s

The lines starting from:
```
provisioner "remote-exec"{...`
```
 
 in `main.tf` shows the associated code for incorporating Ansible Playbook within Terraform. See `main.yaml` for the Ansible Playbook file that is used for this task.


The `main.yaml` playbook tasks are broken into several roles that are contained within the `roles` directory.

#### Configure Jenkins - Plugins

The following Jenkins plugins are used:

1. [Git](https://plugins.jenkins.io/git/)
2. [GitHub](https://plugins.jenkins.io/git/)
3. [Docker](https://plugins.jenkins.io/docker-plugin/)
4. [Docker Pipeline](https://plugins.jenkins.io/docker-workflow/)
5. [Pipeline](https://plugins.jenkins.io/workflow-aggregator/)
## Jenkins Pipeline Job Configuration

Choose the Pipeline job.

![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/pipeline.jpg)

On `Build Triggers` settings, make sure to check `GitHub hook trigger for GITScm polling`.

![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/gitpoll.jpg)

On `Pipeline` configuration,

1. On `definition`, choose `Pipeline script from SCM`
2. Select `Git` for SCM and provide the repository URL that contains the `Jenkinsfile`
3. Provide credentials. See the next section below on adding credentials.
4. Set branch specifier to `*/main`

![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/fromSCM.jpg)

## Jenkins - Dockerhub Credentials

1. Create a new repository in DockerHub
2. Go to Jenkins Configuration -> Manage Credentials -> `(global)`

![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/global.jpg)

3. Set up credential and save it.

![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/cred.jpg)


## Incorporate Jenkins with GitHub
[Reference](https://www.cprime.com/resources/blog/how-to-integrate-jenkins-github/)

Go to the GitHub project that will be used in the pipeline. Go to Settings -> Webhooks -> Add webhook.

![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/webhook.jpg)


Set the Payload URL to be the Jenkins URL with `/github-webhook/`added at the end. Then change content type to `application/json`. 

![](https://github.com/ronaldyonggi/2020_03_DO_Boston_casestudy_part_1/blob/main/screenshots/webhook2.jpg)

## Jenkinsfile Repository

[Here](https://github.com/ronaldyonggi/flaskapp) is the repository containing the Jenkinsfile. This repository also contains:

1. The Flask app required for the project
2. `Dockerfile` for building the image and pushing to Docker Hub
3. `kubernetes.yaml` containing specifications for Kubernetes deployment and service

