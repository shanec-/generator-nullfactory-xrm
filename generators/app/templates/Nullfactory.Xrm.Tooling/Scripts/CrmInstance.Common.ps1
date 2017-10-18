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


function Get-CrmInstanceBackupByLabel($apiUrl, $credentials, $instanceBackupLabel)
{
    if(-Not $instanceBackupLabel)
    {
        throw "Unable to resolve unique instance backup identifier.";
    }

    $instance = Get-CrmInstanceBackups -ApiUrl $apiUrl | ? {$_.Label -eq $instanceBackupLabel } | Select-Object -First 1

    return $instance.Id;
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

function Wait-CrmOperation ($apiUrl, $credentials, $operationId)
{
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
        elseif(@("FailedToCreate", "Failed", "Cancelling", "Cancelled", "Aborting", "Aborted", "Tombstone", "Deleting", "Deleted") -contains $opStatus)
        {
            throw "Operation failed";
        }
        # indeterminate statuses
        elseif(@("None", "NotStarted", "Ready", "Pending", "Running") -contains $opStatus)
        {
            Write-Verbose "Indeterminate status."
        }
    
        start-sleep -Seconds 60
    }
}