FROM ubuntu:22.04

# Set environment variable to prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    software-properties-common \
    postgresql-client-14 \
    osm2pgsql

# Create a directory for OSM data
RUN mkdir -p /data

# Set environment variables
ENV POSTGRES_HOST=${POSTGRES_HOST:-"localhost"}

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the working directory to avoid potential permission issues
WORKDIR /data

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
