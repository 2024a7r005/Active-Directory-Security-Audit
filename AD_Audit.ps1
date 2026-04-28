Write-Host "===== ACTIVE DIRECTORY SECURITY AUDIT =====" -ForegroundColor Cyan
Write-Host "Date: $(Get-Date)" -ForegroundColor Gray
Write-Host "Machine: $env:COMPUTERNAME" -ForegroundColor Gray

# -- 1. User Accounts -------------------------------------
Write-Host "`n[+] User Accounts:" -ForegroundColor Yellow
net user

# -- 2. Administrator Accounts ----------------------------
Write-Host "`n[+] Administrator Accounts:" -ForegroundColor Yellow
net localgroup administrators

# -- 3. Password Policy -----------------------------------
Write-Host "`n[+] Password Policy:" -ForegroundColor Yellow
net accounts

# -- 4. Active Sessions -----------------------------------
Write-Host "`n[+] Active Sessions:" -ForegroundColor Yellow
query user

# -- 5. System Info ---------------------------------------
Write-Host "`n[+] System Info:" -ForegroundColor Yellow
hostname
whoami

# -- 6. NEW: Firewall Status ------------------------------
Write-Host "`n[+] Firewall Status:" -ForegroundColor Yellow
netsh advfirewall show allprofiles state

# -- 7. NEW: Shared Folders (possible data leak risk) -----
Write-Host "`n[+] Shared Folders:" -ForegroundColor Yellow
net share

# -- 8. NEW: Open Network Ports (attack surface) ----------
Write-Host "`n[+] Open Network Ports:" -ForegroundColor Yellow
netstat -an | findstr "LISTENING"

# -- 9. NEW: Recently Installed Software ------------------
Write-Host "`n[+] Recently Installed Software:" -ForegroundColor Yellow
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Select-Object DisplayName, InstallDate |
    Where-Object { $_.DisplayName -ne $null } |
    Sort-Object InstallDate -Descending |
    Select-Object -First 10 |
    Format-Table -AutoSize

# -- 10. NEW: Failed Login Events (last 10) ---------------
Write-Host "`n[+] Recent Failed Login Attempts:" -ForegroundColor Yellow
try {
    Get-EventLog -LogName Security -InstanceId 4625 -Newest 10 -ErrorAction Stop |
        Select-Object TimeGenerated, Message |
        Format-List
} catch {
    Write-Host "  Could not read event log. Run as Administrator." -ForegroundColor Red
}

# -- End --------------------------------------------------
Write-Host "`n===== AUDIT COMPLETED =====" -ForegroundColor Green