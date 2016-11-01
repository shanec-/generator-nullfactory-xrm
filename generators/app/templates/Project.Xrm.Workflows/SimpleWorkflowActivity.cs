using System.Activities;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Workflow;

namespace <%= workflowProjectName %>
{
    public class SimpleWorkflowActivity : CodeActivity
    {
        protected override void Execute(CodeActivityContext executionContext)
        {
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();
            IOrganizationServiceFactory serviceFactory =
                executionContext.GetExtension<IOrganizationServiceFactory>();
            IOrganizationService organizationService =
                serviceFactory.CreateOrganizationService(context.UserId);
            ITracingService tracingService =
                executionContext.GetExtension<ITracingService>();


        }
    }
}
