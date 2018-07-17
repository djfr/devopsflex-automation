function New-EswDnsEndpoint
{
<#

.SYNOPSIS
Adds a record to a DNS zone.

.DESCRIPTION
Adds a record to a DNS zone.

.PARAMETER DnsName
The name of the DNS record being created.

.PARAMETER ResourceGroupName
The Azure resource group name that the load balancer is in.

.PARAMETER DnsZone
The DNS Zone the record will be created in.

.PARAMETER IpAddress
The IP Address of the A record being created.

.PARAMETER RecordType
The type of record being created, defaults to an 'A' record.

.PARAMETER CName
If this is CName record being created, this is the url to create it for.

.PARAMETER Force
Force the recreation of the rule.

.EXAMPLE
New-EswDnsEndPoint -DnsName 'test-record' -ResourceGroupName 'test-rg' -DnsZone 'test.eshopworld.net' -IpAddress '192.168.5.5'
Will create an A record with an ip address of 192.168.5.5 in the test.eshopworld.net zone.

.FUNCTIONALITY
Creates DNS records in specified zones.
   
#>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true, Position=0)]
        [string] $DnsName,

        [parameter(Mandatory=$true, Position=1)]
        [string] $ResourceGroupName,

        [parameter(Mandatory=$true, Position=2)]
        [string] $DnsZone,

        [string] $IpAddress,

        [string] $RecordType = "A",

        [string] $CName,
        
        [switch] $Force
    )

    $existingDns = Get-AzureRmDnsRecordSet -Name $DnsName `
                                        -RecordType $RecordType `
                                        -ZoneName $DnsZone `
                                        -ResourceGroupName $ResourceGroupName `
                                        -ErrorAction SilentlyContinue

    if(($existingDns -ne $null) -and $Force.IsPresent) {
        $existingDns | Remove-AzureRmDnsRecordSet -Confirm:$False -Overwrite
        $existingDns = $null
    }

    if($existingDns -eq $null -and $RecordType -eq 'A') {
        New-AzureRmDnsRecordSet -Name $DnsName `
                                -RecordType $RecordType `
                                -ZoneName $DnsZone `
                                -ResourceGroupName $ResourceGroupName `
                                -Ttl 360 `
                                -DnsRecords (New-AzureRmDnsRecordConfig -IPv4Address "$IpAddress") > $null
    }
	elseif($existingDns -eq $null -and $RecordType -eq 'CNAME') {
        New-AzureRmDnsRecordSet -Name "$Name" `
                                -RecordType $RecordType `
                                -ZoneName $DnsZone `
                                -ResourceGroupName $ResourceGroupName `
                                -Ttl 30 `
                                -DnsRecords (New-AzureRmDnsRecordConfig -Cname $CName) > $null
    }
}