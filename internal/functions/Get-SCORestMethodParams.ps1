function Get-SCORestMethodParams {
    <#
    .SYNOPSIS
        This is an internal function that prepares the Rest method paramters
    #>
    [CmdletBinding()]
    param (
        [string] $Uri 
    )

    Write-PSFMessage -Level Verbose -Message "Using Uri: $Uri"
    $invokeRestMethodParams = @{
        Uri                            = $uri
        UseDefaultCredentials          = $Script:UseDefaultCredentials
        AllowUnencryptedAuthentication = $Script:AllowUnencryptedAuthentication
    }

    if ($Script:DefaultCredential) {
        $invokeRestMethodParams['Credential'] = $Script:DefaultCredential
    }

    Write-PSFMessage -Level Verbose -Message "Rest method parameters: `r`n $($invokeRestMethodParams | out-string)"
        
    $invokeRestMethodParams
}