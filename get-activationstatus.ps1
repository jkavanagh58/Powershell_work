﻿function Get-ActivationStatus {
[CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$DNSHostName = $Env:COMPUTERNAME
    )
    process {
        try {
            $wpa = Get-WmiObject SoftwareLicensingProduct -ComputerName $DNSHostName `
            -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f'" `
            -Property LicenseStatus -ErrorAction Stop
        } catch {
            $status = New-Object ComponentModel.Win32Exception ($_.Exception.ErrorCode)
            $wpa = $null    
        }
        try {
            $ipval = [System.Net.DNS]::GetHostByName($DNSHostName).AddressList.IPAddressToString
        }
        catch {
            $ipval = "No entry found"
        }
        $out = New-Object psobject -Property @{
            ComputerName = $DNSHostName;
            IPAddress = $ipval
            Status = [string]::Empty;
        }
        if ($wpa) {
            :outer foreach($item in $wpa) {
                switch ($item.LicenseStatus) {
                    0 {$out.Status = "Unlicensed"}
                    1 {$out.Status = "Licensed"; break outer}
                    2 {$out.Status = "Out-Of-Box Grace Period"; break outer}
                    3 {$out.Status = "Out-Of-Tolerance Grace Period"; break outer}
                    4 {$out.Status = "Non-Genuine Grace Period"; break outer}
                    5 {$out.Status = "Notification"; break outer}
                    6 {$out.Status = "Extended Grace"; break outer}
                    default {$out.Status = "Unknown value"}
                }
            }
        } else {$out.Status = $status.Message}
        $out | Select ComputerName, IPAddress, Status
    }
}
$machines = "satprdcons002","CLVPTESQLN001","CLVPTESQLN002","clvtstwebvs002","clepterstapp001","clepterstapp002","CLEPERONB001",
"clvpteappsrv01","clvpteappsrv02"
$machines | % {Get-ActivationStatus -DNSHostName $_ }

#get-activationstatus clepterstapp001
