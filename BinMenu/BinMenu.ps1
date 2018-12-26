﻿<#
.SYNOPSIS
        BinMenu
        Created By: Dana Meli
        Created Date: August, 2018
        Last Modified Date: December 25, 2018
.DESCRIPTION
        This script is designed to create a menu of all exe files in subfolders off a set base.
        It is designed to use an ini file created Internally.
        Also has great Settings Manager, it's companion script BinSM.ps1.
.EXAMPLE
        BinMenu.ps1 -Base [<PathToAFolder>]
.NOTES
        Still under development.
#>
$FileVersion = "Version: 1.1.0"
$host.ui.RawUI.WindowTitle = "BinMenu $FileVersion on $env:USERDOMAIN"
Say (Split-Path -parent $PSCommandPath)
Set-Location (Split-Path -parent $PSCommandPath)
Function MyConfig {
    $MyConfig = (Split-Path -parent $PSCommandPath) + "\" + (Split-Path -leaf $PSCommandPath)
    $MyConfig = ($MyConfig -replace ".ps1", ".json")
    $MyConfig = $MyConfig.trimstart(" ")
    $MyConfig
}
[string]$ConfigFile = MyConfig
try {
    $Config = Get-Content $ConfigFile -Raw | ConvertFrom-Json
}
catch {
    Say -Message "The Base configuration file is missing!"
    break
}
if (!($Config)) {
    Say -Message "The Base configuration file is missing!"
    break
}
Function SpinItems {
    $si = 1
    $Sc = 20
    $Script:AddCount = 0
    While ($si -lt $sc) {
        $AddItem = "AddItem-$si"
        $Spin = ($Config.$AddItem).name
        if ($null -ne $Spin) { $Script:AddCount++; $si++ }
        else { $si = 20 }
    }
    #$Script:AddCount
}
SpinItems
[string]$Base = ($Config.basic.Base)
[string]$Editor = ($Config.basic.Editor)
[bool]$ScriptRead = ($Config.basic.ScriptRead)
[bool]$MenuAdds = ($Config.basic.MenuAdds)
[int]$SortMethod = ($Config.basic.SortMethod)
[string]$SortDir = ($Config.basic.SortDir)
if ($SortDir -eq "VERT" -and $SortMethod -eq 1) { [int]$SortMethod = 0 }
[bool]$WPosition = ($Config.basic.WPosition)
[int]$WinWidth = [int]($Config.basic.WinWidth)
[int]$WinHeight = [int]($Config.basic.WinHeight)
[int]$BuffWidth = [int]($Config.basic.BuffWidth)
[int]$BuffHeight = [int]($Config.basic.BuffHeight)
#if (!($MaxWinHeight)) { $MaxWinHeight = "50" }
#if (!($MaxWinWidth)) { $MaxWinWidth = "150" }
#if (!($MaxpWinHeight)) { $MaxpWinHeight = "60" }
#if (!($MaxpWinWidth)) { $MaxpWinWidth = "160" }
Function FlexWindow {
    $pshost = get-host
    $pswindow = $pshost.ui.rawui
    #
    $newsize = $pswindow.buffersize
    $newsize.height = [int]$BuffHeight
    $newsize.width = [int]$BuffWidth
    $pswindow.buffersize = $newsize
    #
    $newsize = $pswindow.windowsize
    $newsize.height = [int]$WinHeight
    $newsize.width = [int]$WinWidth
    $pswindow.windowsize = $newsize
    <#
    $newsize = $pswindow.maxwindowsize
    $newsize.height = [int]$MaxWinHeight
    $newsize.width = [int]$MaxWinWidth
    $pswindow.maxwindowsize = $newsize

    $newsize = $pswindow.maxphysicalwindowsize
    $newsize.height = [int]$MaxpWinHeight
    $newsize.width = [int]$MaxpWinWidth
    $pswindow.maxphysicalwindowsize = $newsize
    #>
}
if ($WPosition -eq "$True") { FlexWindow }
Function Stop {
    $Stop = Read-Host -Prompt "[Enter]"
    $Stop
}
Function Show {
    $Show = Say $Show
    $Show
}
Clear-Host
if ($Base -eq "") { [string]$Base = (Split-Path -parent $PSCommandPath) }
if ($Base.substring(($Base.length - 1)) -ne "\") { [string]$Base = ($Base + "\") }
[string]$FileINI = ($Base + "BinMenu.ini")
[string]$Filetmp = ($Base + "BinTemp.del")
$Filetest = Test-Path -path $Filetmp
if ($Filetest -eq $True) { Remove-Item –path $Filetmp }
Set-Location $Base
SpinItems
$ESC = [char]27
$Filetest = Test-Path -path $FileINI
if ($Filetest -ne $True) {
    Say "The File $FileINI is missing. We Can not continue without it."
    Say "We are going to run the INI creator function now"
    Read-Host -Prompt "[Enter to continue]"
    [bool]$NoINI = $True
    My-Maker
}
Clear-Host
$ptemp = ($Base + "*.ps1")
[int]$PCount = (get-childitem -Path $ptemp).count
[string]$NormalLine = "$ESC[91m#=====================================================================================================#$ESC[97m"
[string]$FancyLine = "$ESC[91m|$ESC[97m=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-<$ESC[96m[$ESC[41m $ESC[97mMy Bin Folder Menu $ESC[40m$ESC[96m]$ESC[97m>-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=$ESC[91m|$ESC[97m"
[string]$SpacerLine = "$ESC[91m|                                                                                                     $ESC[91m|$ESC[97m"
[string]$ProgramLine = "$ESC[91m#$ESC[96m[$ESC[33mProgram Menu$ESC[96m]$ESC[91m=======================================================================================#$ESC[97m"
[string]$Menu1Line = "$ESC[91m#$ESC[96m[$ESC[33mBuilt-in Menu$ESC[96m]$ESC[91m======================================================================================#$ESC[97m"
#[string]$ScriptLine = "$ESC[91m#$ESC[96m[$ESC[33mScripts List$ESC[96m][$ESC[33m$PCount$ESC[96m]$ESC[91m=====================================================================================#$ESC[97m"
[string]$ScriptLine = "$ESC[91m#$ESC[96m[$ESC[33mScripts List$ESC[96m]$ESC[91m=======================================================================================#$ESC[97m"
[int]$LineCount = 0
[int]$LineCount = (Get-content $FileINI).count
if ($MenuAdds -eq "$True") {
    Say "Adding MenuAdds Items"
    [int]$temp = ($LineCount / 3)
    [int]$temp2 = ($temp + 1)
    [int]$J = 1
    while ($j -le $AddCount) {
        $AddItem = "AddItem-$j"
        $k = ($Config.$AddItem).name
        $t = $(Select-String -Pattern $k $FileINI)
        if ($null -eq $t) {
            $value1 = "[" + $temp2 + "A]=" + ($Config.$AddItem).name
            (Add-Content $FileINI $value1)
            $value2 = "[" + $temp2 + "B]=" + ($Config.$AddItem).command
            (Add-Content $FileINI $value2)
            $value3 = "[" + $temp2 + "C]=" + ($Config.$AddItem).argument
            (Add-Content $FileINI $value3)
            $Temp2++
        }
        $j++
    }
}
if ($MenuAdds -ne "$False") {
    Say "Removing MenuAdds Items"
    $AddItem = "AddItem-1"
    $wow = ($Config.$AddItem).name
    if (($wow)) {
        $name = "=" + ($Config.$AddItem).name
        [int]$it = (Select-String -SimpleMatch $name $FileINI).linenumber
        if (($it)) {
            $it = ($it - 1)
            $q = 0
            While ($q -lt $it) {
                $tr = (Get-Content $FileINI)[$q]
                (Add-Content ./BinMenu.no $tr)
                $q++
            }
            Remove-Item $FileINI
            Rename-Item -Path ./BinMenu.no -NewName $FileINI
        }
    }
}
[int]$LineCount = 0
[int]$LineCount = (Get-content $FileINI).count
$temp = ($LineCount / 3)
$a = ($temp / 3)
[int]$a = [int][Math]::Ceiling($a)
[int]$temp = $a
[int]$b = ($temp * 2)
[int]$c = ($LineCount / 3)
$Row = @($a, $b, $c)
$Col = @(1, 34, 69)
[int]$pa = ($a + 3)
Clear-Host
Say $NormalLine
Say $FancyLine
Say $ProgramLine
[int]$i = 1
While ($i -le $a) { Say $SpacerLine; $i++ }
[int]$l = 3
[int]$c = 0
[int]$w = $col[0]
[int]$i = 1
[int]$work = ($LineCount / 3)
While ($i -le $work) {
    if ($i -le $work) {
        $Line = (Get-Content $FileINI)[$c]
        $moo = $line -split "="
        [Console]::SetCursorPosition($w, $l); Say -NoNewLine "$ESC[91m[$ESC[97m$i$ESC[91m]$ESC[96m" $moo[1]
    }
    if ($i -eq $Row[0]) { [int]$l = 2; [int]$w = $Col[1]  }
    if ($i -eq $Row[1]) { [int]$l = 2; [int]$w = $Col[2]  }
    $i++
    $c++
    $c++
    $c++
    $L++
}
[Console]::SetCursorPosition(0, $pa); Say $Menu1Line; Say $SpacerLine; Say $SpacerLine; Say $SpacerLine
if ($ScriptRead -eq "$True") {
    Say $ScriptLine
    $PCount = (Get-ChildItem -file $env:BASE -Filter "*.ps1").count
    [Console]::SetCursorPosition(15, ($pa + 4)); Say -NoNewLine "$ESC[96m[$ESC[33m$PCount$ESC[96m]$ESC[91m"
    [Console]::SetCursorPosition(0, ($pa + 5))
}
else { Say $NormalLine }
[int]$pa = ($pa + 5)
[Console]::SetCursorPosition(0, $pa)
[int]$l = ($pa - 4)
$d = @("A", "B", "C", "D", "E", "F", "G", "Z", "Q")
$f = @("Run an EXE directly", "Reload BinMenu", "Run INI Maker", "Run a PowerShell console", "System Information", "Run VS Code (New IDE)", "Run a PS1 script", "Run Settings Manager", "Quit BinMenu")
[int]$w = $Col[0]
[int]$c = 0
while ($c -le 8) {
    [Console]::SetCursorPosition($w, $l)
    [string]$tmp = $d[$c]
    Say -NoNewLine "$ESC[91m[$ESC[97m$tmp$ESC[91m]$ESC[95m" $f[$c]
    if ($c -eq 2) { [int]$l = ($l - 3); [int]$w = $Col[1] }
    if ($c -eq 5) { [int]$l = ($l - 3); [int]$w = $Col[2] }
    $l++
    $c++
}
[Console]::SetCursorPosition(0, $pa)
if ($scriptRead -eq "$True") {
    $cmd1 = "$ESC[92m[$ESC[97m"
    $cmd2 = "$ESC[92m]"
    Get-ChildItem -file $Base -Filter "*.ps1" | ForEach-Object { [string]$_.name -Replace ".ps1", ""} | Sort-Object | ForEach-Object { $cmd1 + $_ + $cmd2 } |  Out-File $Filetmp
    [int]$roll = @(Get-Content -Path $Filetmp).Count
    $roll--
    [int]$w = 0
    [int]$l = $pa
    [int]$i = 1
    [Console]::SetCursorPosition($w, $l)
    [int]$i = 0
    [int]$w = $col[0]
    [int]$t = 0
    $MaxLine = 95
    $c = 0
    [Console]::SetCursorPosition($w, $pa)
    while ($i -lt $roll) {
        $UserScripts = $null
        while ($c -lt $MaxLine) {
            $LineR = (Get-Content $Filetmp)[$i]
            $c = ($c + $LineR.length)
            $c = ($c - 15)
            if ($c -lt $MaxLine) { $UserScripts = $UserScripts + $LineR; $i++ }
            else { $c = $MaxLine }
            if ($i -eq $roll) { $c = $MaxLine }
        }
        [Console]::SetCursorPosition(0, $l); Say -NoNewLine "$ESC[91m|"
        [Console]::SetCursorPosition($w, $l); Say -NoNewLine "$ESC[91m[$ESC[92mPS1$ESC[91m]$ESC[92m" $UserScripts
        [Console]::SetCursorPosition(102, $l); Say -NoNewLine "$ESC[91m|"
        $l++; $t++; $c = 0
    }
    $WinHeight = ($WinHeight + $t)
    $BuffHeight = ($BuffHeight + $t)
}
$pa = $l
$Filetest = Test-Path -path $Filetmp
if ($Filetest -eq $True) { Remove-Item –path $Filetmp }
[int]$w = 0
#if ($ScriptRead -eq $True) {
[Console]::SetCursorPosition(0, $pa); Say $NormalLine
$pa++
#}
$FixLine
$BuffHeight = ($pa + 4)
$WinHeight = ($pa + 4)
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
Function FixLine {
    Say -NoNewLine "                                                                                                       "
    [Console]::SetCursorPosition(0, $pa); Say -NoNewLine "                                                                                                       "
    [Console]::SetCursorPosition(0, 0); Say -NoNewLine ""
    [Console]::SetCursorPosition(0, ($pa + 1)); Say -NoNewLine "                                                                                                       "
    [Console]::SetCursorPosition(0, 0); Say -NoNewLine ""
    [Console]::SetCursorPosition(0, ($pa + 2)); Say -NoNewLine "                                                                                                       "
    [Console]::SetCursorPosition(0, $pa); Say -NoNewLine "                                                                                                       "
    [Console]::SetCursorPosition(0, $pa)
}
FixLine
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal] $identity
if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    [Console]::SetCursorPosition(78, 1); Say -NoNewLine "$ESC[96m[$ESC[33mAdministrator$ESC[96m]$ESC[91m"
    [Console]::SetCursorPosition(0, $pa)
}
[Console]::SetCursorPosition(10, 1); Say -NoNewLine "$ESC[96m[$ESC[33m$FileVersion$ESC[36m]$ESC[91m"
[Console]::SetCursorPosition(0, $pa)
Fixline
$menu = "$ESC[91m[$ESC[97mMake A Selection$ESC[91m]$ESC[97m"
Function MyMaker {
    Clear-Host
    $Filetest = Test-Path -path $FileINI
    if ($Filetest -eq $True) { Remove-Item –path $FileINI }
    $FileTXT = ($Base + "BinMenu.txt")
    $Filetest = Test-Path -path $FileTXT
    if ($Filetest -eq $True) { Remove-Item –path $FileTXT }
    $FileCSv = ($Base + "BinMenu.csv")
    $Filetest = Test-Path -path $FileCSV
    if ($Filetest -eq $True) { Remove-Item –path $FileCSV }
    Say $fileVersion "Reading in directory" $Base
    Get-ChildItem -Path $Base -Recurse -Include "*.exe" | Select-Object `
    @{ n = 'Foldername'; e = { ($_.PSPath -split '[\\]')[3] } } ,
    Name,
    FullName ` | Export-Csv -path $FileTXT -NoTypeInformation
    Say "Writing raw files info, Reread and sorting file names, Exporting all file names"
    Import-Csv -Path $FileTXT | Sort-Object -Property "Foldername" | Export-Csv -NoTypeInformation $FileCSV
    $writer = [System.IO.file]::CreateText($FileINI)
    [int]$i = 1
    try {
        Import-Csv $FileCSV | Foreach-Object {
            $tmpname = [Regex]::Escape($_.fullname)
            if ($tmpname -match "git" -and $tmpname -ne "D:\\bin\\git\\bin\\bash\.exe") { return }
            if ($tmpname -match "wscc" -and $tmpname -ne "D:\\bin\\wscc\\wscc\.exe") { return }
            $tmpname = $_.name -replace "\\", ""
            if ($tmpname -eq "Totalcmd64.exe") { $tmpname = "Total Commander.exe" }
            $NameFix = $tmpname
            $NameFix = $NameFix.tolower()
            $NameFix = $NameFix.substring(0, 1).toupper() + $NameFix.substring(1)
            $Decidep = "Add $NameFix ? (Y)es-(N)o-[Enter is No]"
            Say "["$_.fullname"]"
            $Decide = Read-Host -Prompt $Decidep
            if ($Decide -eq "Y") {
                $NameFix = $NameFix.replace(".exe", "")
                Say "Adding to Menu: " $NameFix
                $Writer.WriteLine("[" + $i + "A]=" + $NameFix)
                $Writer.WriteLine("[" + $i + "B]=" + $_.fullname)
                $Writer.WriteLine("[" + $i + "C]=")
                $i++
                return
            }
            else { return }
        }
    }
    finally { $writer.close() }
    Clear-Host
    Say "Done Writing EXE files to the Menu ini."
    Say ""
    $Filetest = Test-Path -path $FileTXT
    if ($Filetest -eq $True) { Remove-Item –path $FileTXT }
    $Filetest = Test-Path -path $FileCSV
    if ($Filetest -eq $True) { Remove-Item –path $FileCSV }
    Clear-Host
    Start-Process "pwsh.exe" -ArgumentList "$PSScriptRoot\BinMenu.ps1" -Verb RunAs
    return
}
if ($NoINI) { [bool]$NoINI = $False; MyMaker }
Function TheCommand {
    Param([string]$IntCom, [string]$Argue)
    if (!($IntCom)) {
        Write-Error "Error In Sent Param " + $IntCom
        return
    }
    [string]$moo = (Select-String -SimpleMatch $IntCom $FileINI)
    $cow = $moo -split "="
    if ((Get-Item $cow[1]) -is [System.IO.DirectoryInfo] -eq $True) { Invoke-Item $cow[1] }
    else {
        [string]$car = (Select-String -SimpleMatch $Argue $FileINI)
        $bus = $car -split "="
        $MakeMove = split-path $cow[1]
        if ($bus[1] -ne "None") { Start-Process $cow[1] -ArgumentList $bus[1] -Verb RunAs -WorkingDirectory $MakeMove }
        else { Start-Process $cow[1] -Verb RunAs -WorkingDirectory $MakeMove }
    }
}
if ($WPosition -eq "$True") { FlexWindow }
$menuPrompt += $menu
While (1) {
    $ans = Read-Host -Prompt $menuprompt
    [Int32]$OutNumber = $null
    if ([Int32]::TryParse($ans, [ref]$OutNumber)) {
        FixLine
        TheCommand -IntCom ("[" + $ans + "B]") -Argue ("[" + $ans + "C]")
        FixLine
    }
    else {
        if ($ans -eq "A") {
            FixLine
            [string]$cmd = Read-Host -Prompt "$ESC[91m[$ESC[97mWhat EXE to run? $ESC[91m($ESC[97mEnter to Cancel$ESC[91m)]$ESC[97m"
            if ($cmd -ne '') {
                FixLine
                $cmd1 = Read-Host -Prompt "$ESC[91m[$ESC[97mWant any parameters? $ESC[91m($ESC[97mEnter for none$ESC[91m)]$ESC[97m"
                [string]$cmd = $cmd -replace ".ps1", ""
                [string]$tcmd = ".exe"
                [string]$cmd = "$cmd$tcmd"
                #[string]$cmd = "$cmd $cmd1"
                start-Process $cmd -Argumentlist $cmd1 -Verb RunAs
                FixLine
            }
            FixLine
        }
        elseif ($ans -eq "B") { Start-Process "pwsh.exe" -ArgumentList "$PSScriptRoot\BinMenu.ps1" -Verb RunAs; Clear-Host; return }
        elseif ($ans -eq "C") { FixLine; MyMaker; Clear-Host; Start-Process "pwsh.exe" "$PSScriptRoot\BinMenu.ps1" -Verb RunAs; Clear-Host; return }
        elseif ($ans -eq "D") { FixLine; Start-Process "pwsh.exe" -Verb RunAs }
        elseif ($ans -eq "E") { FixLine; Start-Process "pwsh.exe" -ArguMentList "$PSScriptRoot\Get-SysInfo.ps1" -Verb RunAs; FixLine; FixLine }
        elseif ($ans -eq "F") { FixLine; Start-Process "C:\Program Files\Microsoft VS Code\Code.exe" -Verb RunAs; FixLine }
        elseif ($ans -eq "G") {
            FixLine
            [string]$cmd = Read-Host -Prompt "$ESC[91m[$ESC[97mWhat script to run? $ESC[91m($ESC[97mEnter to Cancel$ESC[91m)]$ESC[97m"
            if ($cmd -ne '') {
                FixLine
                $OneShot = "NO"
                if ($cmd -eq "reboot") { $OneShot = "YES" }
                if ($cmd -eq "clearlogs") { $OneShot = "YES" }
                if ($cmd -eq "Do-Ghost") { $OneShot = "YES" }
                if ($cmd -eq "Get-SysInfo") { $OneShot = "YES" }
                if ($OneShot -eq "YES") { $cmd = "$cmd" + ".ps1"; start-Process "pwsh.exe" -Argumentlist $cmd -Verb RunAs; FixLine }
                else {
                    $cmd1 = Read-Host -Prompt "$ESC[91m[$ESC[97mWant any parameters? $ESC[91m($ESC[97mEnter for none$ESC[91m)]$ESC[97m"
                    [string]$cmd = $cmd -replace ".ps1", ""
                    [string]$tcmd = ".ps1"
                    [string]$cmd = "$cmd$tcmd"
                    [string]$cmd = "$cmd $cmd1"
                    start-Process "pwsh.exe" -Argumentlist $cmd -Verb RunAs
                    FixLine
                }
            }
            FixLine
        }
        elseif ($ans -eq "Q") {
            $Filetest = Test-Path -path $Filetmp
            if ($Filetest -eq $True) { Remove-Item –path $Filetmp }
            Clear-Host
            Return 
        }
        elseif ($ans -eq "R") { Start-Process "pwsh.exe" -ArgumentList "$PSScriptRoot\BinMenu.ps1" -Verb RunAs; Clear-Host; return }
        elseif ($ans -eq "Z") { Start-Process "pwsh.exe" -ArgumentList "$PSScriptRoot\BinSM.ps1" -Verb RunAs; FixLine }
        else {
            FixLine
            Say -NoNewLine "Sorry, that is not an option. Feel free to try again."
            Start-Sleep -Milliseconds 400
            FixLine
            if ($WPosition -eq "$True") { FlexWindow }
        }
    }
}
$Filetest = Test-Path -path $Filetmp
if ($Filetest -eq $True) { Remove-Item –path $Filetmp }
