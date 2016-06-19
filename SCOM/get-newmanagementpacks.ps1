<#
	.SYNOPSIS
		List Management Packs recently installed.

	.DESCRIPTION
		Event log searches local Operations Manager log for events recording a
		Management Pack is received.  Script looks back one hour for 1201 entries.

	.NOTES
		Additional information about the function go here.

	.LINK
		about_functions_advanced

	.LINK
		about_comment_based_help

#>

begin {
$regex = [regex]'"(.*?)"'
}
Process {
#Custom formatting 
$format = @{Label="MPName-Version";Expression={$regex.Matches($_.Message)}}
 
get-eventlog -LogName "Operations Manager" -after (get-date).addhours(-1) | 
    Where-Object {$_.Eventid -eq 1201} | 
    Format-Table TimeGenerated, EventId, $format -AutoSize
}