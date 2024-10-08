from flask import Flask, jsonify, request
import time
import random
from prometheus_client import start_http_server, Counter, Histogram
import threading
import requests

app = Flask(__name__)

# Prometheus metrics
REQUEST_COUNT = Counter('request_count', 'Total Request Count', ['endpoint', 'http_status'])
REQUEST_LATENCY = Histogram('request_latency_seconds', 'Request latency', ['endpoint'])

# Start Prometheus metrics server on port 8000
start_http_server(8000)


@app.route('/')
def index():
    return jsonify({"message": "Welcome to the SLI monitoring example!"}), 200


@app.route('/api/data', methods=['GET'])
def get_data():
    start_time = time.time()

    # Simulate processing time
    processing_time = random.uniform(0.1, 1.5)
    time.sleep(processing_time)

    # Simulate random errors
    status_code = 500 if random.random() < 0.1 else 200
    REQUEST_COUNT.labels(endpoint='/api/data', http_status=status_code).inc()
    REQUEST_LATENCY.labels(endpoint='/api/data').observe(time.time() - start_time)

    if status_code == 500:
        return jsonify({"error": "Internal Server Error"}), 500

    return jsonify({"data": "Here's some data!", "processing_time": processing_time}), 200


@app.route('/api/submit', methods=['POST'])
def submit_data():
    start_time = time.time()
    data = request.json

    if not data or 'value' not in data:
        REQUEST_COUNT.labels(endpoint='/api/submit', http_status=400).inc()
        return jsonify({"error": "Bad Request, 'value' is required"}), 400

    # Simulate random latency
    processing_time = random.uniform(0.2, 2.0)
    time.sleep(processing_time)

    # Simulate success/failure
    status_code = 500 if random.random() < 0.05 else 200
    REQUEST_COUNT.labels(endpoint='/api/submit', http_status=status_code).inc()
    REQUEST_LATENCY.labels(endpoint='/api/submit').observe(time.time() - start_time)

    if status_code == 500:
        return jsonify({"error": "Failed to process data"}), 500

    return jsonify({"message": "Data received successfully", "processing_time": processing_time}), 200


# Background thread to simulate network traffic
def simulate_network_traffic():
    while True:
        try:
            response = requests.get("https://jsonplaceholder.typicode.com/todos/1")
            print(f"Network traffic generated: Status Code {response.status_code}")
        except Exception as e:
            print(f"Error generating traffic: {e}")
        time.sleep(5)  # Simulate traffic every 5 seconds


# Start the network traffic simulation in a background thread
threading.Thread(target=simulate_network_traffic, daemon=True).start()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
