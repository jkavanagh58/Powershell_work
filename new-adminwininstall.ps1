#Requires -Version 5
 <#
.Synopsis
   Add-on script to install standard utilities for win admin workstation

.DESCRIPTION
   This script is designed for Windows10 machines, when a Windows Admin builds a new windows workstation. Uses Powershell 
   Package Manager and chocolatey.


.NOTES
	10.04.2015 JJK: Needs more package validation before install
    10.04.2015 JJK: Need a list of utlities and determine if available

.Author
	Explorys - Kavanagh, John J.
#> 
# Add Chocolatey repository to Powershell V5
if (!(get-packagesource -Name Chocolatey)){
    Register-PackageSource -Name chocolatey -Provider chocolatey -Trusted –Location http://chocolatey.org/api/v2/
}
# Validate Chocolatey is trusted
if (!(get-packagesource).IsTrusted){get-packagesource chocolatey | Set-PackageSource -Trusted -Verbose }
# Start installing software
if (!(get-package -name sysinternals)){
    install-package sysinternals -Confirm:$false 
}
find-package keepassx | install-package -Verbose
# Just a thought map drives and then install keepass; need a function to get next available drive
new-psdrive -Name S -PSProvider FileSystem -Root \\sccm-1\sysops -Description "Main file source"
new-psdrive -Name T -PSProvider FileSystem -Root \\files\accounts 
Install-Package keepassx -AllVersions -InstallUpdate -Scope CurrentUser
<# Need to determine expanded chocolatey install process
find-package keepass-classic | install-package -AllVersions -InstallUpdate -Scope CurrentUser -Verbose -Force
# Might not be necesary - install keepass plugins
(find-package).where{$_.Name -like "keepass-plugin-*"}.ForEach{$_ | install-package -allversions -InstallUpdate -Scope CurrentUser -Whatif}
#>