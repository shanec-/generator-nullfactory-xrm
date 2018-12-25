using System.Activities;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Workflow;

namespace <%= workflowProjectName %>
{
    public class SimpleWorkflowActivity : CodeActivity
    {
        protected override void Execute(CodeActivityContext executionContext)
        {
            var workflowContext = executionContext.GetExtension<IWorkflowContext>();
            var tracingService = executionContext.GetExtension<ITracingService>();
            var serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            var organizationService = serviceFactory.CreateOrganizationService(workflowContext.UserId);

        }
    }
}
