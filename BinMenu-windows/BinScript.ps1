$FileVersion = "Version: 2.2.8"
$host.ui.RawUI.WindowTitle = ("BinMenu Script Window " + $FileVersion)
$Base = $env:Base
if (!($Base)) { Set-Variable -Name Base -Value "D:\bin" -Scope Global }
if (!($Base)) { Say -ForeGroundColor RED "SET Base environment variable in your Setup, profiles or in this Script. This shit uses that!"; break }
Function MyConfig {
    $MyConfig = ($Base + "\BinMenu.json")
    $MyConfig
}
[string]$ConfigFile = MyConfig
Say "Reading from config files."
try { $Config = Get-Content $ConfigFile -Raw | ConvertFrom-Json }
catch { Say -ForeGroundColor RED "The Base configuration file is missing!"; break }
if (!($Config)) {
    Say -ForeGroundColor RED "The BinMenu.json configuration file is missing!"
    Say -ForeGroundColor RED "You need to create or edit BinMenu.json in Base directory"
    break
}
[string]$Filetmp = ($Base + "\BinTemp.del")
Set-Location $Base.substring(0, 3)
Set-Location $Base
[int]$POSX = ($Config.basic.WinSX)
if (!($POSX)) { $POSX = 0 }
[int]$POSY = ($Config.basic.WinSY)
if (!($POSY)) { $POSY = 0 }
$ScriptName = "BinScript"
if (!($WinWidth)) {
    $WinWidth = 166
    $BuffWidth = $WinWidth
}
if (!($WinHeight)) {
    $WinHeight = 100
    $BuffHeight = $WinHeight
}
Function FlexWindow {
    $SaveError = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    $pshost = Get-Host
    $pswindow = $pshost.ui.rawui
    $newsize = $pswindow.buffersize
    [int]$newsize.height = $BuffHeight
    [int]$newsize.width = $BuffWidth
    $pswindow.buffersize = $newsize
    $newsize = $pswindow.windowsize
    [int]$newsize.height = $WinHeight
    [int]$newsize.width = $WinWidth
    $pswindow.windowsize = $newsize
    $ErrorActionPreference = $SaveError
}
FlexWindow
Function FixLine {
    Say "                                                                                                       "
    [Console]::SetCursorPosition(0, $pp); Say "                                                                                                       "
    [Console]::SetCursorPosition(0, 0); Say ""
    [Console]::SetCursorPosition(0, ($pp + 1)); Say "                                                                                                       "
    [Console]::SetCursorPosition(0, 0); Say ""
    [Console]::SetCursorPosition(0, ($pp + 2)); Say "                                                                                                       "
    [Console]::SetCursorPosition(0, $pp); Say "                                                                                                       "
    [Console]::SetCursorPosition(0, $pp)
}
$PosTest = Test-Path -path ($Base + "\Put-WinPosition.ps1")
While (1) {
    if (($PosTest)) { Put-WinPosition -WinName $host.ui.RawUI.WindowTitle -WinX $POSX -WinY $POSY | Out-Null }
    Clear-Host
    FlexWindow
    [int]$pp = 0
    [int]$LineCount = 0
    [int]$LineCount = (Get-Content $Filetmp).count
    [int]$Work = $LineCount
    $tmp = ($Work / 5)
    $tmp = [int][Math]::Ceiling($tmp)
    [int]$PMenu = $tmp
    [int]$a = $tmp
    [int]$b = ($tmp + $a)
    [int]$c = ($tmp + $b)
    [int]$d = ($tmp + $c)
    [int]$e = $work
    [int]$e = ($work - $d)
    $Row = @($a, $b, $c, $d, $e)
    $Col = @(1, 34, 67, 100, 133)
    [int]$pp = ($PMenu)
    [Console]::SetCursorPosition(0, $pp)
    $WinHeight = ($pp + 4)
    $BuffHeight = $WinHeight
    FlexWindow
    [Console]::SetCursorPosition(0, $pp)
    Say $NormalLine
    [int]$l = 0
    [int]$w = $col[0]
    [int]$i = 1
    [Int]$num = 1
    FlexWindow
    $Reader = New-Object IO.StreamReader ($filetmp, [Text.Encoding]::UTF8, $true, 4MB)
    While ($i -le $Work) {
        $Line = $Reader.ReadLine()
        if (($read.EndOfStream)) { $i = $Work; $Reader.close() }
        [Console]::SetCursorPosition($w, $l)
        WC "~DARKRED~[~~WHITE~$Num~~DARKRED~]~ ~GREEN~$Line~"
        if ($i -eq $Row[0]) { [int]$l = -1; [int]$w = $Col[1] }
        if ($i -eq $Row[1]) { [int]$l = -1; [int]$w = $Col[2] }
        if ($i -eq $Row[2]) { [int]$l = -1; [int]$w = $Col[3] }
        if ($i -eq $Row[3]) { [int]$l = -1; [int]$w = $Col[4] }
        $i++
        $L++
        $num++
    }
    $Reader.close()
    [Console]::SetCursorPosition(0, $pp)
    $ans = $($MenuPrompt = WCP "~DARKCYAN~[~~DARKYELLOW~Select A Number ~~DARKRED~(~~WHITE~R~~DARKRED~)~~DARKYELLOW~eload or ~~DARKRED~(~~WHITE~Q~~DARKRED~)~~DARKYELLOW~uit~DARKCYAN~]~~WHITE~: "; Read-Host -Prompt $menuPrompt)
    [Int32]$OutNumber = $null
    if ([Int32]::TryParse($ans, [ref]$OutNumber)) {
        FixLine
        $MaxYes = (Get-Content $Filetmp).count
        if ($OutNumber -gt 0 -and $OutNumber -le $MaxYes) {
            $OutNumber = ($OutNumber - 1)
            $Read = (Get-Content $Filetmp)[$OutNumber]
            $cmd1 = $Read
            $cmd2 = $($MenuPrompt = WCP "~DARKCYAN~[~~DARKYELLOW~Enter Any Parameters For Script~~DARKCYAN~]~~WHITE~: "; Read-Host -Prompt $menuPrompt)
            FixLine
            Start-Process pwsh.exe -ArgumentList $cmd1$cmd2 -Verb RunAs
            FixLine
        }
    }
    elseif ($ans -eq "Q") {
        $Filetest = Test-Path -path $Filetmp
        if (($Filetest)) { Remove-Item �path $Filetmp -Force }
        Clear-Host
        Return
    }
    elseif ($ans -eq "R") {
        Start-Process "pwsh.exe" -ArgumentList ($Base + "\BinScript.ps1")
        exit
    }
    else {
        FixLine
        [Console]::SetCursorPosition(0, $pp)
        Say -NoNewLine "Sorry, that is not an option. Feel free to try again."
        Start-Sleep -Milliseconds 500
        FixLine
        FlexWindow
        if (($PosTest)) { Put-WinPosition -WinName $host.ui.RawUI.WindowTitle -WinX $POSX -WinY $POSY | Out-Null }
    }
}
$Filetest = Test-Path -path $Filetmp
if (($Filetest)) { Remove-Item -path $Filetmp }
