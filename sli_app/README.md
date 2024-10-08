# Service Level Indicator (SLI) Monitoring Example

This project demonstrates how to monitor and measure **Service Level Indicators (SLIs)** in a web application. It provides practical examples and insights into implementing SLIs to assess and improve the performance, reliability, and quality of services from the user's perspective.

## Introduction

**Service Level Indicators (SLIs)** are crucial metrics in Site Reliability Engineering (SRE) that quantify specific aspects of a service's behavior. They serve as the foundation for defining Service Level Objectives (SLOs) and Service Level Agreements (SLAs), enabling organizations to focus on what truly matters to their customers.

## Key Concepts

### Definition

An **SLI** is a quantitative measure of some aspect of a service's behavior. It captures a specific, observable aspect of a system’s performance, such as:

- **Latency**
- **Availability**
- **Throughput**
- **Error Rate**

### Importance

SLIs provide an objective way to assess whether a service is meeting user expectations and help guide operational priorities and improvements.

### Relation to SLOs and SLAs

- **SLIs**: The metrics measuring service performance (e.g., error rate).
- **SLOs**: The target or threshold for those metrics (e.g., error rate < 1%).
- **SLAs**: Formal agreements based on SLOs, specifying penalties for not meeting targets.

### Characteristics of Good SLIs

- **Representative**: Accurately reflects the user experience.
- **Measurable**: Can be captured and quantified reliably.
- **Actionable**: Leads to insights that can improve service reliability.

## Common Real-World Examples of SLIs

### Availability

Measures the uptime of a service, often expressed as a percentage (e.g., 99.9% availability over a month).

**Example**: Tracking the percentage of successful HTTP 200 responses against total requests in a web application.

### Latency

The time taken for a service to respond to a request, typically measured in milliseconds (ms).

**Example**: Monitoring the 95th percentile latency of video start times in a streaming service to ensure it remains under 2 seconds.

### Error Rate

The ratio of failed requests to the total number of requests.

**Example**: An e-commerce platform tracking the percentage of API requests that return 5xx server errors.

### Throughput

Measures the number of successful transactions or operations over a given period.

**Example**: A payment processing service monitoring the number of successful transactions per second to gauge system load capacity.

### Resource Utilization

Tracks how efficiently resources (CPU, memory, disk I/O, etc.) are used.

**Example**: A cloud-based database service ensuring CPU usage doesn’t exceed 70% over a given interval.

### Quality of Service

Measures aspects like data freshness, accuracy, or completeness.

**Example**: A data analytics platform tracking how up-to-date data is within a reporting dashboard, ensuring data isn’t older than 5 minutes.

## Practical Example Scenario

**Cloud Storage Service**

- **SLI 1: Availability** - Measure the percentage of successful file uploads and downloads over a month.
- **SLI 2: Latency** - Measure the 90th percentile latency for file retrieval requests.
- **SLI 3: Error Rate** - Monitor the proportion of failed file upload/download attempts due to server errors.

By carefully selecting SLIs that represent user expectations, organizations can focus on improving the aspects of their service that truly matter to customers, leading to more reliable and performant systems.

## Deployment Instructions

To deploy this Service Level Indicator (SLI) monitoring example locally using Docker and Terraform, follow these steps:

### Step 1: Clone the Repository
```bash
git clone https://github.com/trinidadgithub/IaC-sli-app.git
cd sli-monitoring
```
### Step 2: Set Environment Variables
```bash
export GRAFANA_ADMIN_USER=admin
export GRAFANA_ADMIN_PASSWORD=admin
```
### Step 3: Configure Terraform
```bash
cd terraform
terraform init
terraform validate
terraform plan
# When you are ready to deploy
terraform apply
```
### Step 4: Access the Services
* Grafana: http://localhost:3000
* Prometheus: http://localhost:9090
* cAdvisor: http://localhost:8080
* SLI App: http://localhost:5000

### Step 5: Verify Prometheus Targets
Open Prometheus UI and ensure that cAdvisor and sli_app targets are listed as 'UP'
* URL: http://localhost:9090/targets

### Step 6: View Grafana Dashboard
Log in to Grafana and view the pre-provisioned SLI dashboard. 
The login credentials are defined in the environment variables:
* Username: $GRAFANA_ADMIN_USER
* Password: $GRAFANA_ADMIN_PASSWORD

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
