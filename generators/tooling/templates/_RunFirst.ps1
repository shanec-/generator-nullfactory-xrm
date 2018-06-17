Write-Host "Initializing generator-nullfactory-xrm post-setup ..." -ForegroundColor Yellow

$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$targetNugetExe = "$env:TEMP\nuget.exe"
Write-Verbose "Nuget path resolved to: $targetNugetExe. Attempting to download..."
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe

Write-Host "Attempting to restore packages..." -ForegroundColor Yellow
. $targetNugetExe restore
Write-Verbose "Package restore successful."
Write-Verbose "Attempting to refresh Nullfactory.Xrm.Tooling project packages..."
. $targetNugetExe update .\Nullfactory.Xrm.Tooling\packages.config -Safe -FileConflictAction overwrite

if($?)
{
    Write-Verbose "Nullfactory.Xrm.Tooling package refresh successful!"
}
else
{
	throw "Nullfactory.Xrm.Tooling package refresh failed."
}

Write-Host "Operations completed successfully." -ForegroundColor Green