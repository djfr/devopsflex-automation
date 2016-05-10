param
(
    [parameter(Mandatory=$true, Position=0)]
    [string] $ApiKey
)

#Invoke-WebRequest -Uri "http://go.microsoft.com/fwlink/?LinkID=690216&clcid=0x409" -OutFile "C:\ProgramData\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe"
Publish-Module -Name $PSScriptRoot\DevOpsFlex.Environments.PowerShell\DevOpsFlex.Environments.PowerShell.psd1 -NuGetApiKey $ApiKey
