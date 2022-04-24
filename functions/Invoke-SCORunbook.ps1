function Invoke-SCORunbook {
    <#
    .SYNOPSIS
        Invokes a runbook with optional parameters
    .DESCRIPTION
        Invokes a runbook with optional parameter. 
    .EXAMPLE
        PS C:\> Invoke-SCORunbook -RunbookId <GUID>
        Invokes the specified runbook.
    #>
    [CmdletBinding()]
    param (
        # Runbook Id
        [Parameter(Mandatory = $true)]
        [string] $RunbookId,    

        [hashtable] $Parameters,
        [string] $WebServiceUri = $Script:DefaultWebServiceURI
        #[string[]] $RunbookServers, TODO: Coming soon
    )
    
    begin {
        Write-PSFMessage -Level Verbose -Message "Web Service URI set to: $WebServiceUri"
    }
    
    process {
        $uri = '{0}/api/Jobs' -f $WebServiceUri
        Write-PSFMessage -Level Verbose -Message "Invoking Runbook at: $uri"
        
        [array] $ParametersArray = foreach ($item in $parameters.GetEnumerator()) { @{Name = $item.Key; Value = $item.value } }

        $invokeRestMethodBody = [PSCustomObject]@{
            RunbookId      = $RunbookId
            RunbookServers = $RunbookServers
            Parameters     = $ParametersArray 
            CreatedBy      = $null
        } | ConvertTo-Json

        $invokeRestMethodParams = Get-SCORestMethodParams -Uri $uri

        $invokeRestMethodParams += @{
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $invokeRestMethodBody
        }

        Write-PSFMessage -Level Verbose -Message "Invoking Rest Method with parameters: `r`n $($invokeRestMethodParams | out-string)"

        $invokeRunbook = (Invoke-RestMethod @invokeRestMethodParams)
        $invokeRunbook
    }
    
    end {
        
    }
}