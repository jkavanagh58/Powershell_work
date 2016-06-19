stop-service wuauserv, appidsvc,cryptsvc 
# WSUS Data folder
If (test-path C:\windows\SoftwareDistribution.old){
	Remove-item C:\windows\SoftwareDistribution.old -force
	rename-item C:\windows\SoftwareDistribution -NewName C:\windows\SoftwareDistribution.old
}
Else {
	rename-item C:\windows\SoftwareDistribution -NewName C:\windows\SoftwareDistribution.old
}
# Update catalog
if (test-path c:\windows\system32\catroot2.bak){
	Remove-item c:\windows\system32\catroot2.bak -Force
	Rename-Item "c:\windows\system32\catroot2" -NewName "c:\windows\system32\catroot2.bak" -Force
}
Else {
	Rename-Item "c:\windows\system32\catroot2" -NewName "c:\windows\system32\catroot2.bak" -Force
}
# Start all services back up
start-service wuauserv, appidsvc,cryptsvc 