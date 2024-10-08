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

# Create modules/eks-cluster directory
create_directory "helm/myapp/templates"
create_directory "terraform"
create_directory "app"
create_directory "docs"

# Create eks-cluster module files
create_file "terraform/main.tf"
create_file "terraform/variables.tf"
create_file "terraform/outputs.tf"
create_file "terraform/provider.tf"
create_file "helm/myapp/Chart.yaml"
create_file "helm/myapp/values.yaml"
create_file "helm/myapp/templates/deployment.yaml"
create_file "helm/myapp/templates/service.yaml"
create_file "app/server.js"
create_file "docs/documentation.md"

# Completion message
echo "Terraform-helm directory structure setup complete."

