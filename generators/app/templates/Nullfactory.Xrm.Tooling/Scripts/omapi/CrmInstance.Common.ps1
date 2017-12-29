<#
	.SYNOPSIS
		Initializes the Online Management API for Dynamics 365 for Customer Engagement.
	.DESCRIPTION
		Setup the pre-requisites for accessing the Online Management API and initialize PSCredentials object used by associated functions.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.6.0
	.LINK
		https://nullfactory.net
	.EXAMPLE
		Init-OmapiModule("admin@superinstance.crm6.dynamics.com", "Pass@word1")
#>
function Init-OmapiModule($username, $password)
{
    if (-Not (Get-Module -ListAvailable -Name Microsoft.Xrm.OnlineManagementAPI)) {
        Write-Verbose "Initializing Microsoft.Xrm.OnlineManagementAPI module ..."
        Install-Module -Name Microsoft.Xrm.OnlineManagementAPI -Scope CurrentUser -ErrorAction SilentlyContinue -Force
    }

    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    return New-Object System.Management.Automation.PSCredential ($username, $securePassword)
}

<#
	.SYNOPSIS
        Retrieves the unique identifier of a Dynamics 365 Customer Engagement instance.
	.DESCRIPTION
        Retrieves the unique identifier of a Dynamics 365 Customer Engagement instance using its friendly or unique name. If one does not exist, an error is thrown.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.6.0
	.LINK
		https://nullfactory.net
	.PARAMETER apiUrl
		The API service url for the tenant.
	.PARAMETER credentials
		The credentials used to access the API Service.
	.PARAMETER friendlyName
		The friendly name of the instance.
	.PARAMETER uniqueName
		The unique name of the instance.
	.EXAMPLE
		$creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
		$instanceId = Get-CrmInstanceByName("https://admin.services.crm6.dynamics.com",  $creds, "SuperFriendlyName", "")
#>
function Get-CrmInstanceByName($apiUrl, $credentials, $friendlyName, $uniqueName)
{
    if ($friendlyName)
    {
        # retrieve instance using friendly name
        $instance = Get-CrmInstances -ApiUrl $apiUrl -Credential $credentials | Where-Object {$_.FriendlyName -eq $friendlyName }
    }
    elseif($uniqueName)
    {
        # retrieve instance using the unique name
        $instance = Get-CrmInstances -ApiUrl $apiUrl -Credential $credentials | Where-Object {$_.UniqueName -eq $uniqueName }
    }

    if(-Not $instance)
    {
        throw "Unable to resolve unique instance $friendlyName $uniqueName."
    }

    $instanceId = $instance.Id

    Write-Verbose "Resolved InstanceId:  $instanceId"

    return $instanceId;
}

<#
	.SYNOPSIS
		Retrieves a list of available Dynamics 365 instances.
	.DESCRIPTION
		Retrieves a list of available Dynamics 365 instances in the Office 365 tenant.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.6.0
	.LINK
		https://nullfactory.net
	.PARAMETER apiUrl
		The API service url for the tenant.
	.PARAMETER credentials
		The credentials used to access the API Service.
	.EXAMPLE
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $creds = New-Object System.Management.Automation.PSCredential ("admin@superinstance.crm6.dynamics.com", $securePassword)
        Get-AvailableCrmInstances("https://admin.services.crm6.dynamics.com", $creds)
        Retrieves a list of available instances from tenant associated with username "admin@superinstance.crm6.dynamics.com"
#>
function Get-AvailableCrmInstances($apiUrl, $credentials)
{
    try
    {
        $instances = Get-CrmInstances -ApiUrl $apiUrl -Credential $credentials -ErrorAction Stop
    }
    catch
    {
        if($_.Exception.Response.StatusCode -eq "NotFound")
        {
            Write-Host "Unable to find any instances associated with tenant." -ForegroundColor Yellow
        }
        else
        {
            throw $_;
        }
    }

    return $instances;
}

<#
	.SYNOPSIS
		Retrieves a list of available Dynamics 365 application templates in the Office 365 tenant.
	.DESCRIPTION
		Retrieves a list of application templates supported for provisioning a Dynamics 365 Customer Engagement (online) instance.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.6.0
	.LINK
		https://nullfactory.net
	.PARAMETER apiUrl
		The API service url for the tenant.
	.PARAMETER credentials
		The credentials used to access the API Service.
	.EXAMPLE
		$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
		$creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
		Get-AvailableCrmTemplates("https://admin.services.crm6.dynamics.com", $creds)
#>
function Get-AvailableCrmTemplates($apiUrl, $credentials)
{
    try
    {
        $templates = Get-CrmTemplates -ApiUrl $apiUrl -Credential $credentials
    }
    catch
    {
        if($_.Exception.Response.StatusCode -eq "NotFound")
        {
            Write-Host "Unable to find any application templates associated with tenant." -ForegroundColor Yellow
        }
        else
        {
            throw $_;
        }
    }
    return $templates
}


<#
	.SYNOPSIS
        Retrieves a list of available Dynamics 365 application templates in the Office 365 tenant.
	.DESCRIPTION
        Retrieves a list of application templates supported for provisioning a Dynamics 365 Customer Engagement (online) instance.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.6.0
	.LINK
		https://nullfactory.net
	.PARAMETER apiUrl
		The API service url for the tenant.
    .PARAMETER credentials
        The credentials used to access the API Service.
    .PARAMETER instanceId

    .PARAMETER backupLabel
        The name of the backup label
	.EXAMPLE
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $creds = New-Object System.Management.Automation.PSCredential ("admin@superinstance.crm6.dynamics.com", $securePassword)
        Get-CrmInstanceBackupByLabel("https://admin.services.crm6.dynamics.com", $creds, "eaf67f76-3633-416c-9814-5639bf1494e7", "Release1Backup")
        Retrieve backup name "Release1Backup" from tenant associated with user "admin@superinstance.crm6.dynamics.com"
#>
function Get-CrmInstanceBackupByLabel($apiUrl, $credentials, $instanceId, $backupLabel)
{
    if(-Not $backupLabel)
    {
        throw "Unable to resolve unique instance backup identifier.";
    }

    $backups = Get-CrmInstanceBackups -ApiUrl $apiUrl -Credential $credentials -InstanceId $instanceId
    $backup = $backups | Where-Object {$_.Label -eq $backupLabel } | Select-Object -First 1

    if(-Not $backup)
    {
        throw "Unable to find a backup with label $backupLabel";
    }

    return $backup.Id
}

<#
	.SYNOPSIS
        Retrieves the release for Dynamics 365 Customer Engagement (online) using the the service version name.
	.DESCRIPTION
        Retrieves the release for Dynamics 365 Customer Engagement (online) using the the service version name.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.6.0
	.LINK
		https://nullfactory.net
	.PARAMETER apiUrl
		The API service url for the tenant.
	.PARAMETER credentials
		The credentials used to access the API Service.
	.EXAMPLE
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
        Get-CrmServiceVersionByName("https://admin.services.crm6.dynamics.com", $creds, "")
#>
function Get-CrmServiceVersionByName($apiUrl, $credentials, $serviceVersionName)
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

    $serviceVersionId = $serviceVersion.Id
    $serviceVersionName = $serviceVersion.Name

    Write-Verbose "ServiceVersion Id: $serviceVersionId Name: $serviceVersionName"

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
    $sourceOperation)
{
    Write-Host "Waiting for operation completion..."
    $timeStamp = Get-Date -Format T

    # ensure that the intial status is not a failure
    # if the initial status is a failure then GetOperation functionality would not work
    if($sourceOperation)
    {
        $statusString = $sourceOperation.Status
        $operationId = $sourceOperation.OperationId

        Write-Host "OperationId: $operationId"
        Write-Host "[$timeStamp]: $statusString"

        $sourceOperation.Information | ForEach-Object { Write-Host $_.Subject - $_.Description }
        $sourceOperation.Errors | ForEach-Object { Write-Host $_.Subject - $_.Description }

        if($statusString -eq "Succeeded")
        {
            Write-Host "Operation completed successfully!" -ForegroundColor Green
            exit 0
        }
        elseif(@("FailedToCreate", "Failed", "Cancelling", "Cancelled", "Aborting", "Aborted", "Tombstone", "Deleting", "Deleted") -contains $statusString)
        {
            throw "Operation failed.";
        }
        # indeterminate statuses
        elseif(@("None", "NotStarted", "Ready", "Pending", "Running") -contains $statusString)
        {
            Write-Verbose "Indeterminate status."
        }
    }
    elseif($operationId -eq "00000000-0000-0000-0000-000000000000")
    {
        Write-Host "Invalid OperationId provided, exiting." -ForegroundColor Red
        exit 0
    }
    else
    {
        Write-Host "OperationId: $operationId"
    }

    $timeout = New-TimeSpan -Minutes 5
    $sw = [diagnostics.stopwatch]::StartNew()
    while ($sw.elapsed -lt $timeout)
    {
        $opStatus = Get-CrmOperationStatus -apiUrl $apiUrl -Credential $credentials -Id $operationId

        $timeStamp = Get-Date -Format T
        $statusString = $opStatus.Status;

        Write-Host "[$timeStamp]: $statusString"

        $opStatus.Information | ForEach-Object { Write-Host $_.Subject - $_.Description }
        $opStatus.Errors | ForEach-Object { Write-Host $_.Subject - $_.Description }

        # determinate statuses
        if($opStatus.Status -eq "Succeeded")
        {
            Write-Host "Operation completed successfully!" -ForegroundColor Green
            exit 0
        }
        elseif(@("FailedToCreate", "Failed", "Cancelling", "Cancelled", "Aborting", "Aborted", "Tombstone", "Deleting", "Deleted") -contains $statusString)
        {
            throw "Operation failed.";
        }
        # indeterminate statuses
        elseif(@("None", "NotStarted", "Ready", "Pending", "Running") -contains $statusString)
        {
            Write-Verbose "Indeterminate status."
        }

        # poll the service every 60 seconds
        start-sleep -Seconds 60
    }
}
