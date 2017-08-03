using System.Activities;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Workflow;

namespace <%= workflowProjectName %>
{
    public class SimpleWorkflowActivity : CodeActivity
    {
        protected override void Execute(CodeActivityContext executionContext)
        {
            var workflowContext = context.GetExtension<IWorkflowContext>();
            var tracingService = context.GetExtension<ITracingService>();
            var serviceFactory = context.GetExtension<IOrganizationServiceFactory>();
            var organizationService = serviceFactory.CreateOrganizationService(workflowContext.UserId);

        }
    }
}
