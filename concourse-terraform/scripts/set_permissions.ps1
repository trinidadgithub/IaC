param (
    [string]$PrivateKeyPath
)
# Check the working directory
Write-Host "Current Directory: $(Get-Location)"

if (Test-Path $PrivateKeyPath) {
    Write-Host "File exists: $PrivateKeyPath"
} else {
    Write-Host "File does not exist: $PrivateKeyPath"
}


# Remove excessive permissions for groups and users
icacls $PrivateKeyPath /remove "BUILTIN\Users"
icacls $PrivateKeyPath /remove "NT AUTHORITY\Authenticated Users"
icacls $PrivateKeyPath /remove "BUILTIN\Administrators"
icacls $PrivateKeyPath /remove "NT AUTHORITY\SYSTEM"

# Remove inherited permissions
icacls $PrivateKeyPath /inheritance:r

# Grant only the current user read and delete permissions
icacls $PrivateKeyPath /grant:r "$($env:USERNAME):(R,D)"

