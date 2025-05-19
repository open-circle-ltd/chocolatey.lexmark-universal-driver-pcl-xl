$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.lexmark.com/downloads/drivers/Lexmark_Universal_v2_UD1_Installation_Package_03072025.exe'
$checksum = '29282342698A28EF4081F9432E19D2BB843EAF0A5488CCBB5459F08D021247048FF003AA862AC4314739CF7290CCFDAE62FE89A77DD9BD2B39C53BE597C0AB34'

$tempDir = Join-Path $env:TEMP $packageName
$exePath = Join-Path $tempDir "$packageName.exe"
$7zPath = Join-Path $env:ProgramFiles "7-Zip\7z.exe"
$7zArguments = "x `"$exePath`" -o`"$tempDir\extract`" -y"

# Set defaults
$arch = "x64"
$driverType = "XL"

# Available parameters
$driverTypes = @("PCL", "XL", "PostScript_Emulation")
$architectures = @("x64", "x86")

if ($PackageParameters) {

    # /32bit parameter check
    if ($PackageParameters["32bit"]) {
      Write-Host "Installing 32-bit version."
      $arch = "x86"
    } else {
      Write-Host "Installing 64-bit version."
    }

    # /Product parameter check
    if ($PackageParameters["Product"]) {
        $product = $PackageParameters["Product"]
        switch ($product) {
          "PCL" { $driverType = "PCL"}
          "XL" { $driverType = "XL"}
          "PostScript" { $driverType = "PostScript_Emulation"}
          default { Write-Warning "Product type unknown: '$product'! Installing XL."}
        }
    }
}

# Construct path to .msi
$driverFile = switch ($driverType) {
    "PCL" { "print$arch`PCL.msi" }
    "XL" { "print$arch`XL.msi" }
    "PostScript_Emulation" { "print$arch`PS.msi" }
  }
$msiPath = Join-Path $tempDir "\extract\InstallationPackage\Drivers\$arch\$driverFile"


# Create Temp Directory
New-Item -ItemType Directory -Force -Path $tempDir
New-Item -ItemType Directory -Force -Path $tempDir\extract

# Download/Extract .exe
Invoke-WebRequest -Uri $url -OutFile $exePath
Start-Process -FilePath $7zPath -ArgumentList $7zArguments -Wait -NoNewWindow

# Install package
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = $msiPath
  checksum      = $checksum
  checksumType  = 'sha512'
  destination   = $toolsDir
  softwareName  = "Lexmark Universal v2 $driverType Print Driver"
  fileType      = 'msi'
  silentArgs    = '/quiet /norestart'
}

Install-ChocolateyPackage @packageArgs