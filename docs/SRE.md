**1. What is SRE?**
- **Definition:** Site Reliability Engineering (SRE) applies software engineering principles to infrastructure and operations problems, focusing on creating scalable and reliable systems by bridging the gap between development and operations.
- **Key Resource:** Google SRE Overview: https://sre.google/sre-book/introduction/

**2. Service Level Objectives (SLOs), Service Level Agreements (SLAs), and Service Level Indicators (SLIs)**
  - **SLIs (Service Level Indicators):** Quantitative measures of reliability, such as latency or error rate.
  - **SLOs (Service Level Objectives):** Target metrics that define acceptable levels of reliability.
  - **SLAs (Service Level Agreements):** Formal agreements that outline consequences if SLOs are not met.
  - **Key Resource:** Understanding SLIs, SLOs, and SLAs: https://sre.google/sre-book/service-level-objectives/
**3. Error Budgets**
- Definition: An error budget is the amount of time a system is allowed to be unavailable without breaching the agreed SLOs, balancing reliability and feature velocity.
- Key Resource: Error Budgets Explained: https://sre.google/sre-book/error-budget/

**4. Monitoring and Observability**
- Concepts:
	- Monitoring: Collecting metrics, logs, and traces to understand system health.
	- Observability: Gaining insights into the system's internal state by using monitoring data, enabling quick detection and resolution of issues.
- Key Resource:
	- The Four Golden Signals: https://sre.google/sre-book/monitoring-distributed-systems/
	- Observability Primer by Honeycomb: https://www.honeycomb.io/what-is-observability/
    - 
**5. Incident Management and Postmortems**
- Incident Management: Establishing processes to detect, respond to, and resolve system outages efficiently.
- Postmortems: Analyzing incidents to identify root causes and implement preventative measures.
- Key Resource:
	- Google's Postmortem Culture: https://sre.google/sre-book/postmortem-culture/
	- PagerDuty’s Incident Response Guide: https://response.pagerduty.com/
  
**6. Automation and Toil Reduction**
- Toil: Repetitive, manual, operational work that does not provide long-term value. SREs aim to automate tasks to reduce toil.
- Key Resource:
	- Eliminating Toil: https://sre.google/sre-book/eliminating-toil/
	- Automating Toil with SRE: https://medium.com/google-cloud/site-reliability-engineering-series-toil-9215f2f08bf4

**7. Capacity Planning and Load Management**
- Definition: SREs ensure that systems have the capacity to handle traffic and workloads, even during peak times, through capacity planning and load testing.
- Key Resource:
	- Capacity Planning: https://sre.google/sre-book/capacity-planning/
  
**8. Reliability Engineering and Chaos Engineering**
- Reliability Engineering: Implementing practices and tools to ensure systems are reliable under unpredictable conditions.
- Chaos Engineering: Introducing failures into the system deliberately to test its resilience.
- Key Resource:
	- Principles of Reliability Engineering: https://sre.google/sre-book/reliability-engineering/
    - The Principles of Chaos Engineering: https://principlesofchaos.org/
**9. SRE Tools and Technology Stack**

	Common tools include Prometheus (monitoring), Grafana (visualization), Terraform (infrastructure as code), Kubernetes (container orchestration), and Ansible (configuration management).
- Key Resource:
	- SRE Tools and Practices: https://cloud.google.com/sre
	- Prometheus Monitoring: https://prometheus.io/docs/introduction/overview/

**10. SRE and DevOps: Understanding the Differences and Similarities**

Concept: While SRE and DevOps aim to improve collaboration between development and operations, SRE applies software engineering practices to achieve operational goals.
- Key Resource:
      - SRE vs. DevOps: https://cloud.google.com/blog/products/devops-sre/sre-vs-devops-competing-or-complementary

**Bonus Resources for Deepening SRE Knowledge**
- Books:
	- Site Reliability Engineering: How Google Runs Production Systems: https://sre.google/sre-book/table-of-contents/
    - The Site Reliability Workbook: https://sre.google/workbook/table-of-contents/
