Function install-integrationsvcs {
param($vm)
    # Attach ISO to VM
    set-vmdvddrive -vm $vm -Path
    # Get the drive letter for the now mounted ISO
    $drvltr = (get-vmdvddrive -VMName $vm.name | Select id | split-path -leaf)[0]
    # Use WMI to start the install process from the mounted ISO
    Invoke-WmiMethod -ComputerName $vm.name -Class Win32_Process -Name Create -ArgumentList "$($drvltr):\support\x86\setup.exe /install" -Credential ...
}