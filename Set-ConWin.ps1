$FileVersion = "Version: 0.0.4"
$host.ui.RawUI.WindowTitle = "Set-ConWin $FileVersion"
<# #[Set-ConWin]#[Window Resizer]# #>
$BuffWidth = "107"
$BuffHeight = "45"
$WinWidth = "107"
$WinHeight = "45"
$pshost = (get-host)
$pswindow = ($pshost.ui.rawui)
$newsize = ($pswindow.buffersize)
$newsize.height = "2000"
$tmp = ($tmpWidth * 2)
$newsize.width = $tmp
$pswindow.buffersize = $newsize
$newsize = ($pswindow.windowsize)
$newsize.height = $tmpHeight
$newsize.width = $tmpWidth
$pswindow.windowsize = $newsize
