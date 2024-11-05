# Project Overview

This repository contains a collection of infrastructure-as-code (IaC) projects and related tools for deploying and managing various services. Each directory represents a specific area of focus, leveraging technologies such as Docker, Terraform, Helm, and Kubernetes. Below is a breakdown of each component:

## Directory Structure

- **aws/**  
  Contains general work related to AWS features and services. This directory includes scripts, configurations, and IaC files for various AWS components.

- **azure/**
  Contains information regarding how to setup your Windows workstation to be running Azure CLI commands.

- **concourse-terraform-windows/**
  A study on deploying concourse as a docker container framework on Windows.  

- **concourse-terraform-unix/**
  A study on deploying concourse as a docker container framework on Windows.  

- **docker/**  
  Holds Docker-related work, primarily focused on containerizing AWS features and deploying containerized applications within the AWS ecosystem.

- **helm-terraform-js-app/**  
  Focused on deploying a JavaScript application using Terraform with Helm support. This directory demonstrates a complete infrastructure setup for Kubernetes deployments using Helm charts.

- **kafka-streams-pipeline/**  
  Provides an example pipeline using Kafka Streams, showing how to build and deploy data streaming applications using Kafka.

- **sli_app/**  
  An example deployment showcasing a Service Level Indicator (SLI) application. It integrates Terraform, Prometheus, Grafana, Docker, and cAdvisor to monitor and maintain service levels.

- **terraform-aws-eks/**  
  Contains work specific to deploying AWS EKS (Elastic Kubernetes Service) using Terraform. This directory provides scripts and configurations to automate the setup of a complete EKS cluster on AWS.

- **terraform-docker-iot/**

  Illustrates how to deploy an AWS IoT thing (python based) on Docker using Terraform

- **sre/**

  Practical information for becoming a successful Site Reliability Engineering professional

- **[DevOps](./docs/DevOps.md)/**

## Getting Started

To work with any of the directories, navigate to the respective folder and follow the individual instructions provided in their `README.md` files. General requirements for each component may include:

- **AWS CLI**: Ensure you have the AWS CLI configured for interaction with AWS services for projects related to AWS.
- **Azure CLI**:  For projects related to Azure.
- **Google Cloud Platform**: for projects related to GCP.
- **Terraform**: Install [Terraform](https://www.terraform.io/downloads.html) for infrastructure provisioning.
- **Docker**: Ensure Docker is installed and running for any Docker-related projects.
- **Helm**: Install [Helm](https://helm.sh/docs/intro/install/) for managing Kubernetes applications.
- **IDE**: An integrated development environment such as Visual Code, IntelliJ, or Pycharm.
- **Programming Languages**:  Python, C, Go, JavaScript, Java, .Net (core), and or Typescript, etc. for writing basic programs
- **Programming Frameworks**: Python: Django, Flask, Pytorc, Go: Gin, Echo, Beego; Javascript:  React, angular, Next.js, etc.
- **Oracle's Virtual Box**: Used to manage and deploy services to virtual machines.

Optional:

- Oracle's Virtual Box:  If you don't want to install any tools on your workstation
- Git Bash:  For quick linux like commands on a Windows machine
- Package Managers:  Like NPM for Javascript, etc.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Contributing

Feel free to submit issues, pull requests, or suggestions to improve the project. Contributions are welcome!

