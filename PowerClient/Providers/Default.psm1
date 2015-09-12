#
# Default implementation for Openstack API. Implement the functions in this module
# to add an alternate configuration provider.
#

Set-Variable -Name identityURI -Scope Script -Value $null   # URL for the identity endpoint.
Set-Variable -Name authBody -Scope Script -Value $null      # JSON body to perform auth request.

function Get-ProviderAuthBody {

    throw [System.NotImplementedException] "The function is not implemented for default provider."

<#
    .SYNOPSIS
    Returns the a JSON body to use for authentication.
#>
}

function Get-ProviderURI {

    throw [System.NotImplementedException] "The function is not implemented for default provider."

<#
    .SYNOPSIS
    Returns the URI used for Authentication with Rackspace
#>
}

function Get-ProviderMonitoringURI {
    param (
        [Parameter(Position=0,Mandatory=$true)
        [Object] $accessToken
    )
    
    throw [System.NotImplementedException] "The function is not implemented for default provider."

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
        [string] $region,
    )

    throw [System.NotImplementedException] "The function is not implemented for default provider."

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