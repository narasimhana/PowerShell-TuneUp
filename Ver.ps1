﻿$FileVersion = "Version: 0.1.5"
Clear-Host
if ($env:HOME -match "C:\\Users\\") {
    Say "Detected Windows Processing"
    Start-Sleep -S 1
    Clear-Host
    $VarFile = ($env:BASE + "\ver.tmp")
    $Filetest = Test-Path -path $VarFile
    if ($Filetest -eq $True) { Remove-Item –path $VarFile }
    [Console]::SetCursorPosition(0, 0)
    Say ""
    Say -ForegroundColor white "My Version Information $FileVersion"
    Say -ForegroundColor red "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-";
    $computerOS = (Get-CimInstance CIM_OperatingSystem)
    Say ($computerOS.caption) ($computerOS.version)
    [Console]::SetCursorPosition(0, 4)
    systeminfo /fo csv | ConvertFrom-Csv | Select-Object OS*, System*, Hotfix* | Format-List | Out-File $VarFile
    (Get-Content $VarFile) | Where-Object { $_.trim() -ne "" } | set-content $VarFile
    $lines = (Get-content $VarFile).count
    $i = 0
    $j = 1
    $p = 4
    While ($j -le $lines) {
        $read = (Get-Content $VarFile)[$i]
        if ($read -eq "") { break }
        [Console]::SetCursorPosition(0, $p)
        Say -ForegroundColor darkcyan $read
        $i++; $j++; $p++
    }
    $Filetest = Test-Path -path $VarFile
    if ($Filetest -eq $True) { Remove-Item –path $VarFile }
    return
}
else {
    Say "Detected NOT windows, not going to run here yet sorry, Exiting"
    return
}
