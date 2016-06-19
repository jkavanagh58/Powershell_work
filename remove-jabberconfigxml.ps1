<#
.SYNOPSIS
   Removes a legacy file from Cisco Jabber install.
.DESCRIPTION
   Checks for existence of legacy XML file from earlier versions of Cisco Jabber. File is located
   in app data. Existing Cisco Jabber instance will be stopped and file deleted.
.AUTHOR
   Kavanagh, John J.
.NOTES
   06.01.2016: Initial testing. JJK
#>
Begin{
$targetfile = [Environment]::GetFolderPath('ApplicationData') + "\Cisco\Unified Communications\Jabber\CSF\Config\jabber-config.xml"
}
Process {
If (test-path $targetfile){
    # TODO: Code to interact with jabber
    $jabberproc = get-process -Name CiscoJabber -ErrorAction SilentlyContinue
    if ($jabberproc){
        "Probably need to stop this"
        Try {$jabberproc.kill()}
        Catch {"Unable to terminate the jabber application"}
    }
    Remove-Item $targetfile -Force -Whatif
}
}