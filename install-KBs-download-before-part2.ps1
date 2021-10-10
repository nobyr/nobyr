# Determine script location for PowerShell
$ScriptDir = C:\scripto
 
Write-Host "Current script directory is $ScriptDir"

#Source folder
$SourceFolder = "$ScriptDir\downloadz-part2\"
mkdir $SourceFolder

#Create new Powershell object
$KBArrayListDL = New-Object -TypeName System.Collections.ArrayList 

#Download KB list
$KBArrayListDL.AddRange(@( 
    "http://download.windowsupdate.com/d/msdownload/update/software/crup/2014/02/windows8.1-kb2919355-x64_e6f4da4d33564419065a7370865faacf9b40ff72.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2014/07/windows8.1-kb2967917-x64_f3c76e9b2c6fd1b090d191b78de1189844b040f8.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2014/11/windows8.1-kb3000850-x64_94a08e535c004b860e9434fbd1e2d293583620a2.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/09/windows8.1-kb3042058-x64_c73bfac2ad93aed131627e7482bacbd89d0a0850.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2020/06/windows8.1-kb4535680-x64_1cd22f094d7465f7c88b958f0dfa9c7cb3304a44.msu"))

foreach ($link in $KBArrayListDL){ 

    $whatKB = $link.Split("-")
    $KB = $whatKB[1]

    (New-Object System.Net.WebClient).DownloadFile($link, "$SourceFolder$KB.msu")

    }


#Crete new Powershell object
$KBArrayList = New-Object -TypeName System.Collections.ArrayList 

#Mofify KB article list
# not found ,"KB3037623"
$KBArrayList.AddRange(@( "KB2919355","KB2967917","KB3000850","KB3042058","KB4535680")) 

foreach ($KB in $KBArrayList) { Write-Output "Starting treatment for $KB"
    if (-not(Get-Hotfix -Id $KB)) { 
        Start-Process -FilePath "wusa.exe" -ArgumentList "$SourceFolder$KB.msu /quiet /norestart" -Wait } 
}
