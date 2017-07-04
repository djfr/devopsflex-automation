function Reset-Alias
{
<#
.SYNOPSIS
Creates and alias with replace functionality.

.DESCRIPTION
Checks if the alias already exists, if it does calls Set-Alias on it, if it doesn't it will create a new alias using New-Alias.
Relays the alias scope.

.PARAMETER Name 
Specifies the new alias. You can use any alphanumeric characters in an alias, but the first character cannot be a number.

.PARAMETER Value
Specifies the name of the cmdlet or command element that is being aliased.

.PARAMETER Scope
Specifies the scope of the new alias. Valid values are "Global", "Local", or "Script", or a number relative to the current scope (0 through the number of scopes, where 0 is the current scope and 1 is its parent).
"Local" is the default. For more information, see about_Scopes.

.EXAMPLE
Reset-Alias list get-childitem
This command creates an alias named "list" to represent the Get-ChildItem cmdlet on the "Global" scope.

.NOTES
Currently CmdletBinding doesn't have any internal support built-in.
#>

    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true, Position=0)]
        [string] $Name,

        [parameter(Mandatory=$true, Position=1)]
        [string] $Value,

        [parameter(Mandatory=$false)]
        [ValidateSet('Global', 'Local', 'Script')]
        [string] $Scope = 'Global'
    )

    if((Get-Alias -Name $Name -Scope $Scope -ErrorAction SilentlyContinue) -eq $null) {
        New-Alias -Name $Name -Value $Value -Scope $Scope
    }
    else {
        Set-Alias -Name $Name -Value $Value -Scope $Scope
    }
}

function Add-AzureAccounts
{
<#
.SYNOPSIS
Wraps Add-AzureAccount and Add-AzureRmAccount.

.DESCRIPTION
Logs you in ASM and ARM by wrapping Add-AzureAccount and Add-AzureRmAccount.

.EXAMPLE
Add-AzureAccounts
This command will log you in both ASM and ARM.

.NOTES
Currently CmdletBinding only has internal support for -Verbose.
#>

    [CmdletBinding()] param()

    Add-AzureAccount -Verbose:($PSBoundParameters["Verbose"].IsPresent -eq $true)
    Add-AzureRmAccount -Verbose:($PSBoundParameters["Verbose"].IsPresent -eq $true)
}

function Switch-AzureSubscription
{
<#
.SYNOPSIS
Help method with UI (Out-GridView) for switching across Azure subscriptions.

.DESCRIPTION
Shows you the list of available subscriptions (Out-GridView) and then selects the chosen one in both ASM and ARM.

.EXAMPLE
Switch-AzureSubscription
This command will show you the list of available subscriptions and then select the chosen one in both ASM and ARM.

.NOTES
Currently CmdletBinding only has internal support for -Verbose.
#>

    [CmdletBinding()] param()

    $sub = Get-AzureRmSubscription | select Name, Id | Out-GridView -PassThru

    Select-AzureSubscription -SubscriptionId $sub.Id -Verbose:($PSBoundParameters["Verbose"].IsPresent -eq $true)
    Select-AzureRmSubscription -SubscriptionId $sub.Id -Verbose:($PSBoundParameters["Verbose"].IsPresent -eq $true)
}
