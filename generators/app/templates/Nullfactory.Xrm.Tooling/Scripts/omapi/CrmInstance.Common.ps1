function Init-OmapiModule($username, $password)
{
    if (-Not (Get-Module -ListAvailable -Name Microsoft.Xrm.OnlineManagementAPI)) {
        Write-Verbose "Initializing Microsoft.Xrm.OnlineManagementAPI module ..."
        Install-Module -Name Microsoft.Xrm.OnlineManagementAPI -Scope CurrentUser -ErrorAction SilentlyContinue -Force
    }

    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    return $creds  = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
}

<#
	.SYNOPSIS
			Retrieves the unique identifier of a CRM instance.
	.DESCRIPTION
			Retrieves the unique identifier of a CRM instance using its friendly or unique name. If one does not exist, an error is thrown.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.4.0
	.LINK
		https://nullfactory.net
	.PARAMETER apiUrl
		The API service url for the tenant.
	.PARAMETER credentials
		The credentials used to access the API Service.
	.PARAMETER friendlyName
		The friendly name of the CRM instance.
	.PARAMETER uniqueName
		The unique name of the CRM Instance.
	.EXAMPLE
		$creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
		$instanceId = Get-CrmInstanceByName("https://admin.services.crm6.dynamics.com",  $creds "SuperFriendlyName", "")
#>
function Get-CrmInstanceByName($apiUrl, $credentials, $friendlyName, $uniqueName)
{
    if ($friendlyName)
    {
        # retrieve instance using friendly name
        $instance = Get-CrmInstances -ApiUrl $apiUrl -Credential $credentials | ? {$_.FriendlyName -eq $friendlyName }
    }
    elseif($uniqueName)
    {
        # retrieve instance using the unique name
        $instance = Get-CrmInstances -ApiUrl $apiUrl -Credential $credentials | ? {$_.UniqueName -eq $uniqueName }
    }
    else
    {
        throw "Unable to resolve unique CRM instance identifier."
    }

    return $instance.Id;
}


function Get-AvailableCrmInstances($apiUrl, $credentials)
{
    $instances = Get-CrmInstances -ApiUrl $apiUrl -Credential $credentials
    return $instances;
}

function Get-AvailableCrmTemplates($apiUrl, $credentials)
{
    $crmTemplates = Get-CrmTemplates -ApiUrl $apiUrl -Credential $credentials

    return $crmTemplates
}

function Get-CrmInstanceBackupByLabel($apiUrl, $credentials, $instanceId, $backupLabel)
{
    if(-Not $backupLabel)
    {
        throw "Unable to resolve unique instance backup identifier.";
    }

    $backups = Get-CrmInstanceBackups -ApiUrl $apiUrl -Credential $credentials -InstanceId $instanceId
    $backup = $backups | ? {$_.Label -eq $backupLabel } | Select-Object -First 1

    return $backup.Id
}


function  Get-CrmServiceVersionByName($apiUrl, $credentials, $serviceVersionName)
{
    if(-Not $serviceVersionName)
    {
        Write-Verbose "Service version name not provided. Attempting to select first service version..."
        # todo: figure out why inline select-object behaves differently
        $svs = Get-CrmServiceVersions -ApiUrl $apiUrl -Credential $credentials
        $serviceVersion = $svs | Select-Object -First 1
    }
    else
    {
        Write-Verbose "Attempting resolve service version by name $serviceVersionName"
        $serviceVersion = Get-CrmServiceVersions -ApiUrl $apiUrl -Credential $credentials | ? {$_.Name -eq $serviceVersionName } | Select-Object -First 1
    }

    $serviceVersionId = $serviceVersion.Id;

    Write-Verbose "ServiceVersionId: $serviceVersionId"

    return $serviceVersionId;
}

function Wait-CrmOperation (
	[parameter(Mandatory=$true,ParameterSetName = "OperationId")]
	[parameter(Mandatory=$true,ParameterSetName = "Operation")]
	[string]$apiUrl,
	[parameter(Mandatory=$true,ParameterSetName = "OperationId")]
	[parameter(Mandatory=$true,ParameterSetName = "Operation")]
	[System.Management.Automation.PSCredential]$credentials,
	[parameter(Mandatory=$true,ParameterSetName = "OperationId")]
	[guid]$operationId,
	[parameter(Mandatory=$true,ParameterSetName = "Operation")]
  [Microsoft.Xrm.Services.Admin.Client.Models.OperationStatus]$operation)
{
    if($operationId -eq "00000000-0000-0000-0000-000000000000")
    {
        Write-Verbose "Invalid operationId, exiting."
        exit 0
    }

    Write-Host "Waiting for operation completion..."

    $timeout = new-timespan -Minutes 5
    $sw = [diagnostics.stopwatch]::StartNew()
    while ($sw.elapsed -lt $timeout)
    {
        $opStatus = Get-CrmOperationStatus -apiUrl $apiUrl -Credential $credentials -Id $operationId

        $timeStamp = (Get-Date).ToShortTimeString()
        $statusString = $opStatus.Status;

        Write-Host "[$timeStamp]: $statusString"

        # determinate statuses
        if($opStatus.Status -eq "Succeeded")
        {
            Write-Host "Operation completed successfully!" -ForegroundColor Green
            exit 0
        }
        elseif(@("FailedToCreate", "Failed", "Cancelling", "Cancelled", "Aborting", "Aborted", "Tombstone", "Deleting", "Deleted") -contains $statusString)
        {
            $failReasons = $opStatus.ItemDescription | ? { $_.Subject }
            $failReason = $failReasons -Join ','
            throw "Operation failed. $failReason";
        }
        # indeterminate statuses
        elseif(@("None", "NotStarted", "Ready", "Pending", "Running") -contains $statusString)
        {
            Write-Verbose "Indeterminate status."
        }

        start-sleep -Seconds 60
    }
}
