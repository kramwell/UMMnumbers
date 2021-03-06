#Written by KramWell.com - 15/FEB/2019
#Outputs the current UMM numbers assigned to users in Microsoft 365

$LogTime = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"
$CSVFile = "UMMNumbers(" + $LogTime + ").txt"

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $session

$EUM = Get-Recipient -ResultSize Unlimited | where{$_.emailaddresses -like "*"}

$OutArray = @()

Foreach ($UserEUM in $EUM)
{

	$pattern = "(?<=.*eum:)\w+?(?=;phone-context.*)"
	$EUMTel = [Regex]::Match($UserEUM.emailaddresses, $pattern)

	$myobj = "" | Select DisplayName, TelNo

	$myobj.DisplayName = $UserEUM.displayname
	$myobj.TelNo = $EUMTel.Value

	# Add the object to the out-array
	$OutArray += $myobj

	# Wipe the object just to be sure
	$myobj = $null

}

$OutArray = $OutArray | Sort-Object -Property @{Expression = "TelNo"}

$OutArray >>  $CSVFile

Write-Host File saved!