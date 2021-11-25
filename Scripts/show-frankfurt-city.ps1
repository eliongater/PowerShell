﻿<#
.SYNOPSIS
	Shows Frankfurt in Google Maps 
.DESCRIPTION
	This script launches the Web browser and shows the city of Frankfurt (Germany) in Google Maps.
.EXAMPLE
	PS> ./show-frankfurt-city
.NOTES
	Author: Markus Fleschutz · License: CC0
.LINK
	https://github.com/fleschutz/PowerShell
#>

& "$PSScriptRoot/open-default-browser.ps1" "https://www.google.com/maps/place/Frankfurt"
exit 0 # success