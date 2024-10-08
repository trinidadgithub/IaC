FROM python:3.8-slim

# Set the working directory
WORKDIR /app

# Copy the stream_processor.py file
COPY ./app/stream_processor.py /app/stream_processor.py

# Install the Python dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Run the stream processor
CMD ["python", "stream_processor.py"]

