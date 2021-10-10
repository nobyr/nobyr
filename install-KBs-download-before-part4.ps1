# Determine script location for PowerShell
$ScriptDir = "C:\scripto"
 
Write-Host "Current script directory is $ScriptDir"

#Source folder
$SourceFolder = "$ScriptDir\downloadz-part4\"
mkdir $SourceFolder

#Create new Powershell object
$KBArrayListDL = New-Object -TypeName System.Collections.ArrayList 

#Download KB list
$KBArrayListDL.AddRange(@( 
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/03/windows8.1-kb3123245-x64_61c7ff67a72622b596bf7a7a2162cb19c709baff.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/10/windows8.1-kb3094486-x64_8e0a16b668f275e088ad3508f4a7cfe76b0757ec.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/06/windows8.1-kb3063843-x64_57199ff97cd3ff29fc3cfe398effed9d32b992b5.msu"))

foreach ($link in $KBArrayListDL){ 

    $whatKB = $link.Split("-")
    $KB = $whatKB[1]

    (New-Object System.Net.WebClient).DownloadFile($link, "$SourceFolder$KB.msu")

    }


#Crete new Powershell object
$KBArrayList = New-Object -TypeName System.Collections.ArrayList 

#Mofify KB article list
# not found ,"KB4057903",KB5001088
$KBArrayList.AddRange(@( "KB3063843","KB3094486","KB3123245")) 

foreach ($KB in $KBArrayList) { Write-Output "Starting treatment for $KB"
    if (-not(Get-Hotfix -Id $KB -ea Ignore)) { 
        Start-Process -FilePath "wusa.exe" -ArgumentList "$SourceFolder$KB.msu /quiet /norestart" -Wait } 
}
