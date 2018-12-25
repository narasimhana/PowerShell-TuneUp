Param([bool]$loud)
<# Start-Process -Verb RunAs -FilePath "c:\Windows\System32\wevtutil.exe" -ArgumentList "el | Foreach-Object {wevtutil cl $_}" #>
$FileVersion = "Version: 0.2.2"
$host.ui.RawUI.WindowTitle = "ClearWindows Logs $FileVersion"
<# Test and if needed run as admin #>
Function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal] $identity
if (!($principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))) {
    Start-Process "pwsh.exe" -ArgumentList "$PSScriptRoot\ClearLogs.ps1" -Verb RunAs
    return
}
Clear-Host
$PShost = Get-Host
$PSWin = $PShost.ui.rawui
$PSWin.CursorSize = 0
[Console]::SetCursorPosition(0, 3); Say "Running ClearWindows Logs $FileVersion"
$ClearSet = 0
& wevtutil el | Foreach-Object { $ClearSet++ }
[Console]::SetCursorPosition(0, 4); Say "You have $ClearSet logs on this machine. Setting Up the math."
$ClearSet = ($ClearSet / 100)
$i = 0
if ($loud -eq $True) {
    [Console]::SetCursorPosition(0, 5)
    wevtutil el | Foreach-Object {
        Say "Deleting: " $_
        wevtutil cl $_
        $i++
    }
    Say -NoNewline "ClearWindows Logs Processed $i log files."
    Read-Host -Prompt "[Slap Enter to Exit]"
    return
}
else {
    wevtutil el | Foreach-Object {
        [Console]::SetCursorPosition(0, 0)
        wevtutil cl "$_"
        [Console]::SetCursorPosition(0, 0); Say -NoNewline "                                                                                                                               "
        [Console]::SetCursorPosition(0, 1); Say -NoNewline "                                                                                                                               "
        $i++
        $p = ($i / $ClearSet)
        $p = [int][Math]::Ceiling($p)
        if ($p -gt 100 ) { $p = 100 }
        #Write-Progress -Activity "Clearing Windows Logs" -Status "$p% Complete:" -PercentComplete $p
        [Console]::SetCursorPosition(16, 6); Say -NoNewline "    "
        [Console]::SetCursorPosition(0, 6); Say -NoNewline "Delete count is: $i"
        [Console]::SetCursorPosition(16, 7); Say -NoNewline "    "
        [Console]::SetCursorPosition(0, 7); Say -NoNewline "PercentComplete: $p%"
        $it = "#" * ($p / 2)
        [Console]::SetCursorPosition(0, 8); Say -NoNewline "[$it"
        [Console]::SetCursorPosition(51, 8); Say -NoNewline "]"
    }
    asay ClearWindows Logs Processed $i log files.
    [Console]::SetCursorPosition(0, 9); Say -NoNewline "ClearWindows Logs Processed $i log files."
    [Console]::SetCursorPosition(0, 10); Read-Host -Prompt "[Slap Enter to Exit]"
    $PShost = Get-Host
    $PSWin = $PShost.ui.rawui
    $PSWin.CursorSize = 25
    return
}
