# Use the official Python image
FROM python:3.12.0-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the source code
COPY app.py .

# Expose ports
EXPOSE 5000 8000

# Command to run the application
CMD ["python", "app.py"]

