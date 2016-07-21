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
