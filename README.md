# Winget Configurations

Using a WinGet Configuration file, you can consolidate manual machine setup and project onboarding to a single command that is reliable and repeatable. To achieve this, WinGet utilizes:

A YAML-formatted WinGet Configuration file that lists all of the software versions, packages, tools, dependencies, and settings required to set up the desired state of the development environment on your Windows machine.
PowerShell Desired State Configuration (DSC) to automate the configuration of your Windows operating system.
Use the Windows Package Manager winget configure command to initiate the configuration process.

This repository contains my own WinGet Configuration files for different settings, perhaps it will be useful for you as well.

> This is presented as is, tested only in Windows Sandbox. Use at your own risk :exclamation:

Note: If you encounter the following error when running the script [`boot.ps1`](boot.ps1)
> `boot.ps1 cannot be loaded because running scripts is disabled on this system`

Run the following command:

> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

## Credits

- [Atc.Winget.Configurations](https://github.com/atc-net/atc.winget.configurations)
- [MrLacey's config](https://github.com/mrlacey/my-config)
- [crutkas's setup](https://github.com/crutkas/setup)

## Requirements

- [`Winget`](https://github.com/microsoft/winget-cli/releases)
- [`PowerShell`](https://github.com/microsoft/winget-cli/releases)
