$mainFunction =
{
    $mypath = $MyInvocation.MyCommand.Path
    Write-Output "Path of the script: $mypath"
    Write-Output "Args for script: $Args"

    GetLatestWinGet

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    $dscUri = "https://raw.githubusercontent.com/anarion80/win-config/main/"
    $dscMachineSetup = "configurations/machine-setup.dsc.yaml"
    $dscApps = "configurations/apps.dsc.yaml"
    $dscDevelopment = "configurations/development.dsc.yaml"
    $dscFonts = "configurations/fonts.dsc.yaml"
    $dscGaming = "configurations/gaming.dsc.yaml"
    $dscRepos = "configurations/repos.dsc.yaml"
    $dscWsl = "configurations/wsl.dsc.yaml"
    $dscExtras = "configurations/extra.dsc.yaml"

    $dscMachineSetupUri = $dscUri + $dscMachineSetup;
    $dscAppsUri = $dscUri + $dscApps;
    $dscDevelopmentUri = $dscUri + $dscDevelopment;
    $dscFontsUri = $dscUri + $dscFonts;
    $dscGamingUri = $dscUri + $dscGaming;
    $dscReposUri = $dscUri + $dscRepos;
    $dscWslUri = $dscUri + $dscWsl;
    $dscExtrasUri = $dscUri + $dscExtras;

    # amazing, we can now run WinGet get fun stuff
    if (!$isAdmin)
    {
        # Shoulder tap terminal to it gets registered moving foward
        Start-Process shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App

        winget configuration -f $dscMachineSetupUri

        # restarting for Admin now
        Start-Process PowerShell -wait -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$mypath' $Args;`"";
        exit;
    }
    else
    {
        Write-Host "Start: Machine setup"
        winget configuration -f $dscMachineSetupUri
        Write-Host "Done: Machine setup"

        Write-Host "Start: Apps install"
        winget configuration -f $dscAppsUri
        Write-Host "Done: Apps install"

        Write-Host "Start: Dev flows install"
        winget configuration -f $dscDevelopmentUri
        Write-Host "Done: Dev flows install"

        Write-Host "Start: Fonts install"
        winget configuration -f $dscFontsUri
        Write-Host "Done: Fonts install"

        Write-Host "Start: Gaming install"
        winget configuration -f $dscGamingUri
        Write-Host "Done: Gaming install"

        Write-Host "Start: Repos install"
        winget configuration -f $dscReposUri
        Write-Host "Done: Repos install"

        Write-Host "Start: WSL install"
        winget configuration -f $dscWslUri
        Write-Host "Done: WSL install"

        Write-Host "Start: Extra install"
        winget configuration -f $dscExtrasUri
        Write-Host "Done: Extra install"

    }
}

function GetLatestWinGet
{
    # turning off progress bar to make invoke WebRequest fast
    $ProgressPreference = 'SilentlyContinue'


    $paths = "Microsoft.VCLibs.x64.14.00.Desktop.appx", "Microsoft.UI.Xaml.2.8.x64.appx", "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $uris = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx", "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx", "https://aka.ms/getwinget"
    Write-Host "Downloading WinGet and its dependencies..."

    for ($i = 0; $i -lt $uris.Length; $i++) {
        $filePath = $paths[$i]
        $fileUri = $uris[$i]
        Write-Host "Downloading: ($filePat) from $fileUri"
        Invoke-WebRequest -Uri $fileUri -OutFile $filePath
    }

    Write-Host "Installing WinGet and its dependencies..."

    foreach($filePath in $paths)
    {
        Write-Host "Installing: ($filePath)"
        Add-AppxPackage $filePath
    }

    Write-Host "Verifying Version number of WinGet"
    winget -v

    Write-Host "Cleaning up"
    foreach($filePath in $paths)
    {
        if (Test-Path $filePath)
        {
            Write-Host "Deleting: ($filePath)"
            Remove-Item $filePath -verbose
        }
        else
        {
            Write-Error "Path doesn't exits: ($filePath)"
        }
    }
}

& $mainFunction