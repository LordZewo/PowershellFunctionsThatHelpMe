
function Get-GraphSharepointSiteIDAndAccess {
    <#
.SYNOPSIS
    Retrieves SharePoint site IDs and access information using Microsoft Graph API.
.DESCRIPTION
    The Get-GraphSharepointSiteIDAndAccess function allows you to retrieve SharePoint site IDs and access information using Microsoft Graph API.
.PARAMETER siteID
    Specifies the ID of the SharePoint site. If not provided, a list of all sites and their IDs will be returned.
.PARAMETER permissionID
    Specifies the ID of the site permission. If a site ID is provided and permissionID is not provided, the function will retrieve the site's permissions. If both site ID and permission ID are provided, detailed information about the specific site permission will be returned.
.NOTES
    Make sure you have the 'Microsoft.Graph.Sites' module installed. You can install it by running 'Install-Module -Name Microsoft.Graph.Sites' before using the function.
.LINK
    [URI to a help page]
.EXAMPLE
    # Example 1: Retrieve all SharePoint site IDs and names
    Get-GraphSharepointSiteIDAndAccess

    Description:
    This example retrieves a list of all SharePoint sites and their corresponding IDs.

.EXAMPLE
    # Example 2: Retrieve site permissions for a specific site
    Get-GraphSharepointSiteIDAndAccess -siteID "contoso.sharepoint.com,12345678-1234-1234-1234-1234567890ab"

    Description:
    This example retrieves the permissions for the SharePoint site with the specified site ID.

.EXAMPLE
    # Example 3: Retrieve detailed information about a specific site permission
    Get-GraphSharepointSiteIDAndAccess -siteID "contoso.sharepoint.com,12345678-1234-1234-1234-1234567890ab" -permissionID "98765432-4321-4321-4321-0987654321ba"

    Description:
    This example retrieves detailed information about the specific permission with the provided permission ID for the specified SharePoint site.
.AUTHOR
   https://github.com/LordZewo
#>

#Requires -Modules "Microsoft.Graph.sites"
#Requires -Modules "Microsoft.Graph.users"
#Requires -Modules "Microsoft.Graph.groups"

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Site ID")]
        [string] $siteID,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Permission ID")]
        [string] $permissionID
    )

    # Connect to Microsoft Graph
    Connect-Graph -Scopes ("Sites.FullControl.All","User.ReadWrite.All","Group.ReadWrite.All")


    if (-not $siteID) {
        # Get all sites and site IDs
        $sites = Get-MgSite -Property "siteCollection,webUrl" -Filter "siteCollection/root ne null"  | Select-Object -Property Name, Id
        $sites
    }
    else {
        if (-not $permissionID) {
            # Get site permissions
            $sitePermissions = Get-MgSitePermission -SiteId $siteID
            $sitePermissions
        }
        else {
            # Get detailed site permission
            $detailedPermission = Get-MgSitePermission -SiteId $siteID -PermissionId $permissionID
            $detailedPermission
        }
    }

# Enables strict mode, which helps detect common coding errors
Set-StrictMode -Version Latest
# Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}
