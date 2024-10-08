#!/bin/bash

# Function to create files and handle errors
create_file() {
    local file=$1
    if [[ -f $file ]]; then
        echo "File '$file' already exists. Skipping."
    else
        touch "$file"
        if [[ $? -eq 0 ]]; then
            echo "File '$file' created successfully."
        else
            echo "Error creating file '$file'." >&2
            exit 1
        fi
    fi
}

# Function to create directories and handle errors
create_directory() {
    local dir=$1
    if [[ -d $dir ]]; then
        echo "Directory '$dir' already exists. Skipping."
    else
        mkdir -p "$dir"
        if [[ $? -eq 0 ]]; then
            echo "Directory '$dir' created successfully."
        else
            echo "Error creating directory '$dir'." >&2
            exit 1
        fi
    fi
}

# Create root-level files
create_file "README.md"
create_file "LICENSE"
create_file "Dockerfile"
create_file "requirements.txt"
create_file "CHANGELOG.md"

# Create modules/eks-cluster directory
#create_directory "helm/myapp/templates"
create_directory "terraform/docker"
create_directory "app"
create_directory "docs"

# Create eks-cluster module files
create_file "terraform/main.tf"
create_file "terraform/variables.tf"
create_file "terraform/outputs.tf"
create_file "terraform/provider.tf"
create_file "terraform/docker/kafka.tf"
create_file "terraform/docker/zookeeper.tf"
create_file "terraform/docker/stream_processor.tf"
create_file "app/stream_processor"
create_file "app/__init__.py"
create_file "docs/USAGE.md"
create_file ".gitignore"

# Completion message
echo "Terraform-helm directory structure setup complete."

