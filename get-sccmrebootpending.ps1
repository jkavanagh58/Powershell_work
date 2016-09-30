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

# SIG # Begin signature block
# MIIQ/gYJKoZIhvcNAQcCoIIQ7zCCEOsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUkKrgKf/xcavySq1vOomYrgVo
# Q7ugggvuMIIDLzCCAhegAwIBAgIQHqfB0rqVX6JN/32xlwT4hTANBgkqhkiG9w0B
# AQsFADAfMR0wGwYDVQQDDBR3d3cua2F2YW5hZ2h0ZWNoLm5ldDAeFw0xNjA3MjIw
# MjM3MDFaFw0xNzA3MjIwMjU3MDFaMB8xHTAbBgNVBAMMFHd3dy5rYXZhbmFnaHRl
# Y2gubmV0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAydEeQYmyT9kP
# aIuiYsylur/zozqXf/vtF1hr01WlXlanVGbP3dU/LoBS1SfHBA6RIm479yKYksfd
# 6VG/dlppe1bn5p0EFNCQHuegLcmctG6cz1TYc9Voh+VblfmgvfFPPS+2U4wJUFR1
# jkGJgQ79hCzx+CrFgaIGYpVyh0jDXrnIEk/RPCw29zgSWJyQvQ0S4LMAUHeKpBe5
# EdxFtla5HDqKktq4+W+XRkH6HKcn3iwhH9HArURogb7M6QlqeCIWmqZ4IvNkKoIu
# lsOESDFzl0WEdGgLQsay59WGXhpVVpLfdLsQlOyVfolHwIyO1OYWUfYzsHB+jSi8
# OdgQxT3vzQIDAQABo2cwZTAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwHwYDVR0RBBgwFoIUd3d3LmthdmFuYWdodGVjaC5uZXQwHQYDVR0OBBYE
# FCY3Gdpvz2oZb4hcIdcrdcZB+6wgMA0GCSqGSIb3DQEBCwUAA4IBAQB/ThwaXFn6
# 1LHFFqmoo1244AixCor0OgT68wDAd19Cdxs5elB53QTLQFxJIHwC9Lg+DK94Zd+U
# dEoq5XQCULn+4g/pSmdN8aTWnSVtGpYaxNIpTP80ja4BipXeGDHYBYhzUP7+cPHD
# qGEqdypZ4usb0qtXq8bCaKXIljk5bL/2EGg2SqxjkyAB+c5RR0UWDSdJMaQAI/if
# ay448EXHWmPVpo2i3ZlcbTrnzRMXPQfELvVB+S5nfMAFfGN1n0AcFsnrwPu0ZQDt
# FpGoUiVtvu6UmL7zL0m9VIfJaLucnGVxYvH0ck9HPRrREiLCxdQ9JeR4EBGBRfC8
# UfNxeo1biolRMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEF
# BQAwVzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAO
# BgNVBAsTB1Jvb3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0x
# MTA0MTMxMDAwMDBaFw0yODAxMjgxMjAwMDBaMFIxCzAJBgNVBAYTAkJFMRkwFwYD
# VQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVz
# dGFtcGluZyBDQSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# lO9l+LVXn6BTDTQG6wkft0cYasvwW+T/J6U00feJGr+esc0SQW5m1IGghYtkWkYv
# maCNd7HivFzdItdqZ9C76Mp03otPDbBS5ZBb60cO8eefnAuQZT4XljBFcm05oRc2
# yrmgjBtPCBn2gTGtYRakYua0QJ7D/PuV9vu1LpWBmODvxevYAll4d/eq41JrUJEp
# xfz3zZNl0mBhIvIG+zLdFlH6Dv2KMPAXCae78wSuq5DnbN96qfTvxGInX2+ZbTh0
# qhGL2t/HFEzphbLswn1KJo/nVrqm4M+SU4B09APsaLJgvIQgAIMboe60dAXBKY5i
# 0Eex+vBTzBj5Ljv5cH60JQIDAQABo4HlMIHiMA4GA1UdDwEB/wQEAwIBBjASBgNV
# HRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBRG2D7/3OO+/4Pm9IWbsN1q1hSpwTBH
# BgNVHSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
# YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wMwYDVR0fBCwwKjAooCagJIYiaHR0cDov
# L2NybC5nbG9iYWxzaWduLm5ldC9yb290LmNybDAfBgNVHSMEGDAWgBRge2YaRQ2X
# yolQL30EzTSo//z9SzANBgkqhkiG9w0BAQUFAAOCAQEATl5WkB5GtNlJMfO7Fzko
# G8IW3f1B3AkFBJtvsqKa1pkuQJkAVbXqP6UgdtOGNNQXzFU6x4Lu76i6vNgGnxVQ
# 380We1I6AtcZGv2v8Hhc4EvFGN86JB7arLipWAQCBzDbsBJe/jG+8ARI9PBw+Dpe
# VoPPPfsNvPTF7ZedudTbpSeE4zibi6c1hkQgpDttpGoLoYP9KOva7yj2zIhd+wo7
# AKvgIeviLzVsD440RZfroveZMzV+y5qKu0VN5z+fwtmK+mWybsd+Zf/okuEsMaL3
# sCc2SI8mbzvuTXYfecPlf5Y1vC0OzAGwjn//UYCAp5LUs0RGZIyHTxZjBzFLY7Df
# 8zCCBJ8wggOHoAMCAQICEhEh1pmnZJc+8fhCfukZzFNBFDANBgkqhkiG9w0BAQUF
# ADBSMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYG
# A1UEAxMfR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBHMjAeFw0xNjA1MjQw
# MDAwMDBaFw0yNzA2MjQwMDAwMDBaMGAxCzAJBgNVBAYTAlNHMR8wHQYDVQQKExZH
# TU8gR2xvYmFsU2lnbiBQdGUgTHRkMTAwLgYDVQQDEydHbG9iYWxTaWduIFRTQSBm
# b3IgTVMgQXV0aGVudGljb2RlIC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
# ggEKAoIBAQCwF66i07YEMFYeWA+x7VWk1lTL2PZzOuxdXqsl/Tal+oTDYUDFRrVZ
# UjtCoi5fE2IQqVvmc9aSJbF9I+MGs4c6DkPw1wCJU6IRMVIobl1AcjzyCXenSZKX
# 1GyQoHan/bjcs53yB2AsT1iYAGvTFVTg+t3/gCxfGKaY/9Sr7KFFWbIub2Jd4NkZ
# rItXnKgmK9kXpRDSRwgacCwzi39ogCq1oV1r3Y0CAikDqnw3u7spTj1Tk7Om+o/S
# WJMVTLktq4CjoyX7r/cIZLB6RA9cENdfYTeqTmvT0lMlnYJz+iz5crCpGTkqUPqp
# 0Dw6yuhb7/VfUfT5CtmXNd5qheYjBEKvAgMBAAGjggFfMIIBWzAOBgNVHQ8BAf8E
# BAMCB4AwTAYDVR0gBEUwQzBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0
# cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADAW
# BgNVHSUBAf8EDDAKBggrBgEFBQcDCDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8v
# Y3JsLmdsb2JhbHNpZ24uY29tL2dzL2dzdGltZXN0YW1waW5nZzIuY3JsMFQGCCsG
# AQUFBwEBBEgwRjBEBggrBgEFBQcwAoY4aHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
# LmNvbS9jYWNlcnQvZ3N0aW1lc3RhbXBpbmdnMi5jcnQwHQYDVR0OBBYEFNSihEo4
# Whh/uk8wUL2d1XqH1gn3MB8GA1UdIwQYMBaAFEbYPv/c477/g+b0hZuw3WrWFKnB
# MA0GCSqGSIb3DQEBBQUAA4IBAQCPqRqRbQSmNyAOg5beI9Nrbh9u3WQ9aCEitfhH
# NmmO4aVFxySiIrcpCcxUWq7GvM1jjrM9UEjltMyuzZKNniiLE0oRqr2j79OyNvy0
# oXK/bZdjeYxEvHAvfvO83YJTqxr26/ocl7y2N5ykHDC8q7wtRzbfkiAD6HHGWPZ1
# BZo08AtZWoJENKqA5C+E9kddlsm2ysqdt6a65FDT1De4uiAO0NOSKlvEWbuhbds8
# zkSdwTgqreONvc0JdxoQvmcKAjZkiLmzGybu555gxEaovGEzbM9OuZy5avCfN/61
# PU+a003/3iCOTpem/Z8JvE3KGHbJsE2FUPKA0h0G9VgEB7EYMYIEejCCBHYCAQEw
# MzAfMR0wGwYDVQQDDBR3d3cua2F2YW5hZ2h0ZWNoLm5ldAIQHqfB0rqVX6JN/32x
# lwT4hTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUQDDgMxGPZ5ZvEuW+Q3XmYDwusZAwDQYJKoZI
# hvcNAQEBBQAEggEAaRoP8obG5j33bzuhRJYgdIRt+6UiTFw8FxDytya0t8Oon2B3
# OmruzO6/wgZw5hi1eYBDZPymV+BPxLH2P3GAkuXMvX0LHG1hnPuu+H7Nt2Zo/3uB
# QmIW5aOJ3koX9Qlv+u+jhxhSSz4iFOwdq7Xza8moGs5Y1YcbxuBerqH+xBsbUHw/
# Xqe9O2ForiAp1CC5x/kaJVE/qakGN+rX1cN8WhWAi7E8JaoS+kEOcLsNYbFhcvH6
# eXmqa3iQKeuhBNFQTKSztMXI1ImkgmBkDwt7G+ls3NDiHgk+4EXg6iU5EomCvn62
# jVMxsDBgqQuaRpKe2sG37VgHQUT3J5ojGd51lKGCAqIwggKeBgkqhkiG9w0BCQYx
# ggKPMIICiwIBATBoMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
# IG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIEcy
# AhIRIdaZp2SXPvH4Qn7pGcxTQRQwCQYFKw4DAhoFAKCB/TAYBgkqhkiG9w0BCQMx
# CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjA3MjMwMjUwNTRaMCMGCSqG
# SIb3DQEJBDEWBBRemaweiJWMYw2rox6miCs68rK5bjCBnQYLKoZIhvcNAQkQAgwx
# gY0wgYowgYcwgYQEFGO4L6th9YOQlpUFCwAknFApM+x5MGwwVqRUMFIxCzAJBgNV
# BAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9i
# YWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIEcyAhIRIdaZp2SXPvH4Qn7pGcxTQRQw
# DQYJKoZIhvcNAQEBBQAEggEAFnP7rKuQVMFvZ7gwguxcr2xYKTDe3IcQY6Tcrlut
# /g8754HKMFdqYZrFEaVP08MRvp6Hos5kDXLwKA8ktAv9gs4RhGdbUUwn27NWWNZZ
# jcsAPc72JS1YkzbEHUf4NnYOEBlk51nFeV/upW/v3imtdrnIMoJ0w1xOd3wdzeni
# sDXhTf7SuGo6NsWghggKAwDQsXbOokJD6zMDEAeLZYXuUGbTOaIl6oNMPAbmySBz
# 3gbDXGDbnQvl6F8FkMeY4cZ9IgIiQI2dNV9pqjxVLZUn4H6swWHJjQJHmcTSD7h3
# DQ4jkP2Q+mCV1MA2CilY4AxftsD0C9z+gMc2tC0/F0JTBQ==
# SIG # End signature block
