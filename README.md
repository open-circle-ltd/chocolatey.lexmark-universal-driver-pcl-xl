# Lexmark Universal Printdriver PCL XL

## Description

This Package will install the Lexmark Universal Printdriver PCL XL v3.0.7. 

## Parameters

- `/32bit`: Install 32-bit version (Default is 64-bit).
- `/Product`: Default: `XL`
    - `PCL` | Install the PCL Driver
    - `XL` | Install the PCL XL Driver
    - `PostScript` | Install the PostScript Driver

## Installation

```ps1
choco install lexmark-universal-driver-pcl-xl --params="'/32bit /Product:PCL'"
```

## TODO

- Integrate ChocoMilk Updater

    Lexmark does not provide a centralized directory or listing for available versions.<br>
    Version information from: [release-monitoring.org Project](https://release-monitoring.org/project/378130/)

- Add icon
- Create chocolateyuninstall.ps1
- ~~Fix Checksum update with chocomilk~~

## Disclaimer

These Chocolatey Packages only contain installation routines. The software itself is downloaded from the official sources of the software developer. Open Circle AG has no affilation with the software developer.

## Author

- [kve](https://github.com/kve-occ)
- [Open Circle AG](https://www.open-circle.ch)
