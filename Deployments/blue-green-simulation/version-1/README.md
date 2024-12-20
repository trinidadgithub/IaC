Blue-Green Deployment Simulation

This project demonstrates a Blue-Green deployment strategy using Docker and NGINX to manage seamless switching between two app versions ("Blue" and "Green"). Blue-Green deployments allow for smooth transitions between application versions, minimizing downtime during updates.
Project Structure

```bash
blue-green-deployment/
├── blue/
│   ├── app.py                # Blue version of the web app
│   └── Dockerfile            # Dockerfile for building the Blue container
├── green/
│   ├── app.py                # Green version of the web app
│   └── Dockerfile            # Dockerfile for building the Green container
├── nginx.conf                # NGINX configuration file to control routing
└── docker-compose.yml        # Docker Compose file for setting up the environment
```

Requirements

- Docker
- Docker Compose

Setup Instructions

Clone the Repository:
```
git clone git@github.com:trinidadgithub/IaC.git
cd Deployments/blue-green-deployment/version-1
```
Build and Start Containers: Run the following command to build and start the containers:
```bash
docker compose up --build
````
Access the Application: Open your web browser and navigate to http://localhost. By default, you’ll see the Blue version.

Switching Between Blue and Green Environments

The nginx.conf file controls which version (Blue or Green) is active.

- To Switch to the Green Version:  Open nginx.conf and comment/uncomment the server lines to route traffic to the Green environment:

```bash
    upstream app {
        # server blue:5000;  # Comment this line to disable Blue
        server green:5000;    # Uncomment this line to enable Green
    }
````

Apply the Changes: Restart the NGINX container to apply the changes:
```bash
docker compose restart nginx
```

Verify the Active Environment:  Refresh http://localhost in your browser to see the change. You should now see the Green version.

#### Project Overview

- Blue and Green Containers: The Blue and Green directories each contain a simple Python Flask application that displays either "Blue Version" or "Green Version."
- NGINX Proxy: NGINX acts as a reverse proxy, routing requests to either the Blue or Green container based on the configuration.
- Docker Compose: Docker Compose orchestrates the containers and allows easy switching between versions by restarting NGINX.

#### Why Blue-Green Deployment?

Blue-Green deployments reduce downtime by keeping two identical environments live. Changes are deployed to the inactive environment (Green), tested, and then traffic is switched over once it's confirmed stable. If issues arise, you can revert traffic to the original environment (Blue) without affecting the user experience.

#### License

This project is open source and available under the MIT License.
