$FileVersion = "Version: 0.0.6"
$MyArgs = $args
Write-Host "Go $FileVersion Setting your location to ConEmu"
Write-Host "You Have two (2) ComEnu Repos. One forked on Github ... Opening"
Write-Host "The Do the following [Go-ComEmu VS] to open the Visual Studios repo in a console."
if ($MyArgs -eq "VS") {
    Set-Location "C:\"
    Set-Location "C:\Users\Dana\AppData\GitRepo\ConEmu"
}
Else {
    Set-Location "D:\"
    Set-Location "D:\Development\GitHub\ConEmu"
    Write-Host ""
    Start-Sleep -s 5
    Write-Host "git fetch upstream" -Verbose
    git fetch upstream
    Start-Sleep -s 5
    Write-Host "git merge upstream/master" -Verbose
    git merge upstream/master
    Start-Sleep -s 5
    Write-Host "git push origin" -Verbose
    git push origin
}