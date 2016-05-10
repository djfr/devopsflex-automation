param
(
    [parameter(Mandatory=$true, Position=0)]
    [string] $ApiKey
)

Publish-Module -Repository DevOpsFlex -Name $PSScriptRoot\DevOpsFlex.Environments.PowerShell\DevOpsFlex.Environments.PowerShell.psd1 -NuGetApiKey $ApiKey
