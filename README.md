
## VMXToolkit
===========

VMXToolkit is a fork of Karsten Bott's [vmxtoolkit](https://github.com/bottkars/vmxtoolkit). I am in the process of cleaning up documentation, code formatting and translating comments and documentation to English. 

VMXToolkit is the Powershell extension to VMware Workstation and Fusion
VMXToolkit is community-driven
VMXToolkit is the Base for labbuildr, the automated lab building environment for VMware workstation on windows
you get support for labbuildr on github
https://github.com/bottkars/labbuildr/wiki

![logo](https://cloud.githubusercontent.com/assets/8255007/17695850/ce034d40-63aa-11e6-8cb7-69a9b914334d.gif)

Simply follow @sddc_guy on twitter for updates

## Installation  
===========
For powershell 5 of higher, you can use:
```Powershell
install-module VMXToolkit
```
to install the module using the nuget provider.

To install on earlier versions, simply extract the VMXToolkit zip into a folder where your VM´s reside.

Per Default, VMXToolkit searches from that path. Otherwise, specify the path to your VM when doing a Get-VMX command.

## Installation on OSX 
To run VMXToolkit on OSX, you need to have PowerShell for OSX installed.

See [PowerShell for OSX](https://github.com/PowerShell/PowerShell/blob/master/docs/installation/linux.md#os-x-1011) for instructions.

It is also recommended to install .NET Core for OSX. For details on installation of .NET Core LIBS see [.NET Core on MACOS](https://www.microsoft.com/net/core#macos)   

OSX port is currently only available via Git clone. No auto installer.

Use:
```Bash```
git clone https://github.com/bottkars/VMXToolkit
``````

Current exposed commands
===========  

```Powershell
 PS E:\GitHub> Get-Command -Module VMXToolkit

CommandType     Name                                               ModuleName
-----------     ----                                               ----------
Function        Add-VMXScsiDisk                                    VMXToolkit
Function        Connect-VMXNetworkAdapter                          VMXToolkit
Function        convert-VMXdos2unix                                VMXToolkit
Function        Copy-VMXDirHost2Guest                              VMXToolkit
Function        copy-VMXfile2guest                                 VMXToolkit
Function        Disconnect-VMXNetworkAdapter                       VMXToolkit
Function        Get-VMwareVersion                                  VMXToolkit
Function        Get-VMX                                            VMXToolkit
Function        Get-VMXActivationPreference                        VMXToolkit
Function        Get-VMXAnnotation                                  VMXToolkit
Function        Get-VMXConfig                                      VMXToolkit
Function        Get-VMXConfigVersion                               VMXToolkit
Function        Get-VMXDisplayName                                 VMXToolkit
Function        Get-VMXGuestOS                                     VMXToolkit
Function        Get-VMXHWVersion                                   VMXToolkit
Function        Get-VMXIdeDisk                                     VMXToolkit
Function        Get-VMXInfo                                        VMXToolkit
Function        Get-VMXIPAddress                                   VMXToolkit
Function        Get-VMXmemory                                      VMXToolkit
Function        Get-VMXNetwork                                     VMXToolkit
Function        Get-VMXNetworkAdapter                              VMXToolkit
Function        Get-VMXNetworkAddress                              VMXToolkit
Function        Get-VMXNetworkConnection                           VMXToolkit
Function        Get-VMXProcessesInGuest                            VMXToolkit
Function        Get-VMXProcessor                                   VMXToolkit
Function        Get-VMXRun                                         VMXToolkit
Function        Get-VMXscenario                                    VMXToolkit
Function        Get-VMXScsiController                              VMXToolkit
Function        Get-VMXScsiDisk                                    VMXToolkit
Function        Get-VMXSnapshot                                    VMXToolkit
Function        Get-VMXSnapshotconfig                              VMXToolkit
Function        Get-VMXTemplate                                    VMXToolkit
Function        Get-VMXToolsState                                  VMXToolkit
Function        Get-VMXUUID                                        VMXToolkit
Function        Get-yesnoabort                                     VMXToolkit
Function        Invoke-VMXBash                                     VMXToolkit
Function        Invoke-VMXexpect                                   VMXToolkit
Function        Invoke-VMXPowerShell                               VMXToolkit
Function        New-VMXClone                                       VMXToolkit
Function        New-VMXGuestPath                                   VMXToolkit
Function        New-VMXLinkedClone                                 VMXToolkit
Function        New-VMXScsiDisk                                    VMXToolkit
Function        New-VMXSnapshot                                    VMXToolkit
Function        Optimize-VMXDisk                                   VMXToolkit
Function        remove-vmx                                         VMXToolkit
Function        Remove-VMXserial                                   VMXToolkit
Function        Remove-VMXSnapshot                                 VMXToolkit
Function        Repair-VMXDisk                                     VMXToolkit
Function        Resize-VMXDiskfile                                 VMXToolkit
Function        Restore-VMXSnapshot                                VMXToolkit
Function        Search-VMXPattern                                  VMXToolkit
Function        Set-VMXActivationPreference                        VMXToolkit
Function        Set-VMXAnnotation                                  VMXToolkit
Function        Set-VMXDisconnectIDE                               VMXToolkit
Function        Set-VMXDisplayName                                 VMXToolkit
Function        Set-VMXLinuxDNS                                    VMXToolkit
Function        Set-VMXLinuxNetwork                                VMXToolkit
Function        Set-VMXMainMemory                                  VMXToolkit
Function        Set-VMXmemory                                      VMXToolkit
Function        Set-VMXNetworkAdapter                              VMXToolkit
Function        Set-VMXprocessor                                   VMXToolkit
Function        Set-VMXscenario                                    VMXToolkit
Function        Set-VMXserialPipe                                  VMXToolkit
Function        Set-VMXSharedFolder                                VMXToolkit
Function        Set-VMXSharedFolderState                           VMXToolkit
Function        Set-VMXSize                                        VMXToolkit
Function        Set-VMXTemplate                                    VMXToolkit
Function        Set-VMXToolsReminder                               VMXToolkit
Function        Set-VMXVnet                                        VMXToolkit
Function        Start-VMX                                          VMXToolkit
Function        Stop-VMX                                           VMXToolkit
Function        Suspend-VMX                                        VMXToolkit
``` 

Help
===========
while commands are self explaining, there is an online help available get-help [command] -online
Contributing
===========
Please contribute in any way to the project. Specifically, normalizing differnet image sizes, locations, and intance types would be easy adds to enhance the usefulness of the project.

Licensing
===========
Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

Support
===========
Please file bugs and issues at the Github issues page. The code and documentation are released with no warranties or SLAs and are intended to be supported through a community driven process.
