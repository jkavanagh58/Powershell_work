<# 
	.SYNOPSIS 
		Performs steps to reset the WSUS Client. 
	
	.DESCRIPTION 
		Performs steps to reset the WSUS Client.
	
	.NOTES
        07.11.2016 JJK: TODO break into functions as cryptsvc can be problematic but not essential in this process
	.AUTHOR
		John J Kavanagh
 #>
stop-service wuauserv, appidsvc,cryptsvc -Force -confirm:$False
# Update catalog
if (test-path c:\windows\system32\catroot2.bak){
	Remove-item c:\windows\system32\catroot2.bak -Force -Confirm:$false -Recurse
	Rename-Item "c:\windows\system32\catroot2" -NewName "c:\windows\system32\catroot2.bak" -Force -Confirm:$false 
}
Else {
	Rename-Item "c:\windows\system32\catroot2" -NewName "c:\windows\system32\catroot2.bak" -Force -Confirm:$false
}

# WSUS Data folder
If (test-path C:\windows\SoftwareDistribution.old){
	Remove-item C:\windows\SoftwareDistribution.old -force -Confirm:$false -Recurse
	rename-item C:\windows\SoftwareDistribution -NewName C:\windows\SoftwareDistribution.old -Force -Confirm:$false
}
Else {
	rename-item C:\windows\SoftwareDistribution -NewName C:\windows\SoftwareDistribution.old -Force -Confirm:$false
}
# Start all services back up
start-service wuauserv, appidsvc,cryptsvc 