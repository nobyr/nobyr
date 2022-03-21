$veryFolder = "run-2-ok"
$containingFolder = "C:\Users\Administrateur\Desktop\"
$scriptFolder = $containingFolder + $veryFolder
if (!(Get-Item $scriptFolder -ea ignore)) { mkdir $scriptFolder }
