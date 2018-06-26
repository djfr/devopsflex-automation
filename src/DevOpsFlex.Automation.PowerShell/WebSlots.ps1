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
    
    $rg = $asp.ResourceGroup
    $region = $asp.GeoRegion
    $configuration = $asp.Name.Split("-")[2]
    $fullName = "$Name-$configuration"

    #Create webapp

    $webApp = Get-AzureRmWebApp -ResourceGroupName $asp.ResourceGroup -Name $fullName -ErrorAction SilentlyContinue

    if($webApp -eq $null) {
        New-AzureRmWebApp -ResourceGroupName $rg -Name $fullName -Location $region -AppServicePlan $asp.Name > $null
    }elseif($Force.IsPresent) {
        Remove-AzureRmWebApp -ResourceGroupName $rg -Name $fullName > $null
        New-AzureRmWebApp -ResourceGroupName $rg -Name $fullName -Location $region -AppServicePlan $asp.Name > $null
    }

    #DNS

    if($configuration -eq 'prod' -or $configuration -eq 'sand') {
        $dnsSuffix = 'com'
    }
    else {
        $dnsSuffix = 'net'
    }

    $dnsRoot = "$configuration.eshopworld.$dnsSuffix"
    $dnsZone = Get-AzureRmDnsZone -ResourceGroupName $rg -Name $dnsRoot
    $dnsHostName = "$Name.$dnsRoot"
    $cdnHostName = "$fullName.azureedge.net"  
    
    $dns = Get-AzureRmDnsRecordSet -Name $Name -Zone $dnsZone -RecordType CNAME   

    if($dns -eq $null) {
        New-AzureRmDnsRecordSet -Name $Name -Zone $dnsZone -Ttl 360 -RecordType CNAME -DnsRecords (New-AzureRmDnsRecordConfig -Cname $cdnHostName)
    }elseif($Force.IsPresent) {
        Remove-AzureRmDnsRecordSet -Name $Name -Zone $dnsZone -RecordType CNAME -Force
        New-AzureRmDnsRecordSet -Name $Name -Zone $dnsZone -Ttl 360 -RecordType CNAME -DnsRecords (New-AzureRmDnsRecordConfig -Cname $cdnHostName)
    }  

    #CDN

    $cdnProfile = Get-AzureRmCdnProfile

    $cdnEndpoint = Get-AzureRmCdnEndpoint -CdnProfile $cdnProfile -EndpointName $fullName -ErrorAction SilentlyContinue

    $appServiceHostName = "$fullName.azurewebsites.net"    

    if($cdnEndpoint -eq $null) {
        $cdnEndpoint = New-AzureRmCdnEndpoint -CdnProfile $cdnProfile -EndpointName $fullName -OriginHostName $appServiceHostName -OriginHostHeader $appServiceHostName -OriginName "AzureWebsites" -QueryStringCachingBehavior BypassCaching

        $customDomain = New-AzureRmCdnCustomDomain -CdnEndpoint $cdnEndpoint -HostName $dnsHostName -CustomDomainName "eshopworld"

    }elseif ($Force.IsPresent) {
        Remove-AzureRmCdnEndpoint -EndpointName $fullName -ProfileName $cdnProfile.Name -ResourceGroupName $rg -Confirm:$false
    }  
}