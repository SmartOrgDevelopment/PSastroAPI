#
# Framework - HTTP GET/JSON 
# PowerShell v3 reference implementation
#

# dot source the utils file
. c:\data\dev\AstroPS_Consumer\utils.ps1

$usr = "admin"
$pwd = "smart"
$kreds = Format-Credentials $usr $pwd

$uri = "http://astro-dev.smartorg.com/rest?command=Ping&kreds=$kreds&name=bunny&age=44"
$uri = "http://astro-dev.smartorg.com/rest?command=Authenticate&kreds=$kreds&usr=bunny&pwd=44"

$results = Invoke-RestMethod $uri

$msg =  " Invoke-RestMethod {0} returned {1}" -f $uri,$results.GetType()
Write-Host -ForegroundColor DarkYellow $msg

$results.commands | % { 

    $_.name
    $_.parameters | %{

                    "  {0} [{1}] " -f $_.name,( CovertFrom-Packed $_.value )
                    }
 }