using System;
using Microsoft.Xrm.Sdk;

namespace <%= pluginProjectName %>
{
    public class SimplePlugin : IPlugin
    {
        public void Execute(IServiceProvider serviceProvider)
        {
            IPluginExecutionContext context =
                (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));
            IOrganizationServiceFactory serviceFactory =
                (IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory));
            IOrganizationService organizationService =
                (IOrganizationService)serviceProvider.GetService(typeof(IOrganizationService));

        }
    }
}
