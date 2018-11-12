$FileVersion = "Version: 0.0.6"
$WhereTo = $args
$testpath = "D:\Development\GitHub\$Whereto"
$GoodGo = Test-Path -path $testpath
if ($goodgo -eq "$True") {
    Write-Host "Go $FileVersion Setting your location to Local $TestPath Repo"
    Set-Location $TestPath[0] + $TestPath[1] + $TestPath[2]
    Set-Location $testpath
}
else {
    Write-Host "Go $FileVersion Setting your location to Local Github Repo"
    Set-Location "D:\"
    Set-Location "D:\Development\GitHub\"
}
Write-Host "git fetch upstream"
Write-Host "git merge upstream/master"
Write-Host "git push origin"
Write-Host ""
