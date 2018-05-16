# <%= visualStudioSolutionName %>.<%= crmSolutionName %>
> Welcome to the <%= visualStudioSolutionName %>.<%= crmSolutionName %> solution

CRM Server Url: [<%= crmServerUrl %>](<%= crmServerUrl %>) 

## Getting Started

Execute the `_RunFirst.ps1` powershell script located in the generated root folder. This script would restore and update the packages used by the `Nullfactory.Xrm.Tooling`

```
.\_RunFirst.ps1
```

### Pull the CRM Solution into the project structure

When the CRM solution needs to be pulled down into the project structure, execute the script located at `Nullfactory.Xrm.Tooling\Scripts\Pull-CrmSolution.Param.ps1`.

On the first attempt, the scripts would ask the user for the credentials to connect to the remote CRM server. The username and password used will be saved in the `nfac_<%= crmSolutionName %>_username` and `nfac_<%= crmSolutionName %>_password` user environmental variables respectively. 

### Resource Mapping

Edit the mapping file to map to the appropriate resource project. They are located in the `Nullfactory.Xrm.Tooling\Mapping` folder. 
More information on the structure of the mapping file can be found [here](https://msdn.microsoft.com/en-us/library/jj602987.aspx#use_command)

## Building the CRM Solution

The repackaging the solution is done as part of a post-build step of the solution project. Simply build it to output both a managed as well as unmanaged CRM solution package. 

### Builds 

More information on setting up continuous integration builds and automated releases:

- [Release Strategy for Dynamics CRM - Part 1 - Preparation](http://www.nullfactory.net/2016/10/release-strategy-for-dynamics-crm-prepping-part-1/)
- [Release Strategy for Dynamics CRM - Part 2 - Setting Up the Build](http://www.nullfactory.net/2016/11/release-strategy-for-dynamics-crm-setting-up-the-build-part-2/)
- [Release Strategy for Dynamics CRM - Part 3 - Setting Up the Release](http://www.nullfactory.net/2016/11/release-strategy-for-dynamics-crm-setting-up-the-release-part-3/)
- [Release Strategy for Dynamics CRM - Part 4 - Versioning](http://www.nullfactory.net/2017/02/release-strategy-for-dynamics-crm-versioning-part-4/)
- [Release Strategy for Dynamics CRM - Part 5 - Deploy Third-Party Solutions](http://www.nullfactory.net/2017/04/release-strategy-for-dynamics-crm-deploying-third-party-solutions-part-5/)

### Upgrading the PowerShell scripts

In order to upgrade the PowerShell scripts, execute the `tooling` sub-generator and follow the prompts:

```
yo nullfactory-xrm:tooling
```

