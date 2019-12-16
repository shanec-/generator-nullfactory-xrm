
param(
	[Parameter(Mandatory=$true)]
	[string]$serverUrl,
	[Parameter(Mandatory=$true)]
	[string]$username,
	[Parameter(Mandatory=$true)]
	[string]$password,
  [Parameter(Mandatory=$true)]
	[string]$namespace,
	[Parameter(Mandatory=$true)]
	[string]$outPath
)

# https://github.com/daryllabar/DLaB.Xrm.XrmToolBoxTools/wiki/Early-Bound-Generator

$targetNugetExe = ".\nuget.exe"
$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
Set-Alias nuget $targetNugetExe -Scope Global -Verbose

./nuget install DLaB.Xrm.EarlyBoundGenerator.Api -version 1.2019.10.27

$configFile = (Resolve-Path('.\DLaB.Xrm.EarlyBoundGenerator.Api*\content\bin\DLaB.EarlyBoundGenerator\CrmSvcUtil.exe.config')).Path
$crmUtil = (Resolve-Path('.\DLaB.Xrm.EarlyBoundGenerator.Api*\content\bin\DLaB.EarlyBoundGenerator\CrmSvcUtil.exe')).Path

Copy-Item .\DLaB.Ebg-CrmSvcUtil.exe.config $configFile.Path -Force

. $crmUtil `
    /url:$serverUrl `
    /username:$username `
    /password:$password! `
    /out:$outPath `
    /namespace:$namespace `
    /servicecontextname:"CrmServiceContext" `
    /codecustomization:"DLaB.CrmSvcUtilExtensions.Entity.CustomizeCodeDomService,DLaB.CrmSvcUtilExtensions" `
    /codegenerationservice:"DLaB.CrmSvcUtilExtensions.Entity.CustomCodeGenerationService,DLaB.CrmSvcUtilExtensions" `
    /codewriterfilter:"DLaB.CrmSvcUtilExtensions.Entity.CodeWriterFilterService,DLaB.CrmSvcUtilExtensions" `
    /namingservice:"DLaB.CrmSvcUtilExtensions.NamingService,DLaB.CrmSvcUtilExtensions" `
    /metadataproviderservice:"DLaB.CrmSvcUtilExtensions.Entity.MetadataProviderService,DLaB.CrmSvcUtilExtensions"

Remove-Item nuget.exe
Remove-Item .\DLaB.Xrm.EarlyBoundGenerator.Api* -Recurse
