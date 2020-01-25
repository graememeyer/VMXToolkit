<#	
	.SYNOPSIS
		A brief description of the Get-VMX function.
	
	.DESCRIPTION
		A detailed description of the Get-VMX function.
	
	.PARAMETER Name
		Please specify an optional VM Name
	
	.PARAMETER Path
		Please enter an optional root Path to your VMs (default is vmxdir)
	
	.EXAMPLE
		PS C:\> Get-VMX -VMXName $value1 -Path $value2
	
	.NOTES
		Additional information about the function.
#>

function Get-VMX {
    [CmdletBinding(HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMX/")]
    param (
        [Parameter(ParameterSetName = "1", Position = 1, HelpMessage = "Please specify an optional VM Name", Mandatory = $false)]
        [Parameter(ParameterSetName = "2", Mandatory = $false)]$VMXName,
        [Parameter(ParameterSetName = "1", HelpMessage = "Please enter an optional root Path to you VMs (default is vmxdir)", Mandatory = $false)]
        $Path = $vmxdir,
        [Parameter(ParameterSetName = "1", Mandatory = $false)]$UUID,
        [Parameter(ParameterSetName = "2", Position = 2, HelpMessage = "Please specify a config to vmx", Mandatory = $true)][System.IO.FileInfo]$config

    )

    begin
    { }
    process {
        $vmxrun = (Get-VMXRun).config
        $Configfiles = @()
        switch ($PsCmdlet.ParameterSetName) {
            "1" { 
                Write-Verbose "Getting vmxname from parameterset 1"
                if ($VMXName) {
                    $VMXName = $VMXName.TrimStart(".\")
                    $VMXName = $VMXName.TrimEnd("\")
                    $VMXName = $VMXName.TrimStart("./")
                    $VMXName = $VMXName.TrimEnd("/")
                    Write-Verbose $VMXName
                } else { 
                    $VMXName = "*"
                }
                Write-Verbose $MyInvocation.MyCommand
                if (!(Test-path $Path)) {
                    Write-Warning "VM Path $Path does currently not exist"
                    # break
                }
                if (!($Configfiles = Get-ChildItem -Path $path -Recurse -File -Filter "$VMXName.vmx" -Exclude "*.vmxf" -ErrorAction SilentlyContinue )) {
                    Write-Warning "$($MyInvocation.MyCommand) : VM $VMXName does currently not exist"
                    # break
                }

            }
				
            "2" {
                $VMXname = $config.Basename
                #$VMXName = (Split-Path -Leaf $config) -replace ".vmx",""
                if (!($Configfiles = Get-Item -Path $config -ErrorAction SilentlyContinue )) {
                    Write-Warning "$($MyInvocation.MyCommand) : VM Config for $config does currently not exist"
                    # break
                }
            }
				
        }
        #$VMX = @()
        foreach ($Config in $Configfiles) {
            Write-Verbose "getting Configfile: $($config.FullName) from parameterset 2"
            if ($Config.Extension -eq ".vmx") {
                if ($UUID) {
                    Write-Verbose $UUID
                    $VMXUUID = Get-VMXUUID -config $Config.fullname
                    If ($VMXUUID.uuid -eq $UUID) {
                        $Object = New-Object -TypeName psobject
                        $Object.pstypenames.insert(0, 'virtualmachine')
                        $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value ([string]($Config.BaseName))

                        if ($vmxrun -contains $config.FullName) {
                            $Object | Add-Member State ("running")
                        } elseif (Get-ChildItem -Filter *.vmss -Path ($config.DirectoryName)) {
                            $Object | Add-Member State ("suspended")
                        } else {
                            $Object | Add-Member State ("stopped")
                        }
                        $Object | Add-Member -MemberType NoteProperty -Name Template -Value (Get-VMXTemplate -config $Config).template
                        $Object | Add-Member -MemberType NoteProperty -Name ActivationPreference -Value (Get-VMXActivationPreference -config $Config -VMXName $Config.BaseName).ActivationPreference
                        $Object | Add-Member -MemberType NoteProperty -Name Scenario -Value (Get-VMXscenario -config $Config -VMXName $Config.BaseName) #.Scenario
                        $Object | Add-Member -MemberType NoteProperty -Name UUID -Value (Get-VMXUUID -config $Config.FullName).uuid
                        $Object | Add-Member -MemberType NoteProperty -Name Config -Value ([string]($Config.FullName))
                        $Object | Add-Member -MemberType NoteProperty -Name Path -Value ([string]($Config.Directory))
                        $Object | Add-Member -MemberType NoteProperty -Name VMXSnapConfig -Value ([string](Get-ChildItem -Path $Config.Directory -Filter "*.vmsd").Fullname)
                        Write-Verbose "Config Fullname $($Config.Fullname)"
                        Write-Output $Object
                    }# end if
				
                }#end-if uuid
                if (!($UUID)) {				
                    $Object = New-Object -TypeName psobject
                    $Object.pstypenames.insert(0, 'virtualmachine')
                    $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value ([string]($Config.BaseName))
                    if ($vmxrun -contains $config.fullname) {
                        $Object | Add-Member State ("running")
                    } elseif (Get-ChildItem -Filter *.vmss -Path ($config.DirectoryName)) {
                        $Object | Add-Member State ("suspended")
                    } else {
                        $Object | Add-Member State ("stopped")
                    }
                    $Object | Add-Member -MemberType NoteProperty -Name Template -Value (Get-VMXTemplate -Config $Config).template
                    $Object | Add-Member -MemberType NoteProperty -Name ActivationPreference -Value (Get-VMXActivationPreference -config $Config -VMXName $Config.BaseName).ActivationPreference
                    $Object | Add-Member -MemberType NoteProperty -Name Scenario -Value (Get-VMXscenario -config $Config -VMXName $Config.BaseName | Select-Object scenario, scenarioname)# .Scenario
                    $Object | Add-Member -MemberType NoteProperty -Name UUID -Value (Get-VMXUUID -config $Config.FullName).uuid
                    $Object | Add-Member -MemberType NoteProperty -Name Config -Value ([string]($Config.FullName))
                    $Object | Add-Member -MemberType NoteProperty -Name Path -Value ([string]($Config.Directory))
                    $Object | Add-Member -MemberType NoteProperty -Name VMXSnapConfig -Value ([string](Get-ChildItem -Path $Config.Directory -Filter "*.vmsd").Fullname)
                    Write-Output $Object
                }
                #}#end template
            }#end if
            
		     
        }
    }

    end { }
}