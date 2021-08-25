param (
    [switch]
    $skipConfirmation = $false
)


git branch --merged > $env:TEMP/merged_branches
$confirmed = $true;
if(!$skipConfirmation) {
    $confirmed = $false;
    Write-Host "Branches to be deleted:"
    Get-Content $env:TEMP/merged_branches | Where-Object { ($_ -notcontains '*') -and ($_ -notlike '*main') -and ($_ -notlike '*master') } | ForEach-Object { $_.trim() }
    Write-Host "Confirm delete: (Y/N)"
    $userInput = Read-Host
    $confirmed = ($userInput -like 'y')
}

if($confirmed) {
    Get-Content $env:TEMP/merged_branches | Where-Object { ($_ -notcontains '*') -and ($_ -notlike '*main') -and ($_ -notlike '*master') } | ForEach-Object { git branch -d $_.trim() }
} else {
    Write-Host "Delete aborted!"
}

Remove-Item $env:TEMP/merged_branches
