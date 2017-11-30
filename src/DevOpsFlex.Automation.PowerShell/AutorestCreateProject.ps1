function Autorest-CreateProject
{
   	[CmdletBinding()]
	param(
	[string]$defUrl,
	[string]$namespace,
	[string]$outputFolder="output",
	[string]$lang="csharp",
	[string]$config="release"
	)
     try
     {	
		if (!$defUrl)
		{
			throw "Missing parameter value for definition file URL"
		}

		if (!$namespace)
		{
			throw "Missing parameter value for namespace"
		}

		autorest --latest

		"Definition URL :$defUrl"
		"Language :$lang"
		"Output folder :$outputFolder"
		"Configuration :$config"

		iwr $defUrl -o definition.json
		autorest --input-file=definition.json --$lang --output-folder=$outputFolder --namespace=$namespace
		dotnet autorest-createproject -s definition.json -o $outputFolder

		pushd $outputFolder
		dotnet build -c $config
		popd
    }
    catch
    {
        throw $_.Exception.Message       
    }	
}
