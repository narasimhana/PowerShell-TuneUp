<#
.SYNOPSIS
        Reboot
        Created By: Dana Meli
        Created Date: May, 2019
        Last Modified Date: February 18, 2020

.DESCRIPTION
        This script is designed to be sort of like linux reboot.
        There are restart and logoff and shutdown options included.

.EXAMPLE
        Reboot.ps1 STOP

.EXAMPLE
        Reboot.ps1 SHUTDOWN

.EXAMPLE
        Reboot.ps1 RESTART

.EXAMPLE
        Reboot.ps1 REBOOT

.EXAMPLE
        Reboot.ps1 LOGOFF

.NOTES
        Still under development.

#>
[string]$DoWhat = $args
$FileVersion = "Version: 0.1.6"
if (!($DoWhat)) {
    Say "Reboot $FileVersion help."
    Say "Reboot STOP or Reboot SHUTDOWN"
    Say "Reboot RESTART or Reboot REBOOT"
    Say "Reboot LOGOFF"
    return
}
if ($DoWhat -eq "STOP") {
    asay.ps1 "Reboot $FileVersion is shutting this machine down."
    Start-Sleep -s 1
    Say "Reboot $FileVersion is shutting this machine down."
    & shutdown.exe /S /T 3 /C "Because I Fucking Said So."
    return
}
if ($DoWhat -eq "SHUTDOWN") {
    asay.ps1 "Reboot $FileVersion is shutting this machine down."
    Start-Sleep -s 1
    Say "Reboot $FileVersion is shutting this machine down."
    & shutdown.exe /S /T 3 /C "Because I Fucking Said So."
    return
}
if ($DoWhat -eq "REBOOT") {
    asay.ps1 "Reboot $FileVersion is rebooting this machine"
    Start-Sleep -s 1
    Say "Reboot $FileVersion is rebooting this machine"
    & shutdown.exe /R /T 3 /C "Because I Fucking Said So."
    return
}
if ($DoWhat -eq "RESTART") {
    asay.ps1 "Reboot $FileVersion is rebooting this machine"
    Start-Sleep -s 1
    Say "Reboot $FileVersion is rebooting this machine"
    & shutdown.exe /R /T 3 /C "Because I Fucking Said So."
    return
}
if ($DoWhat -eq "LOGOFF") {
    asay.ps1 "Reboot $FileVersion is logging you off this machine"
    Start-Sleep -s 1
    Say "Reboot $FileVersion is logging you off this machine"
    & shutdown.exe /L
    return
}
Say "Reboot $FileVersion [It should not get to here so ERROR]"
Say "The parameter" $DoWhat.ToUpper() "did not match any options."
