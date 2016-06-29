$domSID = "S-1-5-21-1531578694-299633563-1663972903*" # Verified against AD
$rptFile = "\\clvprdinfs001\IT_FileSRV\reports\RDOptimize\CMSMFA-profiles.txt"
# Assemble list of profiles that are not local special accounts and are not currently loaded
$usrprofiles = (gwmi win32_userprofile).where{$_.SID.Length -gt 8 -and $_.Loaded -eq $False} 
ForEach ($prof in $usrprofiles | sort LocalPath){
    $uname = $prof.LocalPath.Split("\")[2]
    switch ($uname)
    {
        'Administrator' {"Pass the admin account"} # version 1 deprecated
        {$_ -like "*.Net*"} {"Passing $uname"} # version 1 deprecated
        {$_ -like "MSSQL*"} {"Passing $uname"} # version 1 deprecated
        {$_ -like "svc*"}   {"Passing svc account $_"}
        Default {
            "Evaluating $uname"
            # Convert field value from string to date
            $lastuseval = [Management.ManagementDateTimeConverter]::ToDateTime($prof.LastUseTime)
            # ((get-date) - $lastuseval).totalDays
            if (((get-date) - $lastuseval).totalDays -gt 14){
                try {

                }
                Catch {

                }
                "Deleting profile {0} on {1} with a Last Used Time of {2}" -f $uname, $env:computername, $lastuseval | out-file $rptfile -Append
            }
        }
    }
    
}
 