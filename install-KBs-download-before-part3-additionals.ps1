$start_time = Get-Date


# Determine script location for PowerShell
$ScriptDir = (Get-Location).Path
 
Write-Host "Current script directory is $ScriptDir"

#Source folder
$SourceFolder = "$ScriptDir\downloadz-part3\"
mkdir $SourceFolder

#Create new Powershell object
$KBArrayListDL = New-Object -TypeName System.Collections.ArrayList 

#Download KB list
$KBArrayListDL.AddRange(@( 
    "http://download.windowsupdate.com/d/msdownload/update/software/ftpk/2019/12/windows8.1-kb4486105-x64_1cba02a8aec5034da82cb2dca744648bc4a4eaef.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2017/07/windows8.1-kb4033428-x64_6a48934e05183527ce3d476a15b0285d71781e72.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/08/windows8.1-kb3179574-x64_f0a5e2ff991aec5e6978aa808f287f1b21195d6e.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/07/windows8.1-kb3172614-x64_e41365e643b98ab745c21dba17d1d3b6bb73cfcc.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/04/windows8.1-kb3134179-x64_cfd08146b4ba162f48a5a45aa53b36d90af439ee.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/04/windows8.1-kb3103709-v2-x64_3fe377dbcf3dd2fac9916e4bb741f490e105bafe.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/04/windows8.1-kb3145432-x64_0fa4848dcd80beb574452ecc7e0088606feb4994.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/04/windows8.1-kb3149157-x64_7a5b50473186d3ccc6665c8d658c59287a38eaee.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/04/windows8.1-kb3145384-x64_a65180d3f2085fec112b9932580a7ecbf982463a.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/04/windows8.1-kb3146751-x64_e4ef9c374e5474289e69951dd2a5d8745730b97a.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/04/windows8.1-kb3103616-x64_47c83b90c4d58df92b1cde6eea747a424eafae96.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/04/windows8.1-kb3146604-x64_f435966967d258fc468c497a3e89b2b85e689ff1.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/03/windows8.1-kb3123245-x64_61c7ff67a72622b596bf7a7a2162cb19c709baff.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/03/windows8.1-kb3100473-x64_ee270dd02c0a47ba7096f5ec954115168b0963b2.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/03/windows8.1-kb3140234-x64_6eb46eaca390621212e83d8c229155db9f949b86.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/03/windows8.1-kb3133690-x64_97414f60779d3d1f15ca1779bd27fd1762bfaad5.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/03/windows8.1-kb3115224-v2-x64_1afbc3e96ec234b79cf559344285e16741d49a4b.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/03/windows8.1-kb3109976-x64_e935fd759ccf6cdec35497ff946092217772f5f8.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/03/windows8.1-kb3140219-x64_cad58ff88e2ee39c56fc8dca2e97cc0e19519398.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/03/windows8.1-kb3137728-x64_b19020cd59959ebee66d916d31b4992143029d54.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/03/windows8.1-kb3147071-x64_1c0f181c6c3b716477b00d6946f750b81fd0766c.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/02/windows8.1-kb3121261-v2-x64_9f37a3954e0827aa581cb55f4ee565197f8fa937.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/01/windows8.1-kb3102429-v2-x64_0336f192bd7bfdb01930ba46e6fdcf61b28220ed.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/11/windows8.1-kb3103696-x64_d388e21d1d1dde02e075b9759ebc11289703dbf0.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/10/windows8.1-kb3078405-v2-x64_8a6bd4463b6bac96b0ac46ff2787c677044ec8c3.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/10/windows8.1-kb3094486-x64_8e0a16b668f275e088ad3508f4a7cfe76b0757ec.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2015/10/windows8.1-kb3084905-v2-x64_b94fe16f2f20a0d0fda7a7bed0bd3f112674680b.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/08/windows8.1-kb3080149-x64_4254355747ba7cf6974bcfe27c4c34a042e3b07e.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/06/windows8.1-kb3060681-x64_3d93a342294d6182c3bc9b0e91a7e740c3b1f372.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/06/windows8.1-kb3054203-x64_7f2ecfc805f854a7b916e4c8ddb82e39a34d7692.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/06/windows8.1-kb3060793-x64_ea4b15443766fdc39c31822b0ad9dcd9dac26975.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/06/windows8.1-kb3013791-x64_3f60476f80959e9b928ae97101a8376a3a53ecc7.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/05/windows8.1-kb3054464-x64_aba4f7bf2ac27914ee6ed8e4534db8c17c551782.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/04/windows8.1-kb3054169-x64_0c13f211ca4f9c160793b35ce12c347031fbf18f.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/03/windows8.1-kb3012702-x64_082e460ce711abe34a624c1bdb083c2827eef524.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2014/07/windows8.1-kb2938066-x64_902cc8c11e361ae6513cabd156ad74ab395db377.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2014/11/windows8.1-kb3013769-x64_333fd115b90e8ad6d8111723ac03aebd8a9d91fb.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/06/windows8.1-kb3063843-x64_57199ff97cd3ff29fc3cfe398effed9d32b992b5.msu"))

foreach ($link in $KBArrayListDL){ 

    $whatKB = $link.Split("-")
    $KB = $whatKB[1]

    (New-Object System.Net.WebClient).DownloadFile($link, "$SourceFolder$KB.msu")

    }


#Crete new Powershell object
$KBArrayList = New-Object -TypeName System.Collections.ArrayList 

#Mofify KB article list
# not found ,"KB3037623"
$KBArrayList.AddRange(@( "KB4486105","KB4033428","KB3179574","KB3172614","KB3134179","KB3103709","KB3145432","KB3149157","KB3145384","KB3146751","KB3103616","KB3146604","KB312245","KB3100473","KB3140234","KB3133690","KB3115224","KB3109976","KB3140219","KB3137728","KB3147071","KB3121261","KB3102429","KB3103696","KB3078405","B3094486","KB3084905","KB3080149","KB3060681","KB3054203","KB3060793","KB3013791","KB3054464","KB3054169","KB3012702","KB2938066","KB3013769","KB306383")) 

foreach ($KB in $KBArrayList) { Write-Output "Starting treatment for $KB"
    if (-not(Get-Hotfix -Id $KB)) { 
        Start-Process -FilePath "wusa.exe" -ArgumentList "$SourceFolder$KB.msu /quiet /norestart" -Wait } 
} 


Write-Output "Time taken: $((Get-Date).Subtract($start_time))"
