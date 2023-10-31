<#
.SYNOPSIS
	Writes text as marquee
.DESCRIPTION
	This PowerShell script writes the given text as marquee.
.PARAMETER text
	Specifies the text to write
.PARAMETER speed
	Specifies the marquee speed (60 ms per default)
.EXAMPLE
	PS> ./write-marquee "Hello World"
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

param([string]$Text = "PowerShell is powerful - fully control your computer! PowerShell is cross-platform - available for Linux, Mac OS and Windows! PowerShell is open-source and free - see the GitHub repository at github.com/PowerShell/PowerShell! PowerShell is easy to learn - see the tutorial for beginners at guru99.com/powershell-tutorial.html! Powershell is fully documented - see the official PowerShell documentation at docs.microsoft.com/en-us/powershell", [int]$Speed = 60) # 60 ms pause

function StartMarquee { param([string]$Line)
	"╔══════════════════════════════════════════════════════════════════════════════════╗"
	"║                                                                                  ║"
	"╚══════════════════════════════════════════════════════════════════════════════════╝"
	$LinePos = $HOST.UI.RawUI.CursorPosition
	$LinePos.X = 2
	$LinePos.Y -= 2
	foreach($Pos in 1 .. $($Line.Length - 80)) {
		$HOST.UI.RawUI.CursorPosition = $LinePos
		Write-Host -noNewLine "$($Line.Substring($Pos,80))"
		Start-Sleep -milliseconds $Speed
	}
	" "
	" "
	" "
}

StartMarquee "                                                                                    +++ $Text +++ $Text +++ $Text +++ $Text +++ $Text +++ $Text +++ $Text +++ $Text +++ $Text +++ $Text +++ $Text +++ $Text +++                                                                                         "
exit 0 # success