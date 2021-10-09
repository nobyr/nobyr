$start_time = Get-Date


# Determine script location for PowerShell
$ScriptDir = (Get-Location).Path
 
Write-Host "Current script directory is $ScriptDir"

#Source folder
$SourceFolder = "$ScriptDir\downloadz\"


#Create new Powershell object
$KBArrayListDL = New-Object -TypeName System.Collections.ArrayList 

#Download KB list
$KBArrayListDL.AddRange(@( 
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2014/08/windows8.1-kb2894856-v2-x64_929d16faacd7b226e8f06448bf3c9eeac8573967.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2014/08/windows8.1-kb2977765-x64_c83e14f82731ec26b428170304a3dbed3e3aa8ef.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2014/09/windows8.1-kb2978041-x64_93d7dd68c7487670c0ab4d5eb154a0ef5e40a306.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2014/10/windows8.1-kb2978126-x64_2d0507307c8873fefbfd0d236c2956f7bf03eaf8.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2015/01/windows8.1-kb3000483-x64_4ce1d89ccbd1e1794a407b9e10106c0af08d2e17.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/crup/2014/11/windows8.1-kb3008242-x64_969750d7a771e21812b8cc27a7432ffbec32f0df.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2015/04/windows8.1-kb3023222-x64_5433c077e43e2906b745d5f25dd8a08aad436091.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/01/windows8.1-kb3023266-x64_a799d527b608a6e94138b0a93a6255748c09049a.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/crup/2015/01/windows8.1-kb3031044-x64_f2fd2564014053504204e41f2d3417b4213eeb5c.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2015/04/windows8.1-kb3032663-x64_fc7a9b4fb72aa9c9f852063b849087728f5c789d.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2015/03/windows8.1-kb3037579-x64_c9700eec7018ec6f8adab1b1487ccc0e2eb08fef.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/updt/2015/03/windows8.1-kb3042085-v2-x64_438dacab2be16a8c080b86c66f4958de00557f7f.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/crup/2015/03/windows8.1-kb3044374-x64_5a77e58ce3f77d967c1a7e0c30877bd193b08d6c.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/03/windows8.1-kb3045685-x64_e34f6a8551808eee89b2e4c58388d746ca1fb1eb.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2015/03/windows8.1-kb3045999-x64_24d58ec9a3369bf798cb8353d8d6055107966c06.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/07/windows8.1-kb3046017-x64_cfd784ae9e40bcd30adf46d822bf48a601b218cb.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/05/windows8.1-kb3059317-x64_4271d612ef3f3c57904458748faad85f0c56dad0.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/07/windows8.1-kb3071756-x64_481757325634850fec6798a4a7dcf67139e72aac.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/08/windows8.1-kb3074228-x64_655cbb800039e5a20675c75f3234a49c21b5ab8b.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/08/windows8.1-kb3074548-x64_37873ea0e2279a03965b5674e6cc7258228129fd.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/08/windows8.1-kb3077715-x64_69d5d96d3717c71b06a3c4ea4a8840d0af95acbe.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2015/10/windows8.1-kb3081320-x64_d6e34f82e20d9efa19ab0ae7a938f8d80c01416e.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/08/windows8.1-kb3082089-x64_6fa26cce09c1c0a7e6d5e1c6d907d6790712ab19.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/08/windows8.1-kb3084135-x64_631d159c59f993b29db94c79a06cd1fedcad3c4e.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2015/10/windows8.1-kb3092601-x64_10b03efea03d95d108d7948946a58868d2442c86.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2015/10/windows8.1-kb3097997-x64_aaf2cab13c492cc688ca6f0cc31bf3ee623493d0.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2015/10/windows8.1-kb3098779-x64_c0320c7dc1040d4b837c9ae643cc5a35296a1441.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2015/10/windows8.1-kb3102939-x64_194894aea47349e55b195acef50b56930d4540b2.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2016/01/windows8.1-kb3126041-x64_79d4ac69a6d6feeabf12410b1e815850c0c0ca81.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2016/01/windows8.1-kb3126434-x64_305a6f14ffc6bbf55be58d78d2dae6123fe1bc32.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2016/01/windows8.1-kb3126587-x64_aecaabb9db72f7508bf0f53f265449cb54507d1b.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2016/01/windows8.1-kb3126593-x64_54c6eaadc4b5ea5ca79caab1f8895557ed662d2b.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2016/02/windows8.1-kb3139398-x64_da8a470a7629685a4c67eec13e1509c338acbd24.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2016/02/windows8.1-kb3139914-x64_c0ed0734cde5d1eddcc7ad0632eb539e766a9e93.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2016/03/windows8.1-kb3146723-x64_5aae2a7642e87b2881d7337ef736eaee679f907a.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2016/05/windows8.1-kb3159398-x64_f8e8f71aa74a71071d24c90af9ff3f5e2a7f75b8.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2016/05/windows8.1-kb3161949-x64_303f894a71fad84f147e1ee715f8c60ddfc752d7.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2016/07/windows8.1-kb3172729-x64_e8003822a7ef4705cbb65623b72fd3cec73fe222.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/crup/2016/06/windows8.1-kb3173424-x64_9a1c9e0082978d92abee71f2cfed5e0f4b6ce85c.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2016/08/windows8.1-kb3175024-x64_11e1173ef77cce7bfd78187417177970b023a2b2.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2017/11/windows8.1-kb4054519-x64_ad78da956d88ae3cd98982c11730240668c0e93f.msu",
    "http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/04/windows8.1-kb5001403-x64_7f15c4b281f38d43475abb785a32dbaf0355bad5.msu",
    "http://download.windowsupdate.com/c/msdownload/update/software/secu/2021/09/windows8.1-kb5005613-x64_52d05012aa71c9d14f218559dba1baa82e4515c9.msu"))

foreach ($link in $KBArrayListDL){ 

    $whatKB = $link.Split("-")
    $KB = whatKB[1]

    (New-Object System.Net.WebClient).DownloadFile($link, "$SourceFolder$KB.msu")

    }


#Crete new Powershell object
$KBArrayList = New-Object -TypeName System.Collections.ArrayList 

#Mofify KB article list
# not found ,"KB3037623"
# info 3173729 = "KB3173424","KB3173729"
$KBArrayList.AddRange(@( "KB2894856","KB2977765","KB2978041","KB2978126","KB3008242","KB3023266","KB3031044","KB3000483","KB3042085","KB3045999","KB3045685","KB3037579","KB3032663","KB3023222","KB3059317","KB3044374","KB3046017","KB3071756","KB3082089","KB3084135","KB3074228","KB3074548","KB3077715","KB3081320","KB3102939","KB3092601","KB3098779","KB3097997","KB3126593","KB3126041","KB3126434","KB3126587","KB3139398","KB3139914","KB3146723","KB3159398","KB3161949","KB3173424","KB3173729","KB3175024","KB4054519","KB5001403","KB5005613")) 

foreach ($KB in $KBArrayList) { 
    if (-not(Get-Hotfix -Id $KB)) { 
        Start-Process -FilePath "wusa.exe" -ArgumentList "$SourceFolder$KB.msu /quiet /norestart" -Wait } 
} 


Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
