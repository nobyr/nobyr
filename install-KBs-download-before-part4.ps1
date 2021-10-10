# Determine script location for PowerShell
$ScriptDir = C:\scripto
 
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
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/06/windows8.1-kb3063843-x64_57199ff97cd3ff29fc3cfe398effed9d32b992b5.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2014/11/windows8.1-kb3013769-x64_333fd115b90e8ad6d8111723ac03aebd8a9d91fb.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2020/10/windows8.1-kb4578956-x64_dda3af4d84bf29cdfb666a7bede3324632d445af.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2020/10/windows8.1-kb4578953-x64_a69c4f610be6fcb6ff81d6668314c833f14cfed1.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/07/windows8.1-kb5004754-x64-ndp48_a9214826282eb39c883c6efbc3cbb0f08e29a00d.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2021/07/windows8.1-kb5004759-x64_c489c67ece5d5439965ebedc0d0cb9905975aefd.msu"))

foreach ($link in $KBArrayListDL){ 

    $whatKB = $link.Split("-")
    $KB = $whatKB[1]

    (New-Object System.Net.WebClient).DownloadFile($link, "$SourceFolder$KB.msu")

    }


#Crete new Powershell object
$KBArrayList = New-Object -TypeName System.Collections.ArrayList 

#Mofify KB article list
# not found ,"KB4057903",KB5001088
$KBArrayList.AddRange(@( "KB3013769","KB3063843","KB3094486","KB3123245","KB5004873","KB4578956","KB4578953","KB5004754","KB5004759")) 

foreach ($KB in $KBArrayList) { Write-Output "Starting treatment for $KB"
    if (-not(Get-Hotfix -Id $KB)) { 
        Start-Process -FilePath "wusa.exe" -ArgumentList "$SourceFolder$KB.msu /quiet /norestart" -Wait } 
}
