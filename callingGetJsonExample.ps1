#
# Framework - HTTP GET/JSON 
# PowerShell v3 reference implementation
#

$h = Get-Host
$version = $h.Version.Major

if ( $version -lt 3 )
{
	Write-Host "This example requires v3 PowerShell be installed" -ForegroundColor DarkYellow -BackgroundColor Red
}
else
{
	# dot source the utils file
	. c:\data\dev\AstroPS_Consumer\utils.ps1

	$usr = "admin"
	$pwd = "smart"
	$kreds = Format-Credentials $usr $pwd
	
	#url with kreds inserted
	$uri = "http://astro-dev.smartorg.com/rest?command=Ping&kreds=$kreds&name=bunny&age=37"
	
	$results = Invoke-RestMethod $uri

	#look at results ...
	$msg =  " Invoke-RestMethod {0} returned {1}" -f $uri,$results.GetType()
	$msg

	$results.commands | % { 

	    $_.name
	    $_.parameters | %{

			    "  {0} [{1}] " -f $_.name,( CovertFrom-Packed $_.value )
			    }
	 }
}