﻿[CmdletBinding()]
param
(
    $VMX_Path
)

################## Some Globals
if ($PSVersionTable.PSVersion -lt [version]"6.0.0") {
    Write-Verbose "This will check if we are on PowerShell version 6"
}

Write-Host "Trying to get OS type... "
if ($env:windir) {
    $OS_Version = Get-Command "$env:windir\system32\ntdll.dll"
    $OS_Version = "Product Name: Windows $($OS_Version.Version)"
    $Global:VMXToolkit_type = "win_x86_64"
    
    Write-Verbose "Getting VMware path from registry"
    if (!(Test-Path "HKCR:\")) { $NewPSDrive = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT } # This line is necessary, even though VS Code says it isn't.
    if (!($VMware_Path = Get-ItemProperty HKCR:\Applications\VMware.exe\shell\open\command -ErrorAction SilentlyContinue)) {
        Write-Error "VMware binaries not found from registry"
        Break
    }

    $Preferences_File = "$env:AppData\VMware\preferences.ini"
    $VMX_BasePath = '\Documents\Virtual Machines\'	
    $VMware_Path = Split-Path $VMware_Path.'(default)' -Parent
    $VMware_Path = $VMware_Path -replace '"', ''
    $Global:VMwarepath = $VMware_Path
    $Global:VMware = "$VMware_Path\VMware.exe"
    $Global:vmrun = "$VMware_Path\vmrun.exe"
    $Global:VMware_vdiskmanager = Join-Path $VMware_Path 'VMware-vdiskmanager.exe'
    $Global:VMware_OVFTool = Join-Path $Global:VMwarepath 'OVFTool\ovftool.exe'
    $GLobal:VMware_packer = Join-Path $Global:VMwarepath '7za.exe'
    $VMwarefileinfo = Get-ChildItem $Global:VMware
    $Global:vmxinventory = "$env:appdata\VMware\inventory.vmls"
    $Global:VMwareversion = New-Object System.Version($VMwarefileinfo.VersionInfo.ProductMajorPart, $VMwarefileinfo.VersionInfo.ProductMinorPart, $VMwarefileinfo.VersionInfo.ProductBuildPart, $VMwarefileinfo.VersionInfo.ProductVersion.Split("-")[1])
    $webrequestor = ".Net"
    $Global:mkisofs = "$Global:VMwarepath/mkisofs.exe"
}
elseif ($OS = uname) {
    Write-Host "Found OS $OS"
    Switch ($OS) {
        "Darwin" {
            $Global:VMXToolkit_type = "OSX"
            $OS_Version = (sw_vers)
            $OS_Version = $OS_Version -join " "
            $VMX_BasePath = 'Documents/Virtual Machines.localized'
            # $VMware_Path = "/Applications/VMware Fusion.app"
            $VMware_Path = mdfind -onlyin /Applications "VMware Fusion"                
            $Global:VMwarepath = $VMware_Path
            [version]$Fusion_Version = defaults read $VMware_Path/Contents/Info.plist CFBundleShortVersionString
            $VMware_BIN_Path = Join-Path $VMware_Path  '/Contents/Library'
            $Preferences_File = "$HOME/Library/Preferences/VMware Fusion/preferences"
            try {
                $webrequestor = (get-command curl).Path
            }
            catch {
                Write-Warning "curl not found"
                exit
            }
            try {
                $GLobal:VMware_packer = (get-command 7za -ErrorAction Stop).Path 
            }
            catch {
                Write-Warning "7za not found, please install 7zip full"
                Break
            }

            $Global:VMware_vdiskmanager = Join-Path $VMware_BIN_Path 'VMware-vdiskmanager'
            $Global:vmrun = Join-Path $VMware_BIN_Path "vmrun"
            switch ($Fusion_Version.Major) {
                "10" {
                    $Global:VMware_OVFTool = "/Applications/VMware Fusion.app/Contents/Library/VMware OVF Tool/ovftool"
                    [version]$Global:VMwareversion = "14.0.0.0"
                }
					
                default {
                    $Global:VMware_OVFTool = Join-Path $VMware_Path 'ovftool'
                    [version]$Global:VMwareversion = "12.0.0.0"
                }
            }

        }
        'Linux' {
            $Global:VMXToolkit_type = "LINUX"
            $OS_Version = (uname -o)
            #$OS_Version = $OS_Version -join " "
            $Preferences_File = "$HOME/.VMware/preferences"
            $VMX_BasePath = '/var/lib/VMware/Shared VMs'
            try {
                $webrequestor = (get-command curl).Path
            }
            catch {
                Write-Warning "curl not found"
                exit
            }
            try {
                $VMware_Path = Split-Path -Parent (get-command VMware).Path
            }
            catch {
                Write-Warning "VMware path not found"
                exit
            }

            $Global:VMwarepath = $VMware_Path
            $VMware_BIN_Path = $VMware_Path  
            try {
                $Global:VMware_vdiskmanager = (get-command VMware-vdiskmanager).Path
            }
            catch {
                Write-Warning "VMware-vdiskmanager not found"
                break
            }
            try {
                $GLobal:VMware_packer = (get-command 7za).Path
            }
            catch {
                Write-Warning "7za not found, please install 7zip full"
            }
				
            try {
                $Global:vmrun = (Get-Command vmrun).Path
            }	
            catch {
                Write-Warning "vmrun not found"
                break
            }
            try {
                $Global:VMware_OVFTool = (Get-Command ovftool).Path
            }
            catch {
                Write-Warning "ovftool not found"
                break
            }
            try {
                $Global:mkisofs = (Get-Command mkisofs).Path
            }
            catch {
                Write-Warning "mkisofs not found"
                break
            }
            $VMware_Base_Version = (VMware -v)
            $VMware_Base_Version = $VMware_Base_Version -replace "VMware Workstation "
            [version]$Global:VMwareversion = ($VMware_Base_Version.Split(' '))[0]
        }
        default {
            Write-Host "Sorry, rome was not build in one day"
            exit
        }
        'default' {
            Write-Host "Unknown Linux OS"
            break
        }
    }
}
else {
    Write-Host "Error detecting OS"
}

if (Test-Path $Preferences_File) {
        Write-Verbose "Found VMware preferences file"
        Write-Verbose "Trying to get vmx path from preferences"
        $defaultVMPath = get-content $Preferences_File | Select-String prefvmx.defaultVMPath
        if ($defaultVMPath) {
            $defaultVMPath = $defaultVMPath -replace "`""
            $defaultVMPath = ($defaultVMPath -split "=")[-1]
            $defaultVMPath = $defaultVMPath.TrimStart(" ")
            Write-Verbose "Default VM path from preferences is: $defaultVMPath"
            $VMX_default_Path = $defaultVMPath
            $defaultselection = "preferences"
        }
        else {
            Write-Verbose "No default VM path in preferences"
        }
    }

if (!$VMX_Path) {
    if (!$VMX_default_Path) {
        Write-Verbose "Trying to use default vmxdir in home directory" 
        try {
            $defaultselection = "homedir"
            $Global:vmxdir = Join-Path $HOME $VMX_BasePath
        }
        catch {
            Write-Warning "Could not evaluate default virtual machines home, using $PSScriptRoot"
            $Global:vmxdir = $PSScriptRoot
            $defaultselection = "ScriptRoot"
            Write-Verbose "Using psscriptroot as vmxdir"
        }
    }
    else {
        if (Test-Path $VMX_default_Path) {
            $Global:vmxdir = $VMX_default_Path	
        }
        else {
            $Global:vmxdir = $PSScriptRoot
        }
		
    }
}
else {
    $Global:vmxdir = $VMX_Path
}

#### Some vmx API error handlers :-) false positives from experience
$Global:VMrunErrorCondition = @(
    "Waiting for Command execution Available",
    "Error",
    "Unable to connect to host.",
    "Error: Unable to connect to host.",
    "Error: The operation is not supported for the specified parameters",
    "Unable to connect to host. Error: The operation is not supported for the specified parameters",
    "Error: The operation is not supported for the specified parameters",
    "Error: vmrun was unable to start. Please make sure that vmrun is installed correctly and that you have enough resources available on your system.",
    "Error: The specified guest user must be logged in interactively to perform this operation",
    "Error: A file was not found",
    "Error: VMware Tools are not running in the guest",
    "Error: The VMware Tools are not running in the virtual machine" )
if (!$GLobal:VMware_packer) {
    Write-Warning "Please install 7za/p7zip, otherwise labbtools can not expand OS Masters"
}
if ($OS_Version) {
    Write-Host -ForegroundColor Gray " ==> $OS_Version"
}
else	{
    Write-Host "Error detecting OS"
    Break
}
Write-Host -ForegroundColor Gray " ==> Running VMXToolkit for $Global:VMXToolkit_type"
Write-Host -ForegroundColor Gray " ==> vmrun path is $Global:vmrun"
Write-Host -ForegroundColor Gray " ==> VMware path is $Global:VMwarepath"
if ($VMX_Path) {
    Write-Host -ForegroundColor Gray " ==> Using virtual machine directory from module load: $Global:vmxdir"
}
else {
    Write-Host -ForegroundColor Gray " ==> Using virtual machine directory from $defaultselection`: $Global:vmxdir"
}	
Write-Host -ForegroundColor Gray " ==> Running VMware version $Global:VMwareversion"
Write-Host -ForegroundColor Gray " ==> OVFtool is $Global:VMware_OVFTool"
Write-Host -ForegroundColor Gray " ==> Packertool is $GLobal:VMware_packer"
Write-Host -ForegroundColor Gray " ==> vdisk manager is $Global:VMware_vdiskmanager"
Write-Host -ForegroundColor Gray " ==> webrequest tool is $webrequestor"
Write-Host -ForegroundColor Gray " ==> isotool is $Global:mkisofs"