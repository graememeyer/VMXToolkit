<#	
	.SYNOPSIS
	Get-VMwareVersion
	.DESCRIPTION
		Displays version information on installed VMware version
	.EXAMPLE
		PS C:\> Get-VMwareVersion
	.NOTES
		Requires VMXToolkit loaded
#>

function Get-VMwareVersion
{
	[CmdletBinding(HelpUri = "http://labbuildr.bottnet.de/modules/get-vmwareversion/")]
	param ()
begin {}
process {
    }
end {
    Write-Output $vmwareversion
    }
} 
