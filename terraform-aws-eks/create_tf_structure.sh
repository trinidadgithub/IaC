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
create_file "main.tf"
create_file "variables.tf"
create_file "outputs.tf"
create_file "versions.tf"
create_file "README.md"
create_file "LICENSE"

# Create modules/eks-cluster directory
create_directory "modules/eks-cluster"
create_directory "docs"

# Create eks-cluster module files
create_file "modules/eks-cluster/main.tf"
create_file "modules/eks-cluster/variables.tf"
create_file "modules/eks-cluster/outputs.tf"
create_file "docs/documentation.md"

# Completion message
echo "Terraform directory structure setup complete."

