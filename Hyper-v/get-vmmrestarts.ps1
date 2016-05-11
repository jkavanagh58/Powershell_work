get-eventlog -LogName System -after (Get-Date).AddDays(-1) | 
? {$_.EventId -eq 7036 -and $_.Message -like "*Hyper-V Virtual Machine Management service*" } | 
select MachineName, Timegenerated, Message | fl | clip