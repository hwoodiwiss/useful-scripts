param (
	[Parameter()]
	[string]
	$installPath = "C:\\ProgramData\\bin"
)

function ClearExisting {
	Push-Location "${env:TEMP}"
	Remove-Item rust-analyzer*
	Pop-Location
}

function GetLatestWindowsUri {
	$latestData = (Invoke-WebRequest "https://api.github.com/repos/rust-analyzer/rust-analyzer/releases/latest" | ConvertFrom-Json)
	$windowsAsset = $latestData.assets.Where( { $_.name -like "*x86_64-pc-windows*" })[0]
	return $windowsAsset.browser_download_url
}

function DownloadAndUnzip {
	param (
		[string]
		$downloadPath
	)
	$path = "${env:TEMP}\rust-analyzer.exe.gz"
	$downloadData = Invoke-WebRequest $downloadPath
	$stream = [IO.File]::Create($path)
	$stream.Close();
	[IO.File]::WriteAllBytes($path, $downloadData.Content)
	Push-Location $env:TEMP
	7z.exe x -aoa $path
	Pop-Location
}

function CopyFile {
	$path = "${env:TEMP}\rust-analyzer.exe"
	Copy-Item $path "${installPath}\rust-analyzer.exe"
}

if ((Get-Command "7z.exe" -ErrorAction SilentlyContinue) -eq $null) { 
	Write-Host "Unable to find 7z.exe in your PATH"
	return
}

ClearExisting
$latestDownload = GetLatestWindowsUri
DownloadAndUnzip $latestDownload 
CopyFile
