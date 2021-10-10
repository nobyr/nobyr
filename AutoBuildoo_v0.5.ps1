# Temp Folder
if (!(Get-Item C:\tempo -ea ignore)) { mkdir C:\tempo }

$dropperscript = 'C:\tempo\dropper.ps1'

$dropper = @'
#############################################
###        Configuration Variables        ###
                                            #
# Put any variables you'll use here
                                            # 
###                                       ###
#############################################

# Static Variables
$countfile = 'C:\tempo\bootcount.txt'
$bootbatch = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\dropper.bat'
$dropperscript = 'C:\tempo\dropper.ps1'

#################
##### Setup #####

# Bootstrap Batch
if (!(Get-Item $bootbatch -ea ignore)) {
    "powershell -c $dropperscript`npause" | Out-File $bootbatch -Encoding 'OEM'
}

# Boot Count
if (Get-Item $countfile -ea ignore) {
    [int]$bootcount = Get-Content $countfile
    if ($bootcount -match "^\d{1,2}$") { ([int]$bootcount) ++ }
    else { $bootcount = 1 }
}
else { $bootcount = 1 }
$bootcount | Out-File $countfile

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

switch ($bootcount) {
    
    1 {
        # Fill in anything needed on first run

		$start_time = Get-Date
		[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

		foreach ($url in $RawGitHubFiles) {
			$output = "$cscrito\$($url.Split("/")[-1])"
			$wc = New-Object System.Net.WebClient
			$wc.DownloadFile($url, $output)
		}

		PowerShell $part1            

        Restart-Computer
        ##################################################
    }
    
    2 {
		PowerShell $part2

        Restart-Computer
        ##################################################
    }
    
    3 {
 		PowerShell $part3
        
        Restart-Computer
        ##################################################
    }
    
    4 {
		PowerShell $part4
        
        Restart-Computer
        ##################################################
    }
    
    5 {
		PowerShell $part5
        
        Restart-Computer
        ##################################################
    }
    
    default {
        # Dropper is complete; clean up
        rm $countfile
        rm $bootbatch
        rm $dropperscript
    }
}
'@

# Drop and run Dropper

$dropper | Out-File $dropperscript -Encoding 'OEM'

Invoke-Expression $dropperscript