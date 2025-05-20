$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName = $env:ChocolateyPackageName

$url = 'https://downloads.lexmark.com/downloads/drivers/Lexmark_Universal_v2_UD1_Installation_Package_03072025.exe'
$checksum = '017ae8977f2714409c25e8a54da69e94f027f32712196a0334d68ad1277080217ff5a76fef105d31189003a580f86335db8ef1d8bf3e045539b2e028771a5836'

$tempDir = Join-Path $env:TEMP $packageName
$exePath = Join-Path $tempDir "$packageName.exe"
$logPath = Join-Path $tempDir "install.log"
$7zPath = Join-Path $env:ProgramFiles "7-Zip\7z.exe"
$7zArguments = "x `"$exePath`" -o`"$tempDir\extract`" -y"

$arch = "64"
$driverType = "XL"

if ($PackageParameters) {

    if ($PackageParameters["32bit"]) {
      Write-Host "Installing 32-bit version."
      $arch = "86"
    } else {
      Write-Host "Installing 64-bit version."
    }

    if ($PackageParameters["Product"]) {
        $product = $PackageParameters["Product"]
        switch ($product) {
          "PCL" { $driverType = "PCL"}
          "XL" { $driverType = "XL"}
          "PostScript" { $driverType = "PostScript_Emulation"}
          default { Write-Warning "Product type unknown: '$product'! Installing XL."}
        }
        Write-Host "Installing $product Driver."
    }
} else {
    Write-Debug "No Parameters passed in"
    Write-Host "Installing 64-bit version."
    Write-Host "Installing $driverType Driver."
}

$driverFile = switch ($driverType) {
    "PCL" { "print$arch`PCL.msi" }
    "XL" { "print$arch`XL.msi" }
    "PostScript_Emulation" { "print$arch`PostScript_Emulation.msi" }
  }
$msiPath = Join-Path $tempDir "\extract\InstallationPackage\Drivers\x$arch\$driverFile"

New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
New-Item -ItemType Directory -Force -Path $tempDir\extract | Out-Null

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $exePath -Url $url -Checksum $checksum -ChecksumType 'sha512'
Start-Process -FilePath $7zPath -ArgumentList $7zArguments -Wait -NoNewWindow -RedirectStandardOutput $logPath -RedirectStandardError $logPath

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  file          = $msiPath
  softwareName  = "Lexmark Universal v2 Print Driver"
  silentArgs    = '/quiet /norestart'
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs