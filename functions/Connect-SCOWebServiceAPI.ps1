function Connect-SCOWebServiceAPI {
    <#
    .SYNOPSIS
        Connect to System Center Orchestrator Web Service API.
    .DESCRIPTION
        Connect to System Center Orchestrator Web Service API using a URI and/or credentials and configure all subsequents commands in the session to use these settings.
        The default is using http://localhost:81 and current logged in account.
    .EXAMPLE
    PS C:\> Connect-SCOWebServiceAPI -Uri https://sco.contoso.com:81
        Connects to <https://sco.contoso.com:81> using current logged in account.
    .EXAMPLE
    PS C:\> $creds = Get-Credential
    PS C:\> Connect-SCOWebServiceAPI -Credential $creds
        Connects to the default URI <http://localhost:81> using supplied PS Credential. 
    .EXAMPLE
    PS C:\> $creds = Get-Credential
    PS C:\> Connect-SCOWebServiceAPI -Uri https://sco.contoso.com:81 -Credential $creds
        Connects to <https://sco.contoso.com:81> using supplied PS Credential. 
    .OUTPUTS
    Connected username and API version
    #>
    [CmdletBinding()]
    param (
        [string] $WebServiceUri = $Script:DefaultWebServiceURI, #validate pattern ^http(s)://fqdn:port$
        [pscredential] $Credential
    )
    
    # Even if not supplied, we always have a default Uri stored in variables.ps1
            
    
    if($WebServiceUri -like 'https*' ){
        # Default allows unencrypted authentication, if we switch to HTTPS we should not allow this.
        Write-PSFMessage -Level Verbose -Message "Connecting with HTTPS"
        $useHTTPS = $true
    }
    else{
        $useHTTPS = $false
    }

    $uri = "{0}/api/Login" -f $WebServiceUri
    Write-PSFMessage -Level Verbose -Message "Connecting to: $uri"

    $invokeRestMethodParams = @{
        Uri = $uri
        AllowUnencryptedAuthentication = -Not $useHTTPS
    }


    if($Credential){
        Write-PSFMessage -Level Verbose -Message "Using account: $($Credential.UserName)"
        
        # Update the parameters to include credentials
        $invokeRestMethodParams['UseDefaultCredentials'] = $false
        $invokeRestMethodParams['Credential'] = $Credential
    }
    else{
        Write-PSFMessage -Level Verbose -Message "Using logged in account: $env:USERDOMAIN\$env:USERNAME"
        $invokeRestMethodParams['UseDefaultCredentials'] = $true
    }


    try{
        $connection = Invoke-RestMethod @invokeRestMethodParams -ErrorAction 'Stop'
        Write-PSFMessage -Level Verbose -Message "Connected successfully."
    }
    Catch{
        Write-PSFMessage -Level Verbose -Message "Failed to connect! Will not update connection."
        Stop-PSFFunction -Message $_.Exception.Response.StatusCode -EnableException $true -ErrorRecord $_
    }

    # Now that we know connection succeeded, its time to update the script variables
    $Script:DefaultWebServiceURI = $WebServiceUri
    $Script:AllowUnencryptedAuthentication = -Not $useHTTPS
    if($Credential){
        $Script:UseDefaultCredentials = $false
        $Script:DefaultCredential = $Credential 
    }

    $connection

}