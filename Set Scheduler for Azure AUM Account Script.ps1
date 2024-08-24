$server = @("ABENFS01.dpsg.net","AIRVFS01.dpsg.net")
$startTime = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Central Standard Time").AddDays(2).toString("MM/dd/yyyy HH:mm tt")

$sched = New-AzAutomationSchedule `
-ResourceGroupName USEU-AUM-WinServers-RG `
-AutomationAccountName "USEU-AUM-Windows-Automation" `
-Name "Testing Patching 17 JAN" `
-Description "JAN Patching" `
-OneTime `
-StartTime $startTime `
-TimeZone "Central Standard Time" `


$patch=New-AzAutomationSoftwareUpdateConfiguration `
-ResourceGroupName USEU-AUM-WinServers-RG `
-AutomationAccountName "USEU-AUM-Windows-Automation" `
-Schedule $sched `
-Windows `
-NonAzureComputer $server `
-Duration (New-TimeSpan -Hours 2) `
-RebootSetting Never `
-IncludedUpdateClassification Security,UpdateRollup,Updates
