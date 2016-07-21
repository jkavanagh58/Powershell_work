<# 
	.SYNOPSIS 
		Collection of functions for SCCM Admin
	.DESCRIPTION 
		Collection of functions to help with SCCM Client administration. Primarily utilizing WMI methods to interact
        with the SCCM client.
	.NOTES
        07.21.2016 JJK: To be converted to a module.
	.AUTHOR
		John J Kavanagh
 #>
Function refresh-sccmclientwu {
[CmdletBinding()]
param($MachineName)
# Define list of triggers to action to perform
$actions= 
"{00000000-0000-0000-0000-000000000021}", # Request Machine Policy
"{00000000-0000-0000-0000-000000000102}", # Software Inventory
"{00000000-0000-0000-0000-000000000108}", # Software Updates Assignment
"{00000000-0000-0000-0000-000000000113}"  # Software Update Scan 
# Run each trigger in order entered
ForEach ($trigger in $actions){
    Try {
        # DEBUG "Would execute {0} on {1}" -f $trigger, $machinename
        $params = @{
            Namespace    = "root\CCM"
            Class        =  "SMS_Client"
            Name         =  "TriggerSchedule"
            ArgumentList = $trigger
            computername = $machinename
        }
        Invoke-wmiMethod @params -AsJob 
        Start-Sleep 8
    }
    Catch {
        "{0} : {1}" -f $MachineName, $error[0].Exception
    }
} # End executing a trigger

} # End Function
Function get-sccmrebootstatus{
<# 
	.SYNOPSIS 
		Rerturn SCCM Pending Reboot Status
	.DESCRIPTION 
		Process goes beyond checking the registry value and instructs the computer referenced in the machinename 
        variable to perform a query which is more accurate that looking at the registry key.
	.PARAMETER machinename
		Mandatory parameter, enter the name of the computer to check for pending reboot.
	.EXAMPLE
		There's no need to number your examples. 
        get-sccmrebootstatus -machinename "clvprdhvn001","CLVPRDHVN002" 
    .EXAMPLE
        Run against multiple computers
        "clvprdhvn001","ClVPRDHVN002" | %{get-sccmrebootstatus -machinename $_ }
	.NOTES
        07.20.2016 JJK: This was written primarily as a function to be added into a Windows Profile
        07.20.2016 JJK: Due to mixed versions of Windows Server OS, WMI is used versus the more current CIM implementation.
	.VERSION 1
    .AUTHOR
		John J Kavanagh
 #>
 [CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$true)]
    $machinename
)

 If (test-connection -ComputerName $machinename -Count 1 -Quiet -ErrorAction SilentlyContinue){
    Try {
        <#
            Newer method but not appropriate for back level versions of windows
            Invoke-CimMethod -Namespace root\ccm\clientsdk -Class CCM_ClientUtilities -Name DetermineIfRebootPending -ComputerName clvprdsys001
        #>
        $val = Invoke-WmiMethod -Namespace root\ccm\clientsdk -Class CCM_ClientUtilities -Name DetermineIfRebootPending -ComputerName $machinename
        if ($val.RebootPending){"{0} requires a reboot to complete Security patching" -f $machinename}
        Else{ "{0} is not pending a reboot" -f $machinename }
        # Return $val.RebootPending
    }
    Catch {

        "Unable to query {0}" -f $machinename
    }
} # End if statement
Else {
    "{0} did not respond to ping" -f $machinename    
}
} # End get-sccrebootstatus function
Function start-ccmfileinventory{
<# 
	.SYNOPSIS 
		Trigger SCCM Client File Inventory
	
	.DESCRIPTION 
		This script invokes the WMI method provided by the SCCM client to trigger a file inventory task.
	
	.PARAMETER machinename 
		Here, the dotted keyword is followed by a single parameter name. Don't precede that with a hyphen. The following lines describe the purpose of the parameter: 
	
	.PARAMETER filePath Provide a PARAMETER section for each parameter that your script or function accepts.
	
	.EXAMPLE
		There's no need to number your examples. 
	
	.EXAMPLE 
		PowerShell will number them for you when it displays your help text to a user.
	
	.NOTES

	.AUTHOR
		John J Kavanagh
 #>
[CmdletBinding()]
Param(
[string]$machinename
)
Try {
# pre-splat Invoke-WmiMethod -Namespace root\CCM -Class SMS_Client -Name TriggerSchedule -ArgumentList "{00000000-0000-0000-0000-000000000010}" -computername $machinename -Credential $admcreds
$params = @{
    NameSpace =    "root\CCM"
    Class =        "SMS_Client"
    Name =         "TriggerSchedule"
    ArgumentList = "{00000000-0000-0000-0000-000000000010}"
    computername =  $machinename
    Credential =    $admcreds
}
$proc = Invoke-WmiMethod @params
"SCCM Action triggered successfully on {0}" -f $machinename
}
Catch {
    "WMI Method not executed on {0}" -f $machinename
    $Error[0].Exception
}
}

<# Some code to show how to use
get-adcomputer -Filter {Name -Like "CLVSQ*"} | sort Name | %{ get-sccmrebootstatus -machinename $_.Name} | clip
refresh-sccmclientwu -machinename clvprddom007
#>