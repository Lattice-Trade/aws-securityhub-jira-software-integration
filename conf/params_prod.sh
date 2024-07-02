# Stack parameter
export ORG_ACCOUNT_ID='o-7vfdtdkqsc' # ID for Organization Management account 
export ORG_ROLE=OrganizationsReadOnlyAccess
export AWS_REGION=us-east-2
export EXTERNAL_ID='' #Optional 
export JIRA_DEFAULT_ASSIGNEE='emontes@membranelabs.com' #ID for default assignee for all Security Issues
export JIRA_INSTANCE="latticetrade.atlassian.net" #HTTPS address for JIRA server (exclude schema "https://")
export JIRA_PROJECT_KEY="SI" # JIRA Project Key
export ISSUE_TYPE="AWS Security Bug" #JIRA Issuetype name: Example, "Bug", "Security Issue
export REGIONS=("us-east-2") # List of regions deployed

PARAMETERS=(
  "OrganizationManagementAccountId=$ORG_ACCOUNT_ID"
  "JIRADefaultAssignee=$JIRA_DEFAULT_ASSIGNEE"
  "OrganizationAccessExternalId=$EXTERNAL_ID"
  "AutomatedChecks=$AUTOMATED_CHECKS"
  "JIRAInstance=$JIRA_INSTANCE"
  "JIRAIssueType"="$ISSUE_TYPE"
  "JIRAProjectKey"="$JIRA_PROJECT_KEY"
)