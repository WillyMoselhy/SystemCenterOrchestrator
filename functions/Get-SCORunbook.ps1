function Get-SCORunbook {
    <#
    .SYNOPSIS
        Get Runbook details.
    .DESCRIPTION
        Get Runbook details including paramters and returned data. Can filter by name or ID.
    .EXAMPLE
        PS C:\> Get-SCORunbook
        Gets all runbooks.
    .EXAMPLE
        PS C:\> Get-SCORunbook -Id <GUID>
        Gets the runbook with specified ID.      
    .EXAMPLE
        PS C:\> Get-SCORunbook -Name <Name>
        Gets all runbooks with specified name.
    #>
    [CmdletBinding()]
    param (
        [string] $WebServiceUri = $Script:DefaultWebServiceURI,
        [string] $Name,
        [string] $Id,
        [string] $Path
    )
    
    begin {
        Write-PSFMessage -Level Verbose -Message "Web Service URI set to: $WebServiceUri"
    }
    
    process {
        $uri = '{0}/Runbooks' -f $WebServiceUri
        Write-PSFMessage -Level Verbose -Message "Querying Runbooks at: $uri"
        
        if ($Name) {
            $uri += "?`$filter=Name eq '{0}'" -f $Name
            Write-PSFMessage -Level Verbose -Message "Filtering by Name: $uri"
        }
        if ($Id) {
            $uri += "?`$filter=Id eq {0}" -f $Id
            Write-PSFMessage -Level Verbose -Message "Filtering by Id: $uri"
        }

        $invokeRestMethodParams = @{
            Uri = $uri
        }
        if ($Script:UseDefaultCredentials) {
            $invokeRestMethodParams['UseDefaultCredentials'] = $true
            $invokeRestMethodParams['AllowUnencryptedAuthentication'] = $true
        }
        Write-PSFMessage -Level Verbose -Message "Invoking Rest Method with parameters: `r`n $($invokeRestMethodParams | out-string)"

        $runbooks = (Invoke-RestMethod @invokeRestMethodParams).value
        
        # Get parameters of each runbook
        foreach ($item in $runbooks) {
            $runbookParameters = Get-SCORunbookParameter -RunbookId $item.Id | Select-Object -ExcludeProperty RunbookId
            $item | Add-Member -MemberType NoteProperty -Name Parameters -Value ($runbookParameters | Where-Object Direction -eq 'In')
            $item | Add-Member -MemberType NoteProperty -Name ReturnedData -Value ($runbookParameters | Where-Object Direction -eq 'Out')
        }
        $runbooks
    }
    
    end {
        
    }
}