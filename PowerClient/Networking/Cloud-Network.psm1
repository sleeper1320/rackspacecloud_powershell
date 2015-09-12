#
# Function for interacting with cloud networking.
#


$script:networkListTable = `
    @{Expression={$_.name};Label="Network Name";width=25},  
    @{Expression={$_.id};Label="Network ID";width=33}


function Add-CloudNetwork { 
    Param (
        [Parameter(Position=0,Mandatory=$false)]
        [string] $CloudNetworkLabel,
        [Parameter(Position=1,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Region
    )

    ## Setting variables needed to execute this function
    Set-Variable -Name networkURI -Value $null
    Set-Variable -Name jsonBody -Value $null
    Set-Variable -Name response -Value $null

    try {
        $networkUri = ((Get-IdentityNetworkURI -region $region) + "/networks")
    } catch {
        if(Use-AsScript) {throw}

        #If we reach here, we're not running as script
        Write-Host -ForegroundColor Red -BackgroundColor Black $_.Exception
        return
    }

    $jsonBody = ( Convert-CloudNetworkParameters -name $CloudNetworkLabel )


    Write-Debug "URI: `"$networkURI`""
    Write-Debug "Body: `n$jsonBody"

    try {
        $response = Use-AddAPIRequest $networkURI $jsonBody
    } catch {
        if(Use-AsScript) {throw}

        Write-Host -ForegroundColor Red -BackgroundColor Black $_.Exception
        return
    }

    Write-Host "You have just created the following cloud network: $($response.network)"    

<#
    .SYNOPSIS
    The Add-CloudNetwork cmdlet will create a new Rackspace cloud network in the specified region.

    .DESCRIPTION
    See synopsis.

    .PARAMETER CloudNetworkLabel
    Use this parameter to define the name/label of the cloud network you are about to create.

    .PARAMETER CloudNetworkCIDR
    Use this parameter to define the IP block that is going to be used for this cloud network.  This must be written in CIDR notation, for example, "172.16.0.0/24" without the quotes.

    .PARAMETER Region
    Use this parameter to indicate the region in which you would like to execute this request.

    .EXAMPLE
    PS C:\Users\Administrator> Add-CloudNetwork -CloudNetworkLabel DBServers -CloudNetworkCIDR 192.168.101.0/24 -Region DFW
    This example shows how to spin up a new cloud network called DBServers, which will service IP block 192.168.101.0/24, in the DFW region.

    .EXAMPLE
    PS C:\Users\Administrator> Add-CloudNetwork PaymentServers 192.168.101.0/24 ORD
    This example shows how to spin up a new cloud network called PaymentServers, which will service IP block 192.168.101.0/24 in the ORD region, without using the parameter names.

    .LINK
    http://docs.rackspace.com/servers/api/v2/cn-devguide/content/create_virtual_interface.html

#>
}


function Convert-CloudNetworkParameters {
    param(
        [Parameter(Position=0,Mandatory=$false)]
        [string]$name
    )

    $body = New-Object -TypeName PSObject
    $network = @{}
    
    if($name) { $network.Add("name", $name) }

    $body | Add-Member -MemberType NoteProperty -Name network -Value $network
    return (ConvertTo-Json $body)
<#
    .SYNOPSIS
    Converts the passed in network parameters to JSON

    .DESCRIPTION
    See the synopsis field.

    .PARAMETER name
    The name of the network.

    .EXAMPLE
    Convert-CloudNetworkParameters -name 'newName'
    Returns the JSON body { network
#>
}


function Get-CloudNetworks {
    Param (
        [Parameter (Position=0, Mandatory=$true)]
        [string] $Region
    )

    ## Setting variables needed to execute this function
    Set-Variable -Name networkURI -Value $null
    Set-Variable -Name response -Value $null
    Set-Variable -Name asScript -Value (Use-AsScript)

    try {
        $networkUri = ((Get-IdentityNetworkURI -region $region) + "/networks")
    } catch {
        if($asScript) {throw}

        #If we reach here, we're not running as script
        Write-Host -ForegroundColor Red -BackgroundColor Black $_.Exception
        return
    }


    Write-Debug "URI: `"$networkURI`""

    try {
        $response = Use-GetAPIRequest $networkURI
    } catch {
        if($asScript) {throw}

        Write-Host -ForegroundColor Red -BackgroundColor Black $_.Exception
        return
    }

    #Parse the response and determine if it should be used as script or not.
    $response = $response.networks | Sort-Object label
    return @{
        $true=($response);
        $false=($response | ft $NetworkListTable -AutoSize)
    }[$asScript]  

<#
    .SYNOPSIS
    The Get-CloudNetworks cmdlet will pull down a list of all Rackspace Cloud Networks on your account.

    .DESCRIPTION
    See the synopsis field.

    .PARAMETER Region
    Use this parameter to indicate the region in which you would like to execute this request.

    .EXAMPLE
    PS C:\Users\Administrator> Get-CloudNetworks -Region DFW
    This example shows how to get a list of all networks currently deployed in your account within the DFW region.

     .EXAMPLE
    PS C:\Users\Administrator> Get-CloudNetworks ORD
    This example shows how to get a list of all networks deployed in your account within the ORD region, but without specifying the parameter name itself.  Both examples work interchangably.

    PS C:\Users\mitch.robins> Get-CloudNetworks ORD
 
    Network Name Network ID                          
    ------------ ----------                          
    pstest       191d3959-331e-4e29-a5f7-a8c0619123df
    pstest1      dfc46217-942a-4609-98b4-ed916df8547f

    .LINK
    http://docs.rackspace.com/servers/api/v2/cn-devguide/content/list_networks.html
#>
}

function Remove-CloudNetwork {
    Param (
        [Parameter(Position=0,Mandatory=$true)]
        [string]$CloudNetworkID,
        [Parameter(Position=1,Mandatory=$true)]
        [string]$Region
    )

    ## Setting variables needed to execute this function
    Set-Variable -Name networkURI -Value $null
    Set-Variable -Name response -Value $null

    try {
        $networkUri = ((Get-IdentityNetworkURI -region $region) + "/networks/$CloudNetworkID")
    } catch {
        if(Use-AsScript) {throw}

        #If we reach here, we're not running as script
        Write-Host -ForegroundColor Red -BackgroundColor Black $_.Exception
        return
    }

    Write-Debug "URI: `"$networkURI`""
    Write-Debug "Body: `n$jsonBody"

    try {
        $response = Use-RemoveAPIRequest $networkURI
    } catch {
        if(Use-AsScript) {throw}

        Write-Host -ForegroundColor Red -BackgroundColor Black $_.Exception
        return
    }

    Write-Host "You have just created the following cloud network: $($response.network)"    

<#
    .SYNOPSIS
    The Remove-CloudNetwork cmdlet will delete Rackspace cloud network in the specified region.

    .DESCRIPTION
    See synopsis.

    .PARAMETER CloudNetworkID
    Use this parameter to define the name/label of the cloud network you are about to delete.

    PARAMETER Region
    Use this parameter to indicate the region in which you would like to execute this request.

    .EXAMPLE
    PS C:\Users\Administrator> Remove-CloudNetwork -CloudNetworkID 88e316b1-8e69-4591-ba92-bea8bb1837f5 -Region ord
    This example shows how to delete a cloud network with an ID of 88e316b1-8e69-4591-ba92-bea8bb1837f5 from the ORD region.

    EXAMPLE
    PS C:\Users\Administrator> Remove-CloudNetwork 88e316b1-8e69-4591-ba92-bea8bb1837f5 DFW
    This example shows how to delete a cloud network with an ID of 88e316b1-8e69-4591-ba92-bea8bb1837f5 from the DFW region, without the parameter names.

    .LINK
    http://docs.rackspace.com/servers/api/v2/cn-devguide/content/delete_network.html

#>
}

function Update-CloudNetwork {
    param (
        [Parameter(Position=0,Mandatory=$true)]
        [string]$CloudNetworkID,
        [Parameter(Position=1,Mandatory=$true)]
        [string]$Region
    )

    throw [System.NotImplementedException] "The function is not yet implemented. Please check source for an updated version."
}