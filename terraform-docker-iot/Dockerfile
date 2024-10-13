FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install required system packages (including git)
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Copy the local files into the container's /app directory
COPY . /app

# Install Python dependencies if requirements.txt exists
RUN if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

# Ensure start.sh is executable
RUN chmod +x /app/start.sh

# Expose the relevant port (replace 8883 if necessary)
EXPOSE 8883

# Set the default command to run the start.sh script
CMD ["./start.sh"]

