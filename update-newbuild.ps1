<#
.SYNOPSIS
    Script to complete the build process post MDT

.DESCRIPTION
    This script will run against a Windows Server with WinRM enabled and perform configuration changes that allow:
    RDP
    Disable IESC for Administrators

.PARAMETER computername
    This parameter is for the name or UP address of the computer to perform the config changes on.

.EXAMPLE
    ..\update-newbuild.ps1 -computername cl-pd-server
    Executing this command where the script is in your working directory and will run against server named
    cl-pd-server.
    
.NOTES
    JJK: Assumes script is run with an account that has administrator rights to computer referenced in the 
    computername variable
    TODO-JJK:        Provide ability to use altername credentials.
    09.17.2015-JJK:  Modified Param to correct typo 
    09.17.2015-JJK:  Modified pssession create statement to use variable name from param
    10.01.2015-JJK:  Added section to create installs folder


#>

Param(
    [Parameter(Mandatory=$true)]
    [string]$computername 
)
# Validate server is online
# Validate psremoting is possible

$session = new-pssession -computer $computername -cred (get-credential)
invoke-command -session $session -scriptblock {
#http://blogs.technet.com/b/bruce_adamczak/archive/2013/02/12/windows-2012-core-survival-guide-remote-desktop.aspx
#value 1 is off
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections"

#value 0 is off
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1 
get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication"

#Enabled False is off
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
# Get-Netfirewallrule -DisplayGroup "Remote Desktop" | format-table Name, Enabled -autosize
Get-Netfirewallrule -DisplayGroup "Remote Desktop" | Select-object Name, Enabled | format-table -autosize
}
# Disable IE Ehanced Security
invoke-command -session $session -scriptblock {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}
# Create install_files folder on c: drive
Invoke-command -session $session -ScriptBlock {
    if (test-path -path c:\ ){new-item -name "install_files" -Path "c:\" -ItemType Directory
}