# Set variables for Concourse login and pipeline configuration
$target = "my-target"                  # Name of the Concourse target
$concourseUrl = "http://localhost:8080" # Concourse URL (change as needed)
$username = "admin"                     # Username for Concourse
$password = "admin"                     # Password for Concourse
$pipelineName = "example-pipeline"      # Name for the pipeline
$pipelineFile = "..\ci\test_pipeline.yaml"  # Path to your pipeline YAML file

# Login to Concourse using fly
fly -t $target login -c $concourseUrl -u $username -p $password

# Set the pipeline
fly -t $target set-pipeline -p $pipelineName -c $pipelineFile -n

# Unpause the pipeline
# fly -t $target unpause-pipeline -p $pipelineName

# Print status message
Write-Output "Pipeline '$pipelineName' has been deployed and unpaused successfully."
