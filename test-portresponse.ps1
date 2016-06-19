<#
.SYNOPSIS
Test the response of a computer to a specific TCP port

.DESCRIPTION
Test the response of a computer to a specific TCP port

.PARAMETER&nbsp; ComputerName
Name of the computer to test the response for

.EXAMPLE
PS C:\> ./Test-PortResponse.ps1 -ComputerName Server01

.EXAMPLE
PS C:\> Get-Content Servers.txt | ./Test-PortResponse.ps1 -Port 22

.NOTES
Author: Jonathan Medd
Date: 20/12/2011
#>

[CmdletBinding()]
param(
[Parameter(Position=0, ValueFromPipeline=$True)]
[System.String]
$ComputerName,

[Parameter(Position=1)]
[Int]
$Port = 3389
)

process {

$myCol = @()

$Connection = New-Object Net.Sockets.TcpClient

try {

$Connection.Connect($ComputerName,$Port)

if ($Connection.Connected) {
$Response = “Open”
$Connection.Close()
}

}

catch [System.Management.Automation.MethodInvocationException]

{
$Response = “Closed / Filtered”
}

$Connection = $null

$MYObject = “” | Select-Object ComputerName,Port,Response
$MYObject.ComputerName = $ComputerName
$MYObject.Port = $Port
$MYObject.Response = $Response
$myCol += $MYObject
$myCol

}
# SIG # Begin signature block
# MIIEFQYJKoZIhvcNAQcCoIIEBjCCBAICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrdjBx3Aj2El8Lzt7FUyXVp0M
# pvagggItMIICKTCCAZKgAwIBAgIQrOfUqrQ+kKREeKyDkz+mwDANBgkqhkiG9w0B
# AQUFADAeMRwwGgYDVQQDExNzcnZqa2F2YSAtIFN3YWdlbG9rMB4XDTExMDEwMTA1
# MDAwMFoXDTE3MDEwMTA1MDAwMFowHjEcMBoGA1UEAxMTc3J2amthdmEgLSBTd2Fn
# ZWxvazCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAx46O2ULyLzX+7mnFZIsT
# 3NKk2WT8+arh4lm/DE3p1+j1jFD7t5F3Xq+5Wp3iOnjWxrfB5n5hkxol5jPp0jTV
# Gt+GCYd3B1K8K0ot3eq5t3EzZY25hJV5RP8nLux2PZ4Zv5XtwOxumdzgBcw4TNDK
# NmlVl4J1WBI2rQZdHpAju2sCAwEAAaNoMGYwEwYDVR0lBAwwCgYIKwYBBQUHAwMw
# TwYDVR0BBEgwRoAQ4S1RzNj3oK1AFF68rJJk7KEgMB4xHDAaBgNVBAMTE3Nydmpr
# YXZhIC0gU3dhZ2Vsb2uCEKzn1Kq0PpCkRHisg5M/psAwDQYJKoZIhvcNAQEFBQAD
# gYEAJ3RLTpu5MSHZ5v6S3ryk9/0tBtrr+8vyJvttZKONJ/0bavOiydSLFrXe6dIq
# 7rkZX0ync00P41J/HyCziQ/06RDCb3FAXj7wt62/FIoIGKB7vlHQZ2ZwcoRx309q
# sm8vYDRD7mfVmqB08OrTwihVnyy948OcYsJFgKrX4DLn8lUxggFSMIIBTgIBATAy
# MB4xHDAaBgNVBAMTE3NydmprYXZhIC0gU3dhZ2Vsb2sCEKzn1Kq0PpCkRHisg5M/
# psAwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwIwYJKoZIhvcNAQkEMRYEFPm0tcIrBaN57XC9s9Aaofj53/HkMA0GCSqGSIb3
# DQEBAQUABIGAv1F/hFli/9R0jDrGBX+BlbJWgyGo9ZDjA2vkhZhpjw1iEJWKnd6x
# 30gyD+4t6CSHNjMMtpkXLndoT9Hh84o2jBE8ylZZ3dHqTLW2iCY6X5nWrMs147Y7
# 5upYuEmZgmWQ9yEJY8+JlMTY2o/381EJfXijMctKu+zNkjKVNeTnGys=
# SIG # End signature block
