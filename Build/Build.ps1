[CmdletBinding()]
Param(
  [Parameter()] [string] $NugetExecutable = "Shared\.nuget\nuget.exe",
  [Parameter()] [string] $Configuration = "Debug",
  [Parameter()] [string] $Version = "0.0.0.1",
  [Parameter()] [string] $BranchName,
  [Parameter()] [string] $CoverageBadgeUploadToken,
  [Parameter()] [string] $NugetPushKey
)

Set-StrictMode -Version 2.0; $ErrorActionPreference = "Stop"; $ConfirmPreference = "None"
trap { $error[0] | Format-List -Force; $host.SetShouldExit(1) }

. Shared\Build\BuildFunctions

$BuildOutputPath = "Build\Output"
$SolutionFilePath = "Roflcopter.sln"
$MSBuildPath = (Get-ChildItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\*\MSBuild\15.0\Bin\MSBuild.exe").FullName
$NUnitAdditionalArgs = "--x86 --labels=All --agents=1"
$NUnitTestAssemblyPaths = @(
    "Src\Roflcopter.Plugin.Tests\bin\RS20172\$Configuration\Roflcopter.Plugin.Tests.RS20172.dll"
    "Src\Roflcopter.Plugin.Tests\bin\RS20173\$Configuration\Roflcopter.Plugin.Tests.RS20173.dll"
    "Src\Roflcopter.Plugin.Tests\bin\RD20173\$Configuration\Roflcopter.Plugin.Tests.RD20173.dll"
)
$NUnitFrameworkVersion = "net-4.5"
$TestCoverageFilter = "+[Roflcopter*]* -[Roflcopter*]ReSharperExtensionsShared.*"
$NuspecPath = "Src\Roflcopter.Plugin\Roflcopter.nuspec"
$NugetPackProperties = @(
    "Version=$(CalcNuGetPackageVersion 20172);Configuration=$Configuration;DependencyVer=[9.0];BinDirInclude=bin\RS20172"
    "Version=$(CalcNuGetPackageVersion 20173);Configuration=$Configuration;DependencyVer=[11.0];BinDirInclude=bin\RS20173"
)
$RiderPluginProject = "Src\RiderPlugin"
$NugetPushServer = "https://www.myget.org/F/ulrichb/api/v2/package"

Clean
PackageRestore
Build
NugetPack
BuildRiderPlugin
Test

if ($NugetPushKey) {
    NugetPush
}
