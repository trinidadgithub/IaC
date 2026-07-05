from flask import Flask, jsonify, request
from prometheus_client import Counter, Histogram, start_http_server
import random
import time

app = Flask(__name__)

REQUEST_COUNT = Counter(
    "sli_http_requests",
    "Total HTTP requests handled by the SLI lab app",
    ["endpoint", "method", "status"],
)

REQUEST_LATENCY = Histogram(
    "sli_http_request_duration_seconds",
    "HTTP request latency for the SLI lab app",
    ["endpoint", "method", "status"],
    buckets=(0.05, 0.1, 0.25, 0.5, 1.0, 1.5, 2.0, 3.0, 5.0, float("inf")),
)


def record_request(endpoint, method, status, start_time):
    status_text = str(status)
    REQUEST_COUNT.labels(endpoint=endpoint, method=method, status=status_text).inc()
    REQUEST_LATENCY.labels(endpoint=endpoint, method=method, status=status_text).observe(
        time.time() - start_time
    )


@app.route("/")
def index():
    start_time = time.time()
    status = 200
    record_request("/", "GET", status, start_time)
    return jsonify({"message": "Welcome to the SLI monitoring example"}), status


@app.route("/healthz")
def healthz():
    start_time = time.time()
    status = 200
    record_request("/healthz", "GET", status, start_time)
    return jsonify({"status": "ok"}), status


@app.route("/api/data", methods=["GET"])
def get_data():
    start_time = time.time()

    processing_time = random.uniform(0.1, 1.5)
    time.sleep(processing_time)

    status = 500 if random.random() < 0.10 else 200
    record_request("/api/data", "GET", status, start_time)

    if status == 500:
        return jsonify({"error": "Internal Server Error"}), status

    return jsonify({"data": "example", "processing_time": processing_time}), status


@app.route("/api/submit", methods=["POST"])
def submit_data():
    start_time = time.time()
    data = request.json

    if not data or "value" not in data:
        status = 400
        record_request("/api/submit", "POST", status, start_time)
        return jsonify({"error": "Bad Request, 'value' is required"}), status

    processing_time = random.uniform(0.2, 2.0)
    time.sleep(processing_time)

    status = 500 if random.random() < 0.05 else 200
    record_request("/api/submit", "POST", status, start_time)

    if status == 500:
        return jsonify({"error": "Failed to process data"}), status

    return jsonify({"message": "Data received", "processing_time": processing_time}), status


if __name__ == "__main__":
    start_http_server(8000)
    app.run(host="0.0.0.0", port=5000)
