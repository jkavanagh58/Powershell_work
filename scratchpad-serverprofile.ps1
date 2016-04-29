Function show-rebootquestion {
[CmdletBinding()]
Param(
    [string]$message,
    [string]$title
)
    $msgBox =  [Windows.Forms.MessageBox]::Show($message, $title, [Windows.Forms.MessageBoxButtons]::YesNoCancel, [Windows.Forms.MessageBoxIcon]::Question)
    if( $msgBox -eq [System.Windows.Forms.DialogResult]::YES ) {restart-computer }
    if( $msgBox -eq [System.Windows.Forms.DialogResult]::NO ) {"Without a reboot your changes will not take effect until this server is restarted."
                                                                EXIT
                                                              }
    else { # Catch all
           "Without a reboot your changes will not take effect until this server is restarted."
            EXIT
          }
}

Function set-serverguioff {
# Simple function to Turn the GUI off and simulating server core
    try{
        Remove-WindowsFeature Server-Gui-Shell, Server-Gui-Mgmt-Infra
        "GUI Features have been disabled, server boot is required"
        Show-RebootQuest -Message "GUI Disabled. Do you want these changes applied now?" -Title "Apply Server Changes"
    }
    Catch {
        "Unable to make changes to Server config. Validate server status."
    }

}
Function set-serverguion {
# Simple function to Turn the GUI on
    try{
        Add-WindowsFeature Server-Gui-Shell, Server-Gui-Mgmt-Infra
        "GUI Features have been enabled, server boot is required"
        Show-RebootQuest -Message "GUI Enabled. Do you want these changes applied now?" -Title "Apply Server Changes"
    }
    Catch {
        "Unable to make changes to Server config. Validate server status."
    }

}




<#
- Refine into a single function
-Version 2
Function toggle-gui {
Param(
    [switch]$on
)
}
#>