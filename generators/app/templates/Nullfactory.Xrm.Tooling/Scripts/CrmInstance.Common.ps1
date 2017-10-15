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
        throw "Unable to resolve CRM instance Id."
    }

    return $instance.Id;
}