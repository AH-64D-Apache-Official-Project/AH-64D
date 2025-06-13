<# 

	.SYNOPSIS
	This script is used to manage the local dev environment for working on the AH-64 Apache mod for Arma 3. This script should be run in an elevated Powershell window.

	.DESCRIPTION
	Options available:
		1) Build PBOs
		2) Run Arma 3 Diagnostics EXE
			- requires development branch installed from Steam!
		3) Manage symlinks for file patching use
	
	.EXAMPLE
	.\build.ps1

	.LINK
	https://github.com/AH-64D-Apache-Official-Project/AH-64D

	.NOTES
	Authored by
	Indigo#6290 on Discord
	indifox.info

	On first run, Arma 3 and Arma 3 Tools installation directories will be searched for and saved to buildCfg.json in the working directory.

	File patching is available in the diag branch of A3.
	When loading files in a PBO, if file patching is enabled, it will look in the Arma 3 install root first and load files if found. This allows quick modifications without reloading the game.
#>


Clear-Host

$buildCfgSourcePath = ".\buildCfg.json"

# Load buildCfg.json
if (!(Test-Path $buildCfgSourcePath)) {
	[PSCustomObject]@{
		"addonBuilderPath" = "";
		"arma3InstallPath" = "";
	} | ConvertTo-Json | Out-File $buildCfgSourcePath
	$buildCfg = [PSCustomObject]@{
		"addonBuilderPath" = "";
		"arma3InstallPath" = "";
	}
} else {
	$buildCfg = Get-Content $buildCfgSourcePath | ConvertFrom-Json
}





# Locate A3 Tools install path from registry
if ($buildCfg.addonBuilderPath -eq "") {
	try {
		$A3ToolsPath = (Get-ItemProperty "HKCU:\SOFTWARE\Bohemia Interactive\arma 3 tools").path
	} catch {
		Write-Host -ForegroundColor Red "Unable to locate Arma 3 Tools path from registry.`nPlease ensure it's installed and/or manually define the path in buildCfg.json."
		Pause
		exit
	}
	# Append standard path to the Addonbuilder executable
	$buildCfg.addonBuilderPath = "$A3ToolsPath\AddonBuilder\Addonbuilder.exe"
}



# Arma installation path, once found, is stored in buildCfg.json to save time on future runs
$ArmaInstallPath = $buildCfg.arma3InstallPath

if ($ArmaInstallPath -eq "") {

	Write-Progress -Activity "First run: Finding Arma 3 path. . ." -Status "Checking registry. . ."
	
	$ArmaInstallPath = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object DisplayName -EQ "Arma 3" | Select-Object -ExpandProperty InstallLocation

	Start-Sleep 1

	if (!$ArmaInstallPath -or !(Test-Path $ArmaInstallPath)) {

		Write-Progress -Activity "First run: Finding Arma 3 path. . ." -Status "Checking filesystem. . ."
		
		$SearchLocations = @("${env:ProgramFiles}\Steam", "${env:ProgramFiles(x86)}\Steam")
		$SearchLocations += Get-PSDrive -PSProvider FileSystem | ForEach-Object Root | Get-ChildItem -Filter '*steam*' -Directory -EA SilentlyContinue | ForEach-Object FullName
		$ArmaInstallPath = ForEach ($Root in $SearchLocations) {
			Get-ChildItem $Root -Filter "Arma 3" -Directory -Recurse -EA SilentlyContinue | ForEach-Object FullName
		}

		if ($null -ne $ArmaInstallPath) {
			if ($ArmaInstallPath.GetType().BaseType.Name -eq "Array") {
				$buildCfg.arma3InstallPath = $ArmaInstallPath[0]
			} else {
				$buildCfg.arma3InstallPath = $ArmaInstallPath
			}
		}
	} else {
		$buildCfg.arma3InstallPath = $ArmaInstallPath
	}
}

# Save locations that had to be fixed/found
$buildCfg | ConvertTo-Json | Out-File $buildCfgSourcePath



function Start-AddonBuild {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[Array]
		$ModsToPack
	)
	# Pack each of the defined mod folders from above
	ForEach ($Mod in $ModsToPack) {

		# PROGRESS DISPLAY
		$count++
		$percentComplete = (($count / $ModsToPack.Count) * 100) - 15

		Write-Progress -Activity "Packing PBOs" -Status "@AH-64D Apache Longbow\Addons\${Mod}" -PercentComplete $percentComplete


		Start-Process -FilePath $addonBuilderExe -ArgumentList @(
			"""${gitPath}\@AH-64D Apache Longbow\Addons\${Mod}"" ",
			"""${gitPath}\@AH-64D Apache Longbow\Addons"" " +
			"""-clear"" " + 
			"""-include=${gitpath}\buildExtIncludes.txt"""
		) -Wait -RedirectStandardOutput ".\buildLog.log"

		if ((Get-Content ".\buildLog.log" -Tail 1) -match '\[ERROR\]') {
			Write-Warning "Failed to pack ${mod} into a PBO. Output below, please check."
			$recentLines = Get-Content ".\buildLog.log" -Tail 20
			forEach ($line in $recentLines) {
				if ($line -match '\[ERROR\]') {
					Write-Host -ForegroundColor Red $line
				} else {
					Write-Host $line
				}
			}
			Remove-Item ".\buildLog.log"
			Pause
			exit
		} else {
			Write-Host -ForegroundColor Green "Successfully packed ${Mod}"
			Remove-Item ".\buildLog.log"
		}
	}

	Write-Progress -Activity "Packing PBOs" -PercentComplete 100 -Completed
	Start-Sleep 1
	Clear-Host
	Write-Host `n`n`n`n`n
	Write-Host -ForegroundColor Green "BUILD TASKS COMPLETE!`n`n"
	Write-Host -ForegroundColor Cyan "Packed the following PBOs:"
	$ModsToPack
}

function Start-A3Diag {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[String]
		$diagExe,
		[Parameter(Mandatory)]
		[String]
		$a3Root
	)

	if (Test-Path $diagExe) {
		try {
			Start-Process -FilePath $diagExe -ArgumentList @(
				"-skipIntro", 
				"-noSplash", 
				# "-name=Matthew",
				"-cpuCount=3",
				"-exThreads=7",
				"-malloc=system",
				"-hugePages", "-maxmem=12800",
				"-maxvram=3384",
				"-world=empty",
				"-debug",
				"-mod=${a3Root}\!Workshop\@CBA_A3;C:\Users\Matt Desktop\Documents\AH64D-Project\@AH-64D Apache Longbow;${a3Root}\!Workshop\@Zeus Enhanced;${a3Root}\!Workshop\@ace;${a3Root}\!Workshop\@ACRE2",
				"-beservice",
				"-filePatching", "-debug", "-showScriptErrors"
			)
			Write-Host -ForegroundColor Green "ARMA 3 DIAGNOSTICS EXE HAS BEEN LAUNCHED!"
		} catch {
			Write-Warning "Could not launch Arma 3 Diagnostics EXE"
			throw $PSItem
		}
	} else {
		Write-Warning "Arma 3 Diag exe not found at path`n${diagExe}`nCould not be launched!"
	}
}


function Set-SymLinks {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[String]
		$gitPath,
		[Parameter(Mandatory)]
		[String]
		$a3Root,
		[Parameter()]
		[Switch]
		$Create,
		[Parameter()]
		[Switch]
		$Remove
	)

	if ($PSBoundParameters.ContainsKey("Create")) {
		New-Item -Path $a3Root -Name "fza_ah64_controls" -Type SymbolicLink -Value "${gitPath}\@AH-64D Apache Longbow\Addons\fza_ah64_controls"
	}

	if ($PSBoundParameters.ContainsKey("Remove")) {
		cmd /c rmdir /s /q "${a3Root}/fza_ah64_controls"
	}
}


# Local vars
$addonBuilderExe = $buildCfg.addonBuilderPath
$a3Root = $buildCfg.arma3InstallPath
$diagExe = $buildCfg.arma3InstallPath + "\arma3diag_x64.exe"
$gitPath = (Get-Location).Path



# $ModsToPack = Get-ChildItem "${gitPath}\@AH-64D Apache Longbow\Addons" -Directory | % Name
$ModsToPack = @("fza_ah64_controls", "fza_ah64_model")

$Choice = $host.ui.PromptForChoice(
	"AH-64 BUILD TOOL",
	"What would you like to do?",
	@(
		[System.Management.Automation.Host.ChoiceDescription]::new(
			"&Pack PBOs",
			"Load A3Tools Addon Builder to pack the mods into PBOs for testing."
		),
		[System.Management.Automation.Host.ChoiceDescription]::new(
			"&Run A3 Diag EXE",
			"Launch Arma 3 Diag EXE for testing."
		),
		[System.Management.Automation.Host.ChoiceDescription]::new(
			"&Both",
			"Load A3Tools Addon Builder to pack the mods into PBOs then launch Arma 3 Diag EXE for testing."
		),
		[System.Management.Automation.Host.ChoiceDescription]::new(
			"&Install 'controls' symlink",
			"Registers a symlink in the A3 root directory to your Git path's addons, only for the 'fza_ah64_controls' directory."
		),
		[System.Management.Automation.Host.ChoiceDescription]::new(
			"&Uninstall 'controls' symlink",
			"Removes the registered 'fza_ah64_controls' symlink directory from your A3 root directory."
		)
	),
	2
)

switch ($Choice) {
	0 {
		Start-AddonBuild -ModsToPack $ModsToPack
		break
	}
	1 {
		Start-A3Diag -diagExe $diagExe -a3Root $a3Root
		break
	}
	2 {
		Start-AddonBuild -ModsToPack $ModsToPack
		Start-A3Diag -diagExe $diagExe -a3Root $a3Root
		break
	}
	3 {
		Set-SymLinks -gitPath $gitPath -a3Root $a3Root -Create
		break
	}
	4 {
		Set-SymLinks -gitPath $gitPath -a3Root $a3Root -Remove
		break
	}
}

Pause