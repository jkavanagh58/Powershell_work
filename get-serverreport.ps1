Function get-hostipaddress {
param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$hostname
)
try {
    $ipval = [System.Net.DNS]::GetHostByName($hostname).AddressList.IPAddressToString
}
catch {
    $ipval = "Unable to find DNS Entry"
}
Return $ipval
}
$Report = @()
$servers = get-adcomputer -filter {Operatingsystem -like "*server*"}
ForEach ($srv in $servers){
if (test-connection -ComputerName $srv.name -Count 1 -Quiet -ErrorAction SilentlyContinue){
    try {
        $osinfo = gwmi win32_operatingsystem -computername $srv.name -ErrorAction SilentlyContinue
        $osname = $osinfo.caption
    }
    catch {
        $osname = "No data available"
    }
    try {
        $compinfo = gwmi win32_computersystem -computername $srv.name -ErrorAction SilentlyContinue
        $cpucount = $compinfo.NumberofProcessors
        $mem = $compinfo.TotalPhysicalMemory
    }
    catch {
        $cpucount = "No data available"
        $mem =      "No data available"
    }

    # Get IP Address
    try {
        $ipval = get-hostipaddress -hostname $srv.name
    }
    catch {
        $ipval = "No DNS entry found"
    }
    $objdat = [pscustomobject]@{
                      Name = $srv.name;
                      OS   = $osname;
                      CPU  = $cpucount;
                      RAM  = $mem;
                      IP   = $ipval
     }
}

Else {
    # Server was not online/reachable
    $objdat = [pscustomobject]@{
                      Name = $srv.name;
                      OS   = "No data";
                      CPU  = "No data";
                      RAM  = "No data";
                      IP   = "No data"
     }
}
    $Report += $objdat    
}
