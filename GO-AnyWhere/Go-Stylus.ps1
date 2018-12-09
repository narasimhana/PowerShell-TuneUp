$FileVersion = "Version: 0.0.7"
Write-Host "Go $FileVersion Setting your location to Github\Stylus"
Set-Location "D:\"
Set-Location "D:\Development\GitHub\stylus"
Write-Host ""
#Write-Host ""
#Write-Host "delete the last two closing curly brackets and add:"
#Write-Host '},'
#Write-Host '"applications": {'
#Write-Host '    "gecko": {'
#Write-Host '        "id": " {7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}"'
#Write-Host '    }'
#Write-Host '  }'
#Write-Host '}'
#Write-Host ""
#Write-Host ""
Write-Host "git fetch upstream"
Write-Host "git merge upstream/master"
Write-Host "git push origin"
Write-Host ""
Write-Host "then:"
Write-Host "npm install"
Write-Host "npm run update"
Write-Host "npm run zip"
Write-Host ""
$ans = $null
$ans = Read-Host -Prompt "Do you want to run Git? [Enter is NO (Y)es]"
if ($ans -eq "Y") {
    Write-Host "git fetch upstream" -Verbose
    git fetch upstream
    Start-Sleep -s 2
    Write-Host "git merge upstream/master" -Verbose
    git merge upstream/master
    Start-Sleep -s 2
    Write-Host "git push origin" -Verbose
    git push origin
}
$ans = $null
$ans = Read-Host -Prompt "Do you want to run NPM? [Enter is NO (Y)es]"
if ($ans -eq "Y") {
    Write-Host "npm install" -Verbose
    npm install
    Start-Sleep -s 2
    Write-Host "npm run update" -Verbose
    npm run update
    Start-Sleep -s 2
    Write-Host "npm run zip" -Verbose
    npm run zip
}
