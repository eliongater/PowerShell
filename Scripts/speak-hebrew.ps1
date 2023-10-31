<#
.SYNOPSIS
	Speaks text in Hebrew
.DESCRIPTION
	This PowerShell script speaks the given text with a Hebrew text-to-speech (TTS) voice.
.PARAMETER text
	Specifies the Hebrew text to speak
.EXAMPLE
	PS> ./speak-hebrew.ps1 "שלום"
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

param([string]$text = "")

try {
	if ($text -eq "") { $text = Read-Host "Enter the Hebrew text to speak" }

	$TTS = New-Object -ComObject SAPI.SPVoice
	foreach ($voice in $TTS.GetVoices()) {
		if ($voice.GetDescription() -like "*- Hebrew*") {
			$TTS.Voice = $voice
			[void]$TTS.Speak($text)
			exit 0 # success
		}
	}
	throw "No Hebrew text-to-speech voice found - please install one."
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
