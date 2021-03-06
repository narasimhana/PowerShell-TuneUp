param([string]$file)
$FileVersion = "Version: 0.0.2"
Say "Remove-EmptyLines $FileVersion"
if (!($file)) { Say "Please include a file to process"; break }
(Get-Content $file) | Where-Object {$_.trim() -ne "" } | set-content $file
<#
gc is an abbreviation for get-content
The parenthesis causes the get-content command to finish before proceeding through the pipeline. Without the parenthesis, the file would be locked and we couldn't write back to it.
? is an abbreviation for "where-object". Essentially, an "if" statement
-ne is an operator that means "not equal to"
trim() is a method removes lines that contain spaces but nothing else which is what I needed in my case.
#>
