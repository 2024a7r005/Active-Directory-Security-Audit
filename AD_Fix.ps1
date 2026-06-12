Write-Host "Starting Security Configuration..." 

# Updating Password Policy
Write-Host "Updating password settings..."
net accounts /minpwlen:8
net accounts /lockoutthreshold:5

# Removing unnecessary administrator access
Write-Host "Removing extra admin privileges..."
net localgroup administrators Hp /delete

# Securing Remote Desktop access
Write-Host "Disabling Remote Desktop access..."
netsh advfirewall firewall set rule group="remote desktop" new enable=No

Write-Host ""
Write-Host "Security settings updated successfully."
Write-Host ""

# Displaying updated configuration
Write-Host "Updated Password Policy:"
net accounts

Write-Host ""
Write-Host "Administrator Group Members:"
net localgroup administrators