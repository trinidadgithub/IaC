# Service Level Indicator (SLI) Lab

This project is a small local lab for practicing Service Level Indicators (SLIs) with a Flask application, Prometheus, Grafana, Docker, and Terraform.

The application intentionally adds variable latency and occasional failures so you can observe practical reliability signals:

- Availability
- Error rate
- Request rate
- p95 and p99 latency
- Short-window vs long-window error-rate trends

This is not a production architecture. It is a learning environment for understanding how SLIs map to real service behavior.

## Architecture

Terraform creates a local Docker network and containers for:

| Component | Purpose | Local URL |
|---|---|---|
| Flask app | Example service | <http://localhost:5000> |
| App metrics | Prometheus metrics endpoint | <http://localhost:8000> |
| Prometheus | Metrics storage/querying | <http://localhost:9090> |
| Grafana | Dashboards | <http://localhost:3000> |
| cAdvisor | Container metrics | <http://localhost:8080> |

Prometheus scrapes the Flask app through the shared Docker network at `sli_app:8000`.

## Metrics

The Flask app exposes these custom metrics:

| Metric | Type | Labels | Purpose |
|---|---|---|---|
| `sli_http_requests_total` | Counter | `endpoint`, `method`, `status` | Request volume and error-rate analysis |
| `sli_http_request_duration_seconds_bucket` | Histogram | `endpoint`, `method`, `status`, `le` | p95/p99 latency analysis |

The metrics are served from a separate Prometheus endpoint on port `8000`.

## Deploy Locally

```bash
git clone https://github.com/trinidadgithub/IaC.git
cd IaC/sli_app/terraform

terraform init
terraform validate
terraform apply
```

Grafana is configured with:

```text
username: admin
password: admin01
```

## Generate Traffic

From the `sli_app` directory:

```bash
chmod +x scripts/generate_traffic.sh
./scripts/generate_traffic.sh
```

Optional controls:

```bash
ITERATIONS=100 SLEEP_SECONDS=0 ./scripts/generate_traffic.sh
```

For richer Grafana graphs, run the script a few times or increase `ITERATIONS`.

The script sends:

- `GET /api/data` requests
- valid `POST /api/submit` requests
- occasional invalid `POST /api/submit` requests to produce expected `400` responses

## PromQL Examples

Request rate:

```promql
sum by (endpoint, method) (rate(sli_http_requests_total[5m]))
```

Availability, counting 5xx responses as service failures:

```promql
1 - (
  sum(rate(sli_http_requests_total{status=~"5.."}[5m]))
  /
  sum(rate(sli_http_requests_total[5m]))
)
```

5xx error rate:

```promql
sum(rate(sli_http_requests_total{status=~"5.."}[5m]))
/
sum(rate(sli_http_requests_total[5m]))
```

p95 latency:

```promql
histogram_quantile(
  0.95,
  sum by (le, endpoint, method) (
    rate(sli_http_request_duration_seconds_bucket[5m])
  )
)
```

p99 latency:

```promql
histogram_quantile(
  0.99,
  sum by (le, endpoint, method) (
    rate(sli_http_request_duration_seconds_bucket[5m])
  )
)
```

Short-window vs long-window error-rate trend:

```promql
sum(rate(sli_http_requests_total{status=~"5.."}[5m]))
/
sum(rate(sli_http_requests_total[5m]))
```

```promql
sum(rate(sli_http_requests_total{status=~"5.."}[30m]))
/
sum(rate(sli_http_requests_total[30m]))
```

## Grafana Dashboards

Terraform provisions two dashboards:

- **Docker/container monitoring** through cAdvisor
- **SLI Lab - Flask Service** for request rate, availability, error rate, latency percentiles, status code breakdown, and short-window vs long-window error-rate comparison

The SLI dashboard is intentionally small. It focuses on operational questions rather than every metric available.

## SLI Notes

Availability should be based on request success ratio, not container uptime.

4xx responses require a policy decision. In many API SLIs, expected client errors are excluded from service failure calculations. 5xx responses usually count as service-side failures.

Latency should be reviewed with percentiles, not only averages. p95 and p99 expose tail behavior that average latency can hide.

Short windows catch fast-moving problems but can be noisy. Longer windows show sustained behavior but may smooth out spikes. Looking at both helps distinguish a transient blip from a degrading service.

## Cleanup

```bash
cd terraform
terraform destroy
```

## Related Field Note

This lab is referenced by the field note **Building A Small SLI Lab With Flask, Prometheus, And Grafana** in the companion site repository.

## License

This project is licensed under the MIT License. See [LICENSE](./LICENSE).
