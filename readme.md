# System Center Orchestrator PowerShell Module

This module utilizes the Web Service API of System Center Orchestrotor 2019/2022

## Installation
```PowerShell
Install-Module -Name SystemCenterOrchestrator
```

## Usage Examples
- Connect to Orchestrator Web Service API
```PowerShell
$creds = Get-Credential
Connect-SCOWebServiceAPI -Uri https://sco.contoso.com:81 -Credential $creds
```
> If you do not use `Connect-SCOWebServiceAPI` all cmdlets will default to http://localhost:81 and current logged in account.
- Get all runbooks, including parameters and returned data
```PowerShell
Get-SCORunbook
```
- Invoke a runbook specifying a parameters.
```PowerShell
$Paramters = @{
    'Parameter 1' = 'Example'
    'Parameter 2' = 123
}
Invoke-Runbook -RunbookId d7eab1cc-86b9-4bce-9b69-4bc6f12a9453 -Parameters $Parameters
```

## Requirements
- PowerShell 7.x
## Known Issues
- The module needs to run on the same server as the Web Service server and is configured for port 81. This will be fixed in an upcoming release.
- The module does not accept credentials. This will be fixed in an upcoming release.

## Are you still here?
Looks like you want to learn more! So this module was built by looking at how the web console makes calls to the API. Just start the developer tools in your browser (F12) and look at network trace as you take actions. Also, the API is using OData standards.
