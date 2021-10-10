########
#AutoBuilder V0.4
#Copyright:     Free to use, please leave this header intact
#Author:        Jos Lieben (OGD)
#Company:       OGD (http://www.ogd.nl)
#Script help:   http://www.liebensraum.nl
#Purpose:       This script can run a series of commands and continue after a reboot without any manual interaction.
########
#Requirements:
########
#Run with admin privileges
#IMPORTANT: do not run this from a location where SYSTEM cannot access it, like the desktop of your admin account. Use a folder like c:\temp
#Otherwise, you will get error 0xFFFD0000 in your task scheduler result or an infinite reboot
########
#Changes:
########
#V0.1 27-10-2015: Initial Version
#V0.2 03-11-2015: Removed stage file in favor of saving the current stage to the task as an argument
#V0.3 12-11-2015: Allow alternative credentials for the scheduled task
#V0.4 10-10-2021: ABC personalized changed: $logFile, $version, $scriptName
########
#Example:.\test.ps1 -ExampleVariable TEST
#Do not use -taskStage in your commandline, this is set automatically

[cmdletbinding()]
Param(
	[Parameter(Mandatory=$false)]
	[string]$ExampleVariable = $( Read-Host "Enter a value for ExampleVariable" ), #This is an example input parameter for the script
	#ADD ADDITIONAL ARGUMENTS HERE IF NEEDED
	[Parameter(Mandatory=$False)]
	[Int]$taskStage = -1 #THIS ALWAYS HAS TO BE THE LAST ARGUMENT FOR THIS SCRIPT!
)

#######Config######
$logToFile = $True
$logToScreen = $True
$logFile = "c:\tempo\log.txt"
$logVerbose = $True
$version = 0.4
$scriptName = "AutoBuildero ABC 2012 R2"

#function to log information to screen, file or both
function log(){
	Param(
		[Parameter(Mandatory=$true)]
		[Int][ValidateSet(0,1,2,3)]$logLevel, #0 = verbose message, #1 = warning, #2 = error, #3 = critical error
		[Parameter(Mandatory=$true)]
		[string]$logMessage,
		[bool]$logToFile=$logToFile,
		[bool]$logToScreen=$logToScreen,
		[string]$logFile=$logFile,
		[bool]$logVerbose=$logVerbose,
		[bool]$logLastError=$False
	)
	switch($logLevel){
		0 {
			if($logVerbose){
				if($logToFile){ac $logFile "$(Get-Date) |VERBOSE| $($logMessage)"}
				if($logToScreen){Write-Host "$(Get-Date) |VERBOSE| $($logMessage)" -ForegroundColor Cyan}
			}
		}
		1 {
			if($logVerbose){
				if($logToFile){ac $logFile "$(Get-Date) |WARNING| $($logMessage)"}
				if($logToScreen){Write-Host "$(Get-Date) |WARNING| $($logMessage)" -ForegroundColor Yellow}
			}
		}
		2 {
			if($logToFile){ac $logFile "$(Get-Date) |ERROR| $($logMessage)"}
			if($logToScreen){Write-Host "$(Get-Date) |ERROR| $($logMessage)" -ForegroundColor Red}
		}
		3 {
			if($logToFile){ac $logFile "$(Get-Date) |CRITICAL ERROR| $($logMessage)"}
			if($logToScreen){Write-Host "$(Get-Date) |CRITICAL ERROR| $($logMessage)" -ForegroundColor Red}
		}
	}
	if($logLastError){
			if($logToFile){ac $logFile "$(Get-Date) |ERROR DETAILS| $($Error[0].Exception)"}
			if($logToScreen){Write-Host "$(Get-Date) |ERROR DETAILS| $($Error[0].Exception)" -ForegroundColor Red}    
			if($logToFile){ac $logFile "$(Get-Date) |ERROR DETAILS| $($Error[0].ErrorDetails)"}
			if($logToScreen){Write-Host "$(Get-Date) |ERROR DETAILS| $($Error[0].ErrorDetails)" -ForegroundColor Red}      
			if($logToFile -and $logVerbose){ac $logFile "$(Get-Date) |ERROR DETAILS| $($Error[0].ScriptStackTrace)"}
			if($logToScreen -and $logVerbose){Write-Host "$(Get-Date) |ERROR DETAILS| $($Error[0].ScriptStackTrace)" -ForegroundColor Red}                            
	}
}

function abort{
	try{
		UnRegister-ScheduledTask -taskname $scriptName -Confirm:$False -ErrorAction Stop
	}catch{
		log -logLevel 2 -logMessage -logMessage "failed to unregister script from the Task Scheduler" -logLastError $True
	}
	log -logLevel 0 -logMessage -logMessage "-----END $scriptName $version running on $($env:COMPUTERNAME) as $($env:USERNAME)-----"
	Exit
}

#Function to modify the stage parameter as saved in the Windows Scheduled Task, if the task doesn't exist it will be created
function setStage(){
	Param(
		[Parameter(Mandatory=$true)]
		[string]$newStage, #new stage for the script to execute when running next boot
		[string]$credentialLogin = $Null, #Login to run the task as, if not specified task will run as SYSTEM
		[string]$credentialPassword = $Null #password for above login, if omitted the task will run as SYSTEM
	)

	#check if a task already exists for this script
	try{Get-ScheduledTask -TaskName $scriptName -ErrorAction Stop | Out-Null}catch{$registerTask = $True}

	$args = $taskArguments
	if($args -notlike "*-taskStage*") {
		$args = " -taskStage 0"
	}

	#register a new task if it doesn't exist
	if($registerTask){
		try{
			$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:05
			$PS = New-ScheduledTaskAction -Execute $taskCmdLine -Argument $args
			if($credentialLogin -and $credentialPassword){
				Register-ScheduledTask -Description $scriptName -TaskName $scriptName -Trigger $trigger -User $credentialLogin -Password $credentialPassword -Action $PS -ErrorAction Stop
				log -logLevel 0 -logMessage "Registered scheduled task to run as $credentialLogin"
			}else{
				Register-ScheduledTask -Description $scriptName -TaskName $scriptName -Trigger $trigger -User "NT Authority\SYSTEM" -Action $PS -ErrorAction Stop
				log -logLevel 0 -logMessage "Registered scheduled task to run as NT Authority\SYSTEM"
			}  
		}catch{
			log -logLevel 3 -logMessage "unabled to register a scheduled task" -logLastError $True
			abort
		}    
	}
	#update the new or existing task's stage and credentials
	$newTaskArguments = "$($args.SubString(0,$args.IndexOf("taskStage")+10))$newStage"
	$action = New-ScheduledTaskAction -Execute $taskCmdLine -Argument $newTaskArguments        
	try{
		if($credentialLogin -and $credentialPassword){
			Set-ScheduledTask -TaskName $scriptName -Action $action -User $credentialLogin -Password $credentialPassword -ErrorAction Stop
			log -logLevel 0 -logMessage "Scheduled task updated to stage $newStage, will run as $credentialLogin"
		}else{
			Set-ScheduledTask -TaskName $scriptName -Action $action -User "NT Authority\SYSTEM" -ErrorAction Stop
			log -logLevel 0 -logMessage "Scheduled task updated to stage $newStage, will run as NT Authority\SYSTEM"
		}            
		return 1
	}catch{
		log -logLevel 3 -logMessage "Scheduled task failed to update to stage $newStage" -logLastError $True
		return 0
	}
}

#save script arguments so it can automatically rerun the script with the arguments passed or answered at the first run
$definedArgs = ""
foreach ($key in $MyInvocation.BoundParameters.keys)
{
	$value = (get-variable $key).Value 
	$definedArgs += " -$($key) $($value)"
}
$taskCmdLine = "powershell.exe"
$taskArguments =  "-File `"$($myinvocation.mycommand.definition)`"$definedArgs"

#Check if the script is elevated, abort if not. You can remove these lines if you do not require elevated permissions
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){   
	log -logLevel 3 -logMessage "Not running under Admin privileges"
	abort
}

##Set the stage to stage 0 if no stage parameter was passed to the script
if($taskStage -eq -1){
	setStage -newStage 0
	$taskStage = 0
}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC

$cscrito = "C:\scripto"
mkdir $cscrito

$scriptos = @()
$RawGitHubFiles = @()

# target raw.githubusercontent script = local copy script name
$scriptos += (
	"install-KBs-download-before-part1.ps1",
	"install-KBs-download-before-part2.ps1",
	"install-KBs-download-before-part3-additionals.ps1",
	"install-KBs-download-before-part4.ps1",
	"install-KBs-download-before-part5.ps1"
)
foreach ($scriptoo in $scriptos) {
	$RawGitHubFiles += "https://raw.githubusercontent.com/nobyr/nobyr/main/$scriptoo"
}

$part1 = "$cscrito\$($scriptos[0])"
$part2 = "$cscrito\$($scriptos[1])"
$part3 = "$cscrito\$($scriptos[2])"
$part4 = "$cscrito\$($scriptos[3])"
$part5 = "$cscrito\$($scriptos[4])"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC End

#PICK STAGE, SCRIPT STARTS HERE, ADD CODE PER STAGE.
#Below example shows how the stage is set before the machine is rebooted. If you need additional stages, don't forget to use setStage before doing a reboot command
switch($taskStage){
	#Stage 0, the initial stage
	0 {
		#Write initial logfile header
		log -logLevel 0 -logMessage "----- BEGIN $scriptName $version running on $($env:COMPUTERNAME) as $($env:USERNAME)-----"
		log -logLevel 0 -logMessage "Command line: $taskCmdLine $taskArguments"

		log -logLevel 1 -logMessage "SWITCH STAGE 0"

		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC
		
		$start_time = Get-Date
		[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

		foreach ($url in $RawGitHubFiles) {
			$output = "$cscrito\$($url.Split("/")[-1])"
			$wc = New-Object System.Net.WebClient
			$wc.DownloadFile($url, $output)
		}

		PowerShell $part1
		log -logLevel 0 -logMessage "Time taken: $((Get-Date).Subtract($start_time))"

		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC End

		#Set stage to 1
		setStage -newStage 1
		log -logLevel 0 -logMessage "Rebooting the machine to finish SWITCH STAGE 0...."
		Restart-Computer -Force
	}
	#Stage 1, add additional stages as needed
	1 {
		log -logLevel 1 -logMessage "SWITCH STAGE 1"

		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC
		$start_time = Get-Date
		PowerShell $part2
		log -logLevel 0 -logMessage "Time taken: $((Get-Date).Subtract($start_time))"
		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC End


		#Set stage to 2
		setStage -newStage 2
		log -logLevel 0 -logMessage "Rebooting the machine to finish SWITCH STAGE 1...."
		Restart-Computer -Force
	}
	#Stage 2
	2 {
		log -logLevel 1 -logMessage "SWITCH STAGE 2"

		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC
		$start_time = Get-Date
		PowerShell $part3
		log -logLevel 0 -logMessage "Time taken: $((Get-Date).Subtract($start_time))"
		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC End

		#Set stage to 2
		setStage -newStage 3
		log -logLevel 0 -logMessage "Rebooting the machine to finish SWITCH STAGE 2...."
		Restart-Computer -Force
	}
	#Stage 3
	3 {
		log -logLevel 1 -logMessage "SWITCH STAGE 3"   

		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC
		$start_time = Get-Date
		PowerShell $part4
		log -logLevel 0 -logMessage "Time taken: $((Get-Date).Subtract($start_time))"
		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC End

		#Set stage to 2
		setStage -newStage 4
		log -logLevel 0 -logMessage "Rebooting the machine to finish SWITCH STAGE 3...."
		Restart-Computer -Force
	}
	#Stage 4 and final
	4 {
		log -logLevel 1 -logMessage "SWITCH STAGE LAST"   

		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC
		$start_time = Get-Date
		PowerShell $part5
		log -logLevel 0 -logMessage "Time taken: $((Get-Date).Subtract($start_time))"
		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ABC End

		log -logLevel 0 -logMessage "DONE with the last switch case! reboot loot finished."
		#and finish the script
		abort
	}

}
