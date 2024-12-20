Blue-Green Deployment Simulation with Enhnaced Features

This project demonstrates a Blue-Green Deployment Simulation using Docker Compose. The simulation includes a router service using Nginx for dynamic traffic routing, POST request handling for the blue and green services, and explicitly named containers for easier management.

---
Features

- **Dynamic Traffic Routing**: Traffic is routed dynamically between the blue and green environments based on weights defined in nginx.conf.  The router service is implemented using Nginx.

- **POST Request Handling**: Both blue and green services can handle POST requests and return responses with a newline character (\n).

- **Named Containers**: The blue and green services have fixed container names (blue and green), simplifying debugging and testing.

---

Project Structure

```bash
version-2/
├── blue/
│   ├── app.py                # Blue version of the web app
│   └── Dockerfile            # Dockerfile for building the Blue container
├── green/
│   ├── app.py                # Green version of the web app
│   └── Dockerfile            # Dockerfile for building the Green container
├── nginx.conf                # NGINX configuration file to control routing
├── docker-compose.yml        # Docker Compose configuration file for setting up the environment
└── README.md                 # Project documentation
```

Requirements

- Docker
- Docker Compose
- Python 3.9 evironment for building the `blue` and `green` services

Setup Instructions

Clone the Repository:
```
git clone git@github.com:trinidadgithub/IaC.git
cd Deployments/blue-green-deployment/version-2
```
Build and Start Containers: Run the following command to build and start the containers:
```bash
docker compose up --build
````
Verify the setup:
```bash
docker ps --format "table {{.Names}}\t{{.Image}}"

NAMES         IMAGE
router        nginx:latest
blue          version-2-blue
green         version-2-green
```

Test Dynamic Routing

- Send GET Requests:
  ```bash
  curl http://localhost
  ```

- Send POST requests:
```bash
curl -X POST -H "Content-Type: application/json" \
    -d '{"message": "Hello from the client!"}' \
    http://localhost
```

Check Logs: Verify which container handled the requests

```bash
docker logs blue
docker logs green
```
---
### Known Issues and Troubleshooting
1. Bad Gateway (502)
   - Ensure `blue` and `green` services are running on port 5000
   - Verify connectivity from the router:
    ```bash
    docker exec -it router curl http://blue:5000
    docker exec -it router curl http://green:5000
    ```
2. Request Routing:
   - If routing is not working as expected, reload the Nginx configuration:
    ```bash
    docker exec -it router nginx -s reload
    ```



#### Project Overview

- Blue and Green Containers: The Blue and Green directories each contain a simple Python Flask application that displays either "Blue Version" or "Green Version."
- NGINX Router: NGINX acts as a reverse proxy, routing requests to either the Blue or Green container based on the configuration.
- Docker Compose: Docker Compose orchestrates the containers and allows easy switching between versions by restarting NGINX.

#### Why Blue-Green Deployment?

Blue-Green deployments reduce downtime by keeping two identical environments live. Changes are deployed to the inactive environment (Green), tested, and then traffic is switched over once it's confirmed stable. If issues arise, you can revert traffic to the original environment (Blue) without affecting the user experience.

#### License

This project is open source and available under the MIT License.
