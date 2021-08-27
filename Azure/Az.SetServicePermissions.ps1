param (
    [string]
    [Parameter(Mandatory = $true)]
    $path
)

try {
    Import-Module AzureAd -UseWindowsPowerShell 
}
catch {
    Write-Host "This script requires the Powershell AzureAd."
    Write-Host "Please install the module available at: https://www.powershellgallery.com/packages/AzureAD"
    return;
}


function CheckJsonObject {
    param (
        [Hashtable]
        $jsonObject
    )

    return ($jsonObject.Keys -ne $null -and 
    $jsonObject.Keys.Contains('AdTenantId') -and 
    $jsonObject.Keys.Contains('ClientIdentity') -and 
    $jsonObject.Keys.Contains('ServiceIdentity') -and
    $jsonObject.Keys.Contains('Roles'))
}

function SetAzurePermissions {
    param(
        [string]
        $tenantId,
        [string]
        $clientIdentity,
        [string]
        $serviceIdentity,
        [array]
        $roles
    )

    #Log into Azure Tenant
    Write-Host "Attempting to connect to Azure tenant $tenantId"
    Connect-AzureAd -TenantId $tenantId
    ###############################################################

    # Service Principal for Client
    Write-Host "Finding principal for client $clientIdentity"
    $clientPrincipal = Get-AzureADServicePrincipal -SearchString $clientIdentity

    #Service Principal for Registered App
    Write-Host "Finding principal for service $serviceIdentity"
    $servicePrincipal = Get-AzureADServicePrincipal -SearchString $serviceIdentity

    #Assign Role
    foreach ($appRole in $servicePrincipal.AppRoles) {
        if ($appRole.DisplayName -in $roles) {
            Write-Host "Assigning role $role to $clientPrincipal"
            New-AzureADServiceAppRoleAssignment -Id $appRole.Id `
                -PrincipalId $clientPrincipal.ObjectId `
                -ObjectId $clientPrincipal.ObjectId `
                -ResourceId $adApp[0].ObjectId
        }

    }
}

if((Test-Path $path) -ne $true) {
    Write-Host "Could not find file $path"
    return;
}

$jsonObject = Get-Content $path | ConvertFrom-Json -AsHashtable

if((CheckJsonObject -jsonObject $jsonObject) -eq $false) {
    Write-Host "Specified file $path did not contain the required fields"
    Write-Host 'Please provide a file in the format:
{
    "AdTenantId": "tenant-guid",
    "ClientIdentity": "client-name",
    "ServiceIdentity": "service-name",
    "Roles": [
        "Role1",
        "Role2"
    ]
}'
    return;
}

SetAzurePermissions -tenantId $jsonObject['AdTenantId']`
                    -clientIdentity $jsonObject['ClientIdentity']`
                    -serviceIdentity $jsonObject['ServiceIdentity']`
                    -roles $jsonObject['Roles']

Disconnect-AzureAd