#
#
#

function Use-AddAPIRequest {
    Param (
        [Parameter (Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $URI,
        [Parameter (Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Body
    )

    Set-Variable -Name response -Value $null

    $response = Invoke-RestMethod -Uri $URI -Headers (Get-HeaderDictionary) -Body $body -ContentType application/json -Method Post
    return $response
}


function Use-GetAPIRequest {
    Param (
        [Parameter (Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $URI
    )
    
    Set-Variable -Name response -Value $null

    $response = Invoke-RestMethod -Uri $URI -Headers (Get-HeaderDictionary) -ContentType application/json -Method Get
    return $response
}

function Use-RemoveAPIRequest {
    Param (
        [Parameter (Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $URI
    )
    Set-Variable -Name response -Value $null

    $response = Invoke-WebRequest -Uri $URI -Headers $HeaderDictionary -DisableKeepAlive -ContentType application/json -Method Delete -ErrorAction Stop
    return $response
}


function Use-UpdateAPIRequest {
    Param (
        [Parameter (Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $URI,
        [Parameter (Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Body
    )

    Set-Variable -Name response -Value $null

    $response = Invoke-WebRequest -Uri $URI -Headers $HeaderDictionary -DisableKeepAlive -Body $Body -ContentType application/json -Method Put
    return $response
}

