#
# WebSlots.ps1
#

function New-WebSlot
{
	[CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [string] $Name,

        [switch] $Force
    )

    $asp = Get-AzureRmAppServicePlan

    if($asp.Count -gt 1) {
        $asp = $asp | ? { $_.Name -match 'asp-cdn-\w*' }
    }
    
    $rg = $asp.ResourceGroup
    $region = $asp.GeoRegion
    $environment = $asp.Name.Split("-")[2]
    $fullName = "$Name-$environment"

    #Create webapp

    $webApp = Get-AzureRmWebApp -ResourceGroupName $asp.ResourceGroup -Name $fullName -ErrorAction SilentlyContinue

    if($webApp -eq $null) {
        New-AzureRmWebApp -ResourceGroupName $rg -Name $fullName -Location $region -AppServicePlan $asp.Name > $null
    }elseif($Force.IsPresent) {
        Remove-AzureRmWebApp -ResourceGroupName $rg -Name $fullName > $null
        New-AzureRmWebApp -ResourceGroupName $rg -Name $fullName -Location $region -AppServicePlan $asp.Name > $null
    }

    #DNS

    if($environment -eq 'prod' -or $environment -eq 'sand') {
        $dnsSuffix = 'com'
    }
    else {
        $dnsSuffix = 'net'
    }   
    
    switch($environment)
    {
        "sand" { $dnsConfiguration = "sandbox" }
        "prep" { $dnsConfiguration = "preprod" }
        "prod" { $dnsConfiguration = "production" }
        default { $dnsConfiguration = $environment }
    } 

    $dnsRoot = "$dnsConfiguration.eshopworld.$dnsSuffix"
    $dnsZone = Get-AzureRmDnsZone -ResourceGroupName $rg -Name $dnsRoot
    $dnsHostName = "$Name.$dnsRoot"
    $cdnHostName = "$fullName.azureedge.net"  

    $dns = Get-AzureRmDnsRecordSet -Name $Name -Zone $dnsZone -RecordType CNAME -ErrorAction SilentlyContinue

    if($dns -eq $null) {
        New-AzureRmDnsRecordSet -Name $Name -Zone $dnsZone -Ttl 360 -RecordType CNAME -DnsRecords (New-AzureRmDnsRecordConfig -Cname $cdnHostName) > $null
    }elseif($Force.IsPresent) {
        Remove-AzureRmDnsRecordSet -Name $Name -Zone $dnsZone -RecordType CNAME
        New-AzureRmDnsRecordSet -Name $Name -Zone $dnsZone -Ttl 360 -RecordType CNAME -DnsRecords (New-AzureRmDnsRecordConfig -Cname $cdnHostName) > $null
    }  

    #CDN

    $cdnProfile = Get-AzureRmCdnProfile
    $cdnEndpoint = Get-AzureRmCdnEndpoint -CdnProfile $cdnProfile -EndpointName $fullName -ErrorAction SilentlyContinue
    $appServiceHostName = "$fullName.azurewebsites.net"    

    if($cdnEndpoint -eq $null) {
        $cdnEndpoint = New-AzureRmCdnEndpoint -CdnProfile $cdnProfile -EndpointName $fullName -OriginHostName $appServiceHostName -OriginHostHeader $appServiceHostName -OriginName "AzureWebsites"        
        $customDomain = New-AzureRmCdnCustomDomain -CdnEndpoint $cdnEndpoint -HostName $dnsHostName -CustomDomainName "eshopworld"
    }elseif ($Force.IsPresent) {
        Remove-AzureRmCdnEndpoint -EndpointName $fullName -ProfileName $cdnProfile.Name -ResourceGroupName $rg -Confirm:$false
        $cdnEndpoint = New-AzureRmCdnEndpoint -CdnProfile $cdnProfile -EndpointName $fullName -OriginHostName $appServiceHostName -OriginHostHeader $appServiceHostName -OriginName "AzureWebsites"       
        $customDomain = New-AzureRmCdnCustomDomain -CdnEndpoint $cdnEndpoint -HostName $dnsHostName -CustomDomainName "eshopworld"
    }  
}