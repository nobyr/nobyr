# Determine script location for PowerShell
$ScriptDir = "C:\scripto"

Write-Host "Current script directory is $ScriptDir"

#Source folder
$SourceFolder = "$ScriptDir\downloadz-part5\"
mkdir $SourceFolder

#Create new Powershell object
$KBArrayListDL = New-Object -TypeName System.Collections.ArrayList 

#Download KB list
$KBArrayListDL.AddRange(@( 
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/06/windows8.1-kb3063843-x64_57199ff97cd3ff29fc3cfe398effed9d32b992b5.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/10/windows8.1-kb3094486-x64_8e0a16b668f275e088ad3508f4a7cfe76b0757ec.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/03/windows8.1-kb3147071-x64_1c0f181c6c3b716477b00d6946f750b81fd0766c.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/03/windows8.1-kb3115224-v2-x64_1afbc3e96ec234b79cf559344285e16741d49a4b.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/03/windows8.1-kb3123245-x64_61c7ff67a72622b596bf7a7a2162cb19c709baff.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/08/windows8.1-kb3179574-x64_f0a5e2ff991aec5e6978aa808f287f1b21195d6e.msu"))

foreach ($link in $KBArrayListDL){ 

    $whatKB = $link.Split("-")
    $KB = $whatKB[1]

    (New-Object System.Net.WebClient).DownloadFile($link, "$SourceFolder$KB.msu")

    }


#Crete new Powershell object
$KBArrayList = New-Object -TypeName System.Collections.ArrayList 

#Mofify KB article list
# not found 
$KBArrayList.AddRange(@( "KB3063843","KB3094486","KB3147071","KB3115224","KB3123245","KB3179574")) 

foreach ($KB in $KBArrayList) { Write-Output "Starting treatment for $KB"
    if (-not(Get-Hotfix -Id $KB -ea Ignore)) { 
        Start-Process -FilePath "wusa.exe" -ArgumentList "$SourceFolder$KB.msu /quiet /norestart" -Wait } 
}
