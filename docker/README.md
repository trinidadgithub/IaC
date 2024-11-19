# Run the following to install docker  
# Taken fronm https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository  
  
docker-setup.sh  
uninstall-docker-dependencies.sh  
  
### Here's a cheat sheet for Docker commands organized by category for quick reference:  
1. Basic Commands  
   
    | Command |	Description |  
    | -------- | -------------- |   
    |`docker --version` | Show Docker version |    
    |`docker info` | Display system-wide information |  
    |`docker help` | Show help for Docker commands |  

2. Images  

    |Command |Description  |
    |--------|-------------|
    |`docker images` |List all images  |
    |`docker pull <image>` |Pull an image from a registry (e.g., Docker Hub)  |
    |`docker build -t <name>:<tag>` .|Build an image from a Dockerfile  |
    |`docker tag <image> <repo>:<tag>`|Tag an image for pushing to a registry |
    |`docker push <repo>:<tag>`|Push an image to a registry  |
    |`docker rmi <image>`|Remove an image  |
    |`docker image prune`|Remove unused images  |
3. Containers  

    |Command |Description  |
    |----------|-------------|
    |`docker ps`|List running containers  |
    |`docker ps -a`|List all containers  |
    |`docker run <image>`|Run a container from an image  |
    |`docker run -d <image>`|Run a container in detached mode  |
    |`docker run -it <image>`|Run a container interactively (with a shell)  |
	|`docker stop <container>`|Stop a running container  |
	|`docker start <container>`|Start a stopped container  |
	|`docker restart <container>`|Restart a container  |
	|`docker rm <container>`|Remove a stopped container  |
	|`docker logs <container>`|View logs of a container  |
	|`docker exec -it <container> <command>`|Run a command inside a running container  |
	|`docker attach <container>`|Attach to a running container  |
1. Volumes  
Command	Description  
docker volume ls	List all volumes  
docker volume create <name>	Create a new volume  
docker volume rm <name>	Remove a volume  
docker volume inspect <name>	Display detailed information about a volume  
docker run -v <volume>:<path> <image>	Mount a volume to a container  
1. Networks  
Command	Description  
docker network ls	List all networks  
docker network create <name>	Create a new network  
docker network rm <name>	Remove a network  
docker network inspect <name>	Display detailed information about a network  
docker run --network=<name> <image>	Connect a container to a specific network  
1. Docker Compose  
Command	Description  
docker-compose up	Start containers defined in docker-compose.yml  
docker-compose up -d	Start containers in detached mode  
docker-compose down	Stop and remove containers and networks  
docker-compose ps	List containers managed by Compose  
docker-compose logs	View logs for Compose-managed containers  
docker-compose build	Build images defined in the Compose file  
1. Inspecting and Debugging  
Command	Description  
docker inspect <object>	Detailed information about an image/container/volume/network  
docker stats	View real-time stats for running containers  
docker top <container>	Show running processes in a container  
docker history <image>	Show history of an image  
1. Cleanup Commands  
Command	Description  
docker system prune	Remove unused data (containers, images, networks, volumes)  
docker container prune	Remove stopped containers  
docker image prune	Remove unused images  
docker volume prune	Remove unused volumes  
docker network prune	Remove unused networks  
1. Saving and Loading  
Command	Description  
docker save -o <file> <image>	Save an image to a file  
docker load -i <file>	Load an image from a file  
docker export <container> > <file>	Export a container’s filesystem to a file  
docker import <file>	Import a file as a new image  
1.  Docker Registry  
Command	Description  
docker login	Log in to a Docker registry  
docker logout	Log out of a Docker registry  
docker search <term>	Search for images in a registry  