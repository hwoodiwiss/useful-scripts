Get-ChildItem '.' -Filter '*.ps1' -Exclude 'install.ps1' -Recurse | ForEach-Object { Copy-Item $_ 'C:\\ProgramData\bin'}

$path = $env:Path;

if($path.ToLower().Contains('c:\programdata\bin') -ne $true) {
    Write-Host "Could not find C:\ProgramData\bin on the PATH."
    Write-Host "Add C:\ProgramData\bin to access scripts from anywhere."
}