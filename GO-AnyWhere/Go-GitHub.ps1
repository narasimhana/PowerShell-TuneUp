$FileVersion = "Version: 0.0.5"
$WhereTo = $args
$testpath = "D:\Development\GitHub\$Whereto"
$GoodGo = Test-Path -path $testpath
if ($goodgo -eq "$True") {
    Write-Host "Go $FileVersion Setting your location to Local $TestPath Repo"
    Set-Location "D:\"
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