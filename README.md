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
8. An EC2 instance with the resources above associated

## Use Ansible Playbook to automate EC2 instance configuration

Ansible Playbook is used to automate configuration and installation of the following within the provisioned EC2 instance:

1. Git
2. Docker
3. Jenkins
4. Microk8s

The lines starting from `provisioner "remote-exec"{...` in `main.tf` shows the associated code for incorporating Ansible Playbook within Terraform. See `main.yaml` for the Ansible Playbook file that is used for this task.

The `main.yaml` playbook breaks tasks into several roles, which are contained within the `roles` directory.

#### Configure Jenkins - Plugins

The following Jenkins plugins are used:

1. Git
2. GitHub
3. Docker
4. Docker Pipeline
5. Pipeline