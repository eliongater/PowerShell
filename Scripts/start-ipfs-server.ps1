<#
.SYNOPSIS
	Start an IPFS server 
.DESCRIPTION
	This PowerShell script starts a local IPFS server as a daemon process.
.EXAMPLE
	PS> ./start-ipfs-server
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

try {
	$StopWatch = [system.diagnostics.stopwatch]::startNew()

	Write-Host "⏳ (1/5) Searching for IPFS executable...  " -noNewline
	& ipfs --version
	if ($lastExitCode -ne "0") { throw "Can't execute 'ipfs' - make sure IPFS is installed and available" }
	"⏳ (2/5) Init IPFS with profile 'lowpower'..."
	& ipfs init --profile lowpower

	"⏳ (3/5) Configuring IPFS..."
	& ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
	if ($lastExitCode -ne "0") { throw "'ipfs config Addresses.API' failed with exit code $lastExitCode" }

	& ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8765
	if ($lastExitCode -ne "0") { throw "'ipfs config Addresses.Gateway' failed with exit code $lastExitCode" }

	$Hostname = $(hostname)
	& ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '[\"http://miami:5001\", \"http://localhost:3000\", \"http://127.0.0.1:5001\", \"https://webui.ipfs.io\"]'
	if ($lastExitCode -ne "0") { throw "'ipfs config Access-Control-Allow-Origin' failed with exit code $lastExitCode" }

	& ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '[\"PUT\", \"POST\"]'
	if ($lastExitCode -ne "0") { throw "'ipfs config Access-Control-Allow-Methods' failed with exit code $lastExitCode" }

	& ipfs config --json AutoNAT.Throttle.GlobalLimit 1 # (30 by default)
	if ($lastExitCode -ne "0") { throw "'ipfs config AutoNAT.Throttle.GlobalLimit 1' failed with exit code $lastExitCode" }

	& ipfs config --json AutoNAT.Throttle.PeerLimit 1 # (3 by default)
	if ($lastExitCode -ne "0") { throw "'ipfs config AutoNAT.Throttle.PeerLimit 1' failed with exit code $lastExitCode" }
	""
	Write-Host "⏳ (4/5) Increasing UDP receive buffer size..." -noNewline
	& sudo sysctl -w net.core.rmem_max=2500000
	if ($lastExitCode -ne "0") { throw "'sysctl' failed with exit code $lastExitCode" }
	"⏳ (5/5) Starting IPFS daemon..."
#	Start-Process nohup 'ipfs daemon'
	Start-Process nohup -ArgumentList 'ipfs','daemon' -RedirectStandardOutput "$HOME/console.out" -RedirectStandardError "$HOME/console.err"

	[int]$Elapsed = $StopWatch.Elapsed.TotalSeconds
	"✔️  started IPFS server in $Elapsed sec"
	"⚠️ NOTE: make sure your router does not block TCP/UDP port 4001 for IPv4 and IPv6"
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
