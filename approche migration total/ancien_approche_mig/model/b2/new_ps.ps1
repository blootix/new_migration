$csvLoc1 = Split-Path $script:MyInvocation.MyCommand.Path
$csvLoc = $csvLoc1 + "\"

$E = New-Object -ComObject Excel.Application
$E.Visible = $false
$E.DisplayAlerts = $false

get-childitem $csvLoc "*.xlsx" | foreach-object {
    $excelFile = $_.FullName
    $wb = $E.Workbooks.Open($excelFile)
    $s = [System.IO.Path]::GetFileNameWithoutExtension($excelFile)
     foreach ($ws in $wb.Worksheets)
     {
	$n = "b2"
	$ws.SaveAs($csvLoc + $n + ".csv", 6)
     }
    $wb.Close($false)
}

$E.Quit()
stop-process -processname EXCEL

