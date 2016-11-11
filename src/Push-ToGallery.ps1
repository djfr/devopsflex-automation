param
(
    [parameter(Mandatory=$true, Position=0)]
    [string] $ApiKey,

    [parameter(Mandatory=$false, Position=1)]
    [string] $FeedSource = $null
)

if(($FeedSource -ne $null) -and ((Get-PSRepository -Name EswPowerShell -ErrorAction SilentlyContinue) -eq $null)) {
    Register-PSRepository -Name EswPowerShell -SourceLocation $FeedSource -PublishLocation "$FeedSource/package"
}

if($FeedSource -eq $null) {
    Publish-Module -Name $PSScriptRoot\DevOpsFlex.Automation.PowerShell\DevOpsFlex.Automation.PowerShell.psd1 -NuGetApiKey $ApiKey
}
else {
    Publish-Module -Name $PSScriptRoot\DevOpsFlex.Automation.PowerShell\DevOpsFlex.Automation.PowerShell.psd1 -Repository EswPowerShellDev -NuGetApiKey $ApiKey
}
