param (
    [string]$PrivateKeyPath
)

try {
    # Use ssh-keygen to generate an SSH-format public key from the private key
    $sshKey = & ssh-keygen -y -f $PrivateKeyPath

    # Check if the conversion was successful and output the result in JSON format
    if (-not [string]::IsNullOrWhiteSpace($sshKey)) {
        # Output the result in JSON format for Terraform
        $jsonOutput = @{ ssh_key = $sshKey } | ConvertTo-Json
        Write-Output $jsonOutput
    }
    else {
        Write-Output "{`"error`": `"Failed to convert key - output was empty`"}"
        exit 1
    }
} catch {
    Write-Output "{`"error`": `"Failed to convert key - $_`"}"
    exit 1
}
