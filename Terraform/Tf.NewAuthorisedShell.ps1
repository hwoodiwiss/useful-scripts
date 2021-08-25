param (
    [string]
    $path = './tfenv.json'
)

function CheckJsonObject {
    param (
        [Hashtable]
        $object
    )

    return ($object.Keys.Contains('ArmTenantId') -and 
    $object.Keys.Contains('ArmClientId') -and 
    $object.Keys.Contains('ArmClientSecret') -and
    $object.Keys.Contains('ArmSubscriptionId') -and
    $object.Keys.Contains('ArmAccessKey'))
}

if((Test-Path $path) -ne $true) {
    Write-Host "Could not find file $path"
    return;
}
$envObject = Get-Content $path | ConvertFrom-Json -AsHashtable

if((CheckJsonObject -object $envObject) -eq $false) {
    Write-Host "Specified file $path did not contain the required fields"
    return;
}

$env:ARM_TENANT_ID = $envObject['ArmTenantId'];
$env:ARM_CLIENT_ID = $envObject['ArmClientId'];
$env:ARM_CLIENT_SECRET = $envObject['ArmClientSecret'];
$env:ARM_SUBSCRIPTION_ID = $envObject['ArmSubscriptionId'];
$env:ARM_ACCESS_KEY = $envObject['ArmAccessKey'];
pwsh
