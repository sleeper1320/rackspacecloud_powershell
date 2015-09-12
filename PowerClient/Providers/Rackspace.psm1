#
# Rackspace specific implementation for Openstack API.
#

#Create the variables the functions below use.
Set-Variable -Name identityURI -Scope Script -Value 'https://identity.api.rackspacecloud.com/v2.0/tokens'
Set-Variable -Name authBody -Scope Script -Value "{{`"auth`":{{`"RAX-KSKEY:apiKeyCredentials`":{{`"username`":`"{0}`", `"apiKey`":`"{1}`"}}}}}}"


function Get-ProviderAuthBody {
    $private:result = [string]::Format($script:authBody, (Get-CloudUsername), (Get-CloudAPIKey))
    Write-Verbose "Using auth body of: $result"
    return $result
<#
    .SYNOPSIS
    Returns the a JSON body to use for authentication.
#>
}

function Get-ProviderURI {
    return $script:identityURI
<#
    .SYNOPSIS
    Returns the URI used for Authentication with Rackspace
#>
}

function Get-ProviderMonitoringURI {
    param (
        [Parameter(Position=0,Mandatory=$true)]
        [Object] $accessToken
    )
    
    $uri = ( Private-GetCloudEndpoints -cloudProduct "cloudMonitoring")

    if(-not $uri) {throw [System.IO.IOException] "Could not find a valid monitoring endpoint"}

    return $uri.publicURL

<#
    .SYNOPSIS
    Return the URI to use for the monitoring operations.

    .DESCRIPTION
    Parses the token provided and determines the approprite uri for the monitoring endpoint. If
    the endpoint is not found, an IO exception is thrown to be caught downstream.

    .PARAMETER $accessToken
    The token returned as the authentication response from Rackspace
#>
}

function Get-ProviderNetworkURI {
    param (
        [Parameter(Position=0,Mandatory=$true)]
        [Object] $accessToken,
        [Parameter(Position=1,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $region
    )

    $uri = ( Private-GetCloudEndpoints -cloudProduct "cloudNetworks" -region $region )

    if(-not $uri) {throw [System.IO.IOException] "Could not find a valid network enpoint for $region"}
    
    return $uri.publicURL
<#
    .SYNOPSIS
    Return the URI to use for the network operations.

    .DESCRIPTION
    Parses the token provided and determines the approprite uri for the networking endpoint. If
    the endpoint is not found, an IO exception is thrown to be caught downstream.

    .PARAMETER $accessToken
    The token returned as the authentication response from Rackspace
        
    .PARAMETER $region
    The region to return the URL from.
#>
}

function Private-GetCloudEndpoints {
    param (
        [Parameter(Position=0,Mandatory=$true)]
        [ValidateSet(
            "cloudNetworks",
            "cloudServers",
            "cloudBlockStorage",
            "cloudLoadBalancers",
            "cloudFiles",
            "cloudDNS",
            "cloudMonitoring" 
        )]
        [string] $cloudProduct,
        [Parameter(Position=0,Mandatory=$false)]
        [string] $region
    )

    $catalog = $accessToken.access.serviceCatalog

    switch ( $cloudProduct ) {
        "cloudNetworks"  {
            return ( $catalog | `
                where { $_.name -eq "cloudNetworks" } ).endpoints | `
                where { $_.region -eq $region } | `
                select publicURL
                
            }
        "cloudServers"  {
            return ( $catalog | `
                where { $_.name -eq "cloudServersOpenStack" } ).endpoints | `
                where { $_.region -eq $region } | `
                select publicURL
            }
        "cloudBlockStorage" {
            return ( $catalog | `
                where { $_.type -eq "volume" }).endpoints | `
                where { $_.region -eq $region } | `
                select publicURL
        }
        "cloudLoadBalancers" {
            return ( $catalog | `
                where {$_.name -eq "cloudLoadBalancers" -and $_.type -eq "rax:load-balancer"}).endpoints | `
                where { $_.region -eq $region } | `
                select publicURL
                
        }
        "cloudFiles" {
            return ( $catalog | `
                where { $_.type -eq "object-store" }).endpoints | `
                where { $_.region -eq $region } | `
                select publicURL
                
                }
        "cloudDNS" {
            return ( $catalog | `
                where { $_.type -eq "rax:dns" }).endpoints | `
                where { $_.region -eq $region } | `
                select publicURL
        }
        "cloudMonitoring" {
            return ( $catalog | `
                where { $_.type -eq "rax:monitor" }).endpoints | `
                select publicURL
        } 
    }

}