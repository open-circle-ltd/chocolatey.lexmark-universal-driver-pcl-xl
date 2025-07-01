# Lexmark Universal Printdriver 

## Description

Installs different types of the Lexmark Universal Print Driver 

## Parameters

- `/32bit`: Install 32-bit version (Default is 64-bit).
- `/Product`: Default: `XL`
    - `PCL`:          Install the PCL Driver
    - `XL`:           Install the PCL XL Driver
    - `PostScript`:   Install the PostScript Driver

## Installation

```ps1
choco install lexmark-universal-driver-pcl-xl --params="'/32bit /Product:PCL'"
```

## Dependencies

This pacakge requires the package `7zip.install` to extract the installer.

## TODO

- Add icon
- Create chocolateyuninstall.ps1


## Disclaimer

These Chocolatey Packages only contain installation routines. The software itself is downloaded from the official sources of the software developer. Open Circle AG has no affilation with the software developer.

## Author

- [kve](https://github.com/kve-occ)
- [Open Circle AG](https://www.open-circle.ch)
