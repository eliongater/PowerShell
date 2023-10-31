<#
.SYNOPSIS
	Plays a MP3 sound file 
.DESCRIPTION
	This PowerShell script plays a sound file in .MP3 file format.
.PARAMETER Path
	Specifies the path to the .MP3 file
.EXAMPLE
	PS> ./play-mp3 C:\thunder.mp3
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

param([string]$Path = "")

try {
	if ($Path -eq "" ) { $Path = Read-Host "Enter the path to the MP3 sound file" }

	if (-not(Test-Path "$Path" -pathType leaf)) { throw "Can't access sound file: $Path" }
	$FullPath = (Get-ChildItem $Path).fullname
	$Filename = (Get-Item "$FullPath").name

	Add-Type -assemblyName PresentationCore
	$MediaPlayer = New-Object System.Windows.Media.MediaPlayer

	do {
		$MediaPlayer.open($FullPath)
		$Milliseconds = $MediaPlayer.NaturalDuration.TimeSpan.TotalMilliseconds
	} until ($Milliseconds)

	[int]$Minutes = $Milliseconds / 60000
	[int]$Seconds = ($Milliseconds / 1000) % 60
	"▶️ Playing $Filename for $($Minutes.ToString('00')):$($Seconds.ToString('00')) sec..."
	$PreviousTitle = $host.ui.RawUI.WindowTitle 
	$host.ui.RawUI.WindowTitle = "▶️ $Filename"
	$MediaPlayer.Volume = 1
	$MediaPlayer.play()
	Start-Sleep -milliseconds $Milliseconds
	$MediaPlayer.stop()
	$MediaPlayer.close()
	$host.ui.RawUI.WindowTitle = $PreviousTitle

	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
