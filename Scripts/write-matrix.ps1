<#
.SYNOPSIS
        Writes the matrix
.DESCRIPTION
        This PowerShell script writes the animated Matrix.
.EXAMPLE
        PS> ./write-matrix.ps1
.LINK
        https://github.com/fleschutz/PowerShell
.NOTES
        Author: Markus Fleschutz | License: CC0
#>

function CalculateMatrix { param([int]$pos, [char]$letter)
	[int]$width = $rui.MaxWindowSize.Width
	[int]$height = $rui.MaxWindowSize.Height
	[int]$y = 0
	for ([int]$x = 0; $x -lt $width; $x++) {
		if ($x -eq $pos) {
			$global:buf[$y * $width + $x] = $letter
		} else {
			$global:buf[$y * $width + $x] = [char]32
		}
	}
	for ([int]$y = ($height - 1); $y -gt 0; $y--) { 
		for ([int]$x = 0; $x -lt $width; $x++) { 
			$global:buf[$y * $width + $x] = $global:buf[($y - 1) * $width + $x]
		} 
	}
}

function NextLetter {
	if ($global:index -eq 6) { $global:index = 0; $global:pos = [int]$global:generator.next(0, $rui.MaxWindowSize.Width) }
	switch($global:index++) {
	0 { return 'X' }
	1 { return 'I' }
	2 { return 'R' }
	3 { return 'T' }
	4 { return 'A' }
	5 { return 'M' }
	}
}

$ui = (Get-Host).ui
$rui = $ui.rawui
$buffer0 = ""
1..($rui.MaxWindowSize.Width * $rui.MaxWindowSize.Height) | foreach { $buffer0 += " " }
$global:buf = $buffer0.ToCharArray()
$global:generator = New-Object System.Random
$global:pos = [int]$global:generator.next(0, $rui.MaxWindowSize.Width)
$global:index = 0

while ($true) {	
	$letter = NextLetter
	CalculateMatrix $global:pos $letter
	[console]::SetCursorPosition(0,0)
	[string]$screen = New-Object system.string($global:buf, 0, $global:buf.Length)
	Write-Host -foreground green $screen -noNewline
	Start-Sleep -milliseconds 30
}
exit 0 # success

