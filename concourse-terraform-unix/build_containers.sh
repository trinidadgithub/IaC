# Build the custom web image
docker build -t custom-concourse-web:latest -f Dockerfile.web .

# Build the custom worker image
docker build -t custom-concourse-worker:latest -f Dockerfile.worker .