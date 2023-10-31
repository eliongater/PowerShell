<#
.SYNOPSIS
	Opens Google Maps
.DESCRIPTION
	This PowerShell script launches the Web browser with the Google Maps website.
.EXAMPLE
	PS> ./open-google-maps
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

& "$PSScriptRoot/open-default-browser.ps1" "https://www.google.com/maps"
exit 0 # success
