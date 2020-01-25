﻿#
# Modulmanifest für das Modul "VMXToolkit"
#
# Generiert von: Karsten Bott
#
# Generiert am: 26.04.2014
#
@{
# Die diesem Manifest zugeordnete Skript- oder Binärmoduldatei.
RootModule = 'VMXToolkit.psm1'
# ModuletoProcess = 'VMXToolkit.psm1'
# Die Versionsnummer dieses Moduls
ModuleVersion = '4.5.3.1'
# ID zur eindeutigen Kennzeichnung dieses Moduls
GUID = 'abe3797c-5a42-4e80-a1fb-9e648872ee14'
# Autor dieses Moduls
Author = 'Karsten Bott'

# Unternehmen oder Hersteller dieses Moduls
CompanyName = 'labbuildr'
# Urheberrechtserklärung für dieses Modul
Copyright = '(c) 2014 Karsten Bott. Alle Rechte vorbehalten.
      Copyright 2014 Karsten Bott

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

'

# Beschreibung der von diesem Modul bereitgestellten Funktionen
Description = 'Powershell Modules for VMware Workstation on Windows/Linux and VMware Fusion on OSX, see https://github.com/bottkars/VMXToolkit for details'

# Die für dieses Modul mindestens erforderliche Version des Windows PowerShell-Moduls
PowerShellVersion = '3.0'

# Der Name des für dieses Modul erforderlichen Windows PowerShell-Hosts
# PowerShellHostName = ''

# Die für dieses Modul mindestens erforderliche Version des Windows PowerShell-Hosts
# PowerShellHostVersion = ''

# Die für dieses Modul mindestens erforderliche Microsoft .NET Framework-Version
# DotNetFrameworkVersion = ''

# Die für dieses Modul mindestens erforderliche Version der CLR (Common Language Runtime)
# CLRVersion = ''

# Die für dieses Modul erforderliche Prozessorarchitektur ("Keine", "X86", "Amd64").
# ProcessorArchitecture = ''

# Die Module, die vor dem Importieren dieses Moduls in die globale Umgebung geladen werden müssen
# RequiredModules = @()

# Die Assemblys, die vor dem Importieren dieses Moduls geladen werden müssen
# RequiredAssemblies = @()

# Die Skriptdateien (PS1-Dateien), die vor dem Importieren dieses Moduls in der Umgebung des Aufrufers ausgeführt werden.
ScriptsToProcess = @(".\VMXToolkitinit.ps1")

# Die Typdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
# TypesToProcess = @()

# Die Formatdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
FormatsToProcess = @(
'.\Formats\VMXToolkit.virtualmachine.Format.ps1xml',
'.\Formats\VMXToolkit.virtualmachineinfo.Format.ps1xml',
'.\Formats\VMXToolkit.vmxscsidisk.Format.ps1xml',
'.\Formats\VMXToolkit.vmxsharedFolder.Format.ps1xml'
)

# Die Module, die als geschachtelte Module des in "RootModule/ModuleToProcess" angegebenen Moduls importiert werden sollen.
NestedModules = @()

# Aus diesem Modul zu exportierende Funktionen
FunctionsToExport = '*'

# Aus diesem Modul zu exportierende Cmdlets
CmdletsToExport = '*'

# Die aus diesem Modul zu exportierenden Variablen
VariablesToExport = '*'

# Aus diesem Modul zu exportierende Aliase
AliasesToExport = '*'

# Liste aller Module in diesem Modulpaket
# ModuleList = @()

# Liste aller Dateien in diesem Modulpaket
FileList = @("VMXToolkitinit.ps1",
"VMXToolkit.psd1",
"VMXToolkit.psm1")

# Die privaten Daten, die an das in "RootModule/ModuleToProcess" angegebene Modul übergeben werden sollen.
# PrivateData = ''

# HelpInfo-URI dieses Moduls
# HelpInfoURI = ''

# Standardpräfix für Befehle, die aus diesem Modul exportiert werden. Das Standardpräfix kann mit "Import-Module -Prefix" überschrieben werden.
# DefaultCommandPrefix = 'vmx'

}

