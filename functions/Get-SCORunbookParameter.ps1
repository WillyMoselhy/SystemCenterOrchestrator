function Get-SCORunbookParameter {
    <#
    .SYNOPSIS
        Gets parameters of runbooks.
    .DESCRIPTION
        Gets all parameters of all runbooks. Can be filtered to a specific runbook by ID.
    .EXAMPLE
        PS C:\> Get-SCORunbookParameter
        Gets all paramters of all runbooks. Direction shows input or output paramter.
    .EXAMPLE
        PS C:\> Get-SCORunbookParameter -RunbookId <GUID>
        Gets all paramters of the specified runbook. Direction shows input or output paramter.
    #>
    [CmdletBinding()]
    param (
        [string] $RunbookId,    
        [string] $WebServiceUri = $Script:DefaultWebServiceURI
    )
    
    begin {
        Write-PSFMessage -Level Verbose -Message "Web Service URI set to: $WebServiceUri"
    }
    
    process {
        $uri = '{0}/api/RunbookParameters' -f $WebServiceUri
        Write-PSFMessage -Level Verbose -Message "Querying Runbook Parameters at: $uri"
        
        if ($RunbookId) {
            $uri += "?`$filter=RunbookId eq {0}" -f $RunbookId
            Write-PSFMessage -Level Verbose -Message "Filtering by Name: $uri"
        }

        $invokeRestMethodParams = Get-SCORestMethodParams -Uri $uri

        $runbookParameters = (Invoke-RestMethod @invokeRestMethodParams).value
        $runbookParameters
    }
    
    end {
        
    }
}