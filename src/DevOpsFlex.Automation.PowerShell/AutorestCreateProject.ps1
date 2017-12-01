function New-AutoRestProject
{
   	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true, Position=1)]
	[string]$DefUrl,
	[Parameter(Mandatory=$true, Position=2)]
	[string]$Namespace,
	[Parameter(Mandatory=$false, Position=3)]
	[string]$OutputFolder="output"
	)
		try
		{
			autorest --latest
		}
		catch
		{
			Write-Error "Autorest is not present on the system $_.Exception.Message"
			exit
		}

		try
		{
			Invoke-WebRequest $DefUrl -o definition.json
		}
		catch
		{
			Write-Error "Problem retrieving definition file $DefUrl"
            exit
		}

		autorest --input-file=definition.json --csharp --output-folder=$OutputFolder --namespace=$Namespace
		dotnet autorest-createproject -s definition.json -o $OutputFolder

		pushd $OutputFolder

		dotnet build -c release

		popd
}
