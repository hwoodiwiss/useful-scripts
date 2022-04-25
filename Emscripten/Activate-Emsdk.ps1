function GetEmsdkPath {
	$emsdkPathFile = "~\.emsdkpath";
	if (Test-Path -Path $emsdkPathFile) {
		return Get-Content -Path $emsdkPathFile;
	}

	$emsdkPath = "";

	while (-not (Test-Path -Path $emsdkPath)) {
		$emsdkPath = Read-Host -Prompt "Enter path to the emscripten sdk repository";
	}

	Add-Content -Path $emsdkPathFile -Value $emsdkPath;

	return $emsdkPath;
}

$emsdkPath = GetEmsdkPath
Invoke-Expression ". $emsdkPath\emsdk.ps1 activate latest"