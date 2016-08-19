param
(
    [parameter(Mandatory=$true, Position=0)]
    [string] $ApiKey
)

Publish-Module -Name $PSScriptRoot\DevOpsFlex.Automation.PowerShell\DevOpsFlex.Automation.PowerShell.psd1 -NuGetApiKey $ApiKey
