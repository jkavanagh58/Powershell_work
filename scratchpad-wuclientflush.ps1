#Requires -RunAsAdministrator

stop-service wuauserv
Rename-Item C:\windows\SoftwareDistribution -NewName C:\windows\SoftwareDistribution.old -Force
start-service wuauserv