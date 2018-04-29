. .\CrmSolution.Common.ps1

$tempOutputPath =  [System.IO.Path]::GetTempPath() + "nfx-proxy-" + [System.Guid]::NewGuid()
New-Item -ItemType Directory -Path $tempOutputPath | Out-Null
Write-Host "Using temporary path $tempOutputPath"


.\crmsvcutil.exe `
		/url:"<%= crmServerUrl %>" `
		/namespace:"$gemNamespace" `
		/out:"$tempOutputPath\_OptionSets.cs" `
		/codewriterfilter:"Microsoft.Crm.Sdk.Samples.FilteringService, GeneratePicklistEnums" `
		/codecustomization:"Microsoft.Crm.Sdk.Samples.CodeCustomizationService, GeneratePicklistEnums" `
		/namingservice:"Microsoft.Crm.Sdk.Samples.NamingService, GeneratePicklistEnums" `
		/username:(Get-CrmUsername "<%= visualStudioSolutionProjectPrefix %>.<%= crmSolutionName %>") `
		/password:(Get-CrmPassword "<%= visualStudioSolutionProjectPrefix %>.<%= crmSolutionName %>")

if($KeepTemp -eq $false -and $hasError -eq $false)
{
	Write-Host "Cleaning up temp folder..." -NoNewline
	Remove-Item "$tempOutputPath\*.cs" -ErrorAction SilentlyContinue
	Write-Host "done." -ForegroundColor Green
}
else
{
	Write-Host "Skipping clean up of temporary folder $tempOutputPath";
}

# reset the folder location to the scripts folder
sl $currentFolder

Write-Host "All operations complete."
