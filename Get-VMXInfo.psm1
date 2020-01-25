<#	
	.SYNOPSIS
	    Get-VMXInfo
	
	.DESCRIPTION
		Displays Information on Virtual machines
        Memory Consumption
        Memory: the Amount of Memory configured in .vmx for the Virtual Machine
        PhysicalMemory(WorkingSet) :The amount of physical memory, in bytes, allocated for the associated process
        VirtualMemory: The amount of virtual memory, in bytes, allocated for the associated process
        Privatememory: The amount of memory, in bytes, allocated for the associated process that cannot be shared with other processes
        NonpagedMemory: (perfmon: Nonpaged Bytes )The amount of system memory, in bytes, allocated for the associated process that cannot be written to the virtual memory paging file
        Pagedmemory: The amount of memory, in bytes, allocated in the virtual memory paging file for the associated process
        Privatememory: The amount of memory, in bytes, allocated for the associated process that cannot be shared with other processes
        PagedsystemMemory: The amount of system memory, in bytes, allocated for the associated process that can be written to the virtual memory paging file

	
	.EXAMPLE
		PS C:\> Get-VMXinfo
    .EXAMPLE
	.NOTES
		requires VMXToolkit loaded
#>
function Get-VMXInfo {
    [CmdletBinding(DefaultParametersetName = "2", HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXInfo/")]
    param (
		
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('NAME', 'CloneName')]$VMXName,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateScript( { Test-Path -Path $_ })]$Path,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config
    )
    Begin {

    }
    process {
        switch ($PsCmdlet.ParameterSetName) {
            "1"
            { $vmxconfig = Get-VMXConfig -VMXName $VMXname -Path $Path }
		
            "2"
            { $vmxconfig = Get-VMXConfig -config $config }
        }
        if ($vmxconfig) {
            $ErrorActionPreference = "silentlyContinue"
            Write-Verbose "processing $vmxname"
            Write-Verbose $config
            $Processes = ""
            [bool]$ismyvmx = $false
            [uint64]$SizeOnDiskinMB = ""
            $Processes = get-process -id (Get-WmiObject -Class win32_process | Where-Object commandline -match $config.replace('\', '\\')).handle
            foreach ($Process in $Processes) {
                if ($Process.ProcessName -ne "VMware") {
                    Write-Verbose "processing objects for $vmxname"
                    $vmxconfig = Get-VMXConfig -config $config
                    $Object = New-Object psobject
                    $Object.pstypenames.insert(0, 'virtualmachineinfo')
                    $Object | Add-Member VMXName ([string]$vmxname)
                    $Object | Add-Member DisplayName (Get-VMXDisplayName -vmxconfig $vmxconfig).DisplayName
                    $Object | Add-Member GuestOS (Get-VMXGuestOS -vmxconfig $vmxconfig).GuestOs
                    $Object | Add-Member Processor (Get-VMXProcessor -vmxconfig $vmxconfig).Processor
                    $Object | Add-Member Memory (Get-VMXmemory -vmxconfig $vmxconfig).Memory
                    if ($Processes) {
                        $Object | Add-Member ProcessName ([string]$Process.ProcessName)
                        $Object | Add-Member VirtualMemory ([uint64]($Process.VirtualMemorySize64 / 1MB))
                        $Object | Add-Member PhysicalMemory ([uint64]($Process.WorkingSet64 / 1MB))
                        $Object | Add-Member PrivateMemory ([uint64]($Process.PrivateMemorySize64 / 1MB))
                        $Object | Add-Member PagedMemory ([uint64]($Process.PagedMemorySize64 / 1MB))
                        $Object | Add-Member PagedsystemMemory ([uint64]($Process.PagedSystemMemorySize64 / 1MB))
                        $Object | Add-Member PeakPagedMemory ([uint64]($Process.PeakPagedMemorySize64 / 1MB))
                        $Object | Add-Member PeakPhysicalMemory ([uint64]($Process.PeakWorkingSet64 / 1MB))
                        $Object | Add-Member NonPagedMemory ([uint64]($Process.NonpagedSystemMemorySize64 / 1MB))
                        $Object | Add-Member CPUtime ($Process.CPU)
                    }
                    $Object | Add-Member NetWork (Get-VMXNetwork -vmxconfig $vmxconfig | Select-Object Adapter, Network)
                    $Object | Add-Member Adapter (Get-VMXNetworkAdapter -vmxconfig $vmxconfig | Select-Object Adapter, Type )
                    $Object | Add-Member Connection (Get-VMXNetworkConnection -vmxconfig $vmxconfig | Select-Object Adapter, ConnectionType)
					
                    $Object | Add-Member Configfile $config
                    $Object | Add-Member -MemberType NoteProperty -Name SCSIController -Value (Get-VMXScsiController -vmxconfig $vmxconfig | Select-Object SCSIController, Type)
                    $Object | Add-Member -MemberType NoteProperty -Name ScsiDisk -Value (Get-VMXScsiDisk -vmxconfig $vmxconfig | Select-Object SCSIAddress, Disk)
                    Write-Output $Object
					
                } #end if $Process.ProcessName -ne "VMware"
            } #  end foreach process
        }# end if $VMXconfig
    } # endprocess
    # 
} # end Get-VMXinfo