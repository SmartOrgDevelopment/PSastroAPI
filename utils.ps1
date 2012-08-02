[System.Reflection.Assembly]::LoadWithPartialName("System.Web") | out-null


function CovertFrom-Packed($packed)
{
    $dec =  ConvertFrom-UrlEncodedString $packed
    ConvertFrom-Base64 $dec
}

function CovertTo-Packed($unpacked)
{
    $dec = ConvertTo-Base64 $unpacked
    ConvertTo-UrlEncodedString $dec
}

function ConvertTo-UrlEncodedString([string]$dataToConvert)
{
    begin {
        function EncodeCore([string]$data) { return [System.Web.HttpUtility]::UrlEncode($data) }
    }
    process { if ($_ -as [string]) { EncodeCore($_) } }
    end { if ($dataToConvert) { EncodeCore($dataToConvert) } }
}
function ConvertFrom-UrlEncodedString([string]$dataToConvert)
{
    begin {
        function DecodeCore([string]$data) { return [System.Web.HttpUtility]::UrlDecode($data) }
    }
    process { if ($_ -as [string]) { DecodeCore($_) } }
    end { if ($dataToConvert) { DecodeCore($dataToConvert) } }
}

function ConvertTo-Base64($string) {
   $bytes  = [System.Text.Encoding]::UTF8.GetBytes($string);
   $encoded = [System.Convert]::ToBase64String($bytes); 

   return $encoded;
}

function ConvertFrom-Base64($string) {
   $bytes  = [System.Convert]::FromBase64String($string);
   $decoded = [System.Text.Encoding]::UTF8.GetString($bytes); 

   return $decoded;
}

Function ConvertTo-MD5
{
    param($inputString)

    $result = ""
    $cryptoServiceProvider = [System.Security.Cryptography.MD5CryptoServiceProvider]
    $hashAlgorithm = new-object $cryptoServiceProvider

    $hashByteArray1 = $hashAlgorithm.ComputeHash($([Char[]] $inputString ))

    foreach ($byte in $hashByteArray1) { if ($byte -lt 16) {$result += “0{0:X}” -f $byte } else { $result += “{0:X}” -f $byte }}
    
    $result.ToLower()

}

Function Format-Credentials
{
    param($usrname,$clearPassword)
    
    $mdPwd = ConvertTo-MD5 $clearPassword
    $z = $usrname +'_' + $mdPwd
    CovertTo-Packed $z
    
}




Function Test-MD5
{
    Clear-Host
    $expected = CovertFrom-Packed "YWRtaW5fOGMzMTlmMjhkODFkMTUyN2E5NDI4ZTlhNWMyMTk1ZjU%3D"
    $expected = $expected.Split('_')[1]
    $actual = ConvertTo-MD5 "smart"
   
    
    if( $expected -eq $actual)
    {
        "OK"     
        Write-Host $actual -BackgroundColor DarkGreen
        Write-Host $expected -BackgroundColor DarkGreen
    }
    else
    {
        "FAIL"
        Write-Host $actual -BackgroundColor red
        Write-Host $expected -BackgroundColor red
    }


    Write-Host ( CovertTo-Packed $actual )
    Write-Host ( CovertTo-Packed $expected )


    $kredPair = 'admin_8c319f28d81d1527a9428e9a5c2195f5'
    $pak = CovertTo-Packed $kredPair
    $expected = 'YWRtaW5fOGMzMTlmMjhkODFkMTUyN2E5NDI4ZTlhNWMyMTk1ZjU%3D'



    Write-Host -BackgroundColor Cyan $expected
    Write-Host -BackgroundColor Cyan $pak
   
}


