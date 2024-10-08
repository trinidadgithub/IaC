# Kafka Streams Data Processing Pipeline

This project demonstrates a real-time data processing pipeline using **Kafka Streams**. The application is designed to run both locally (using Docker Compose) and on AWS (deployed via Terraform).

## Project Structure

```bash
kafka-streams-pipeline/
├── Dockerfile
├── requirements.txt
├── README.md
├── LICENSE
├── CHANGELOG.md
├── terraform/
│   ├── main.tf          # Main Terraform configuration
│   ├── variables.tf     # Variables for the project
│   ├── outputs.tf       # Outputs configuration
│   ├── provider.tf      # Docker and Kafka providers
│   ├── terraform.tfvars # Required terraform variables
│   ├── docker_infrastructure/ # Docker module
│       ├── build_image.tf     # build the docker images
│       ├── kafka.tf           # Kafka container setup
│       ├── zookeeper.tf       # Zookeeper container setup
│       ├── main.tf            # Main docker infra config
│       ├── build_image.tf     # Docker image build setup
│       ├── kafka_topics.tf    # Kafka topics setup
│       ├── variables.tf       # Variables for the docker module
├── app/
│   ├── stream_processor.py.py
│   ├── __init__.py
└── .gitignore

```

### File Descriptions:
```bash
-Dockerfile: Builds the Docker image for the stream processing application.
-requirements.txt: Python dependencies for the Kafka Streams processor.
-README.md: Project overview, setup instructions, and usage details.
-LICENSE: Licensing information for the project.
-CHANGELOG.md: A changelog to track the project’s updates and changes.
-terraform/: Contains Terraform configuration files for deploying Kafka and other resources on AWS.
-docker_infrastructure:  Containes Terraform configuration files for running locally
-main.tf: Main Terraform configuration for AWS resources.
-variables.tf: Variable definitions for Terraform.
-outputs.tf: Outputs from the Terraform deployment.
-provider.tf: AWS provider setup for Terraform.
-terraform.tfvars:  Containers required variable definitions
-app/: Contains the Python Kafka Streams processing code.
-stream_processor.py.py: The core Kafka Streams application.
-__init__.py: Initializes the app Python module.
-docs/USAGE.md: Contains detailed usage and setup instructions (additional documentation).
-.gitignore: Git ignore file to exclude unnecessary files like virtual environments or build artifacts.
```
### Setup

### Local Deployment with Docker Compose

1.  Clone the repository:
```bash
git clone https://github.com/your-username/kafka-streams-pipeline.git
cd kafka-streams-pipeline/terraform
```
2.  Start Kafka and Zookeeper locally:
```bash
terraform init
terraform validate
terraform plan
# When you're ready
terraform apply

Terraform will:
Build the Docker image from the Dockerfile in the app/ directory.
Deploy Kafka, Zookeeper, and the Stream Processor containers locally.
Create the Kafka Topics
```
3.  Check the Stream Processor Logs: Verify that the stream processor is consuming from 
```bash
docker logs $(docker ps -qf "name=stream_processor")
```
4.  TODO
```bash
Cloud implementation:  Build out terraform to deploy to AWS
Image hosting:  Build out terraform code to push image to a docker registry
Update create_tf_structure.sh or remove it from tracking
```
