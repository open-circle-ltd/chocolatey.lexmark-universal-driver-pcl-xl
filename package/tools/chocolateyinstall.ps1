$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.lexmark.com/downloads/drivers/Lexmark_Universal_v2_UD1_Installation_Package_03072025.exe'
$checksum = '29282342698A28EF4081F9432E19D2BB843EAF0A5488CCBB5459F08D021247048FF003AA862AC4314739CF7290CCFDAE62FE89A77DD9BD2B39C53BE597C0AB34'

$tempDir = Join-Path $env:TEMP $packageName
$exePath = Join-Path $tempDir "$packageName.exe"
$7zPath = Join-Path $env:ProgramFiles "7-Zip\7z.exe"
$7zArguments = "x `"$exePath`" -o`"$tempDir\extract`" -y"
$msiPath = Join-Path $tempDir "\extract\InstallationPackage\Drivers\x64\print64XL.msi"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = $msiPath
  checksum      = $checksum
  # TODO: Fix Checksum
  checksumType  = 'sha512'
  destination   = $toolsDir

  softwareName  = 'Lexmark Universal v2 XL Print Driver'
  fileType      = 'msi'
  silentArgs    = '/quiet /norestart'
}

# Create Temp Directory
New-Item -ItemType Directory -Force -Path $tempDir
New-Item -ItemType Directory -Force -Path $tempDir\extract

# Download/Extract .exe
Invoke-WebRequest -Uri $url -OutFile $exePath
Start-Process -FilePath $7zPath -ArgumentList $7zArguments -Wait -NoNewWindow

Install-ChocolateyPackage @packageArgs