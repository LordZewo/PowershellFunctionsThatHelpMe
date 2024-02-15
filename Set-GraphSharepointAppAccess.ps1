function Set-GraphSharepointAppAccess {

<#
.SYNOPSIS
    Sets access rights for an application, group, or user in a SharePoint site.
.DESCRIPTION
    The Set-GraphSharepointAppAccess function allows you to grant or update access rights for an application, group, or user in a SharePoint site using Microsoft Graph API.
.PARAMETER siteID
    The ID of the SharePoint site where the access rights should be configured.
.PARAMETER accessLevel
    Specifies the access level to be granted. Valid values are 'read', 'write', 'owner', and 'Remove'.
    - 'read': Provides the ability to read the metadata and contents of the site.
    - 'write': Provides the ability to read and modify the metadata and contents of the site.
    - 'owner': Represents the owner role for SharePoint and OneDrive for Business.
    - 'Remove': Removes the access rights for the specified app, group, or user.
.PARAMETER DelegateToID
    The ID of the application, group, or user to whom the access rights should be granted.
.NOTES
    This function requires the Microsoft.Graph.Sites module to be installed. You can install it by running 'Install-Module -Name Microsoft.Graph.Sites'.
.LINK
    More information about the Microsoft.Graph.Sites module: https://www.powershellgallery.com/packages/Microsoft.Graph.Sites
.EXAMPLE
    Set-GraphSharepointAppAccess -siteID "contoso.sharepoint.com,69d2cbc2-dd48-4df7-9090-1116242350d9,cde51e0b-cc35-4c03-942b-821b2fb8869c" -accessLevel "write" -DelegateToID "89ea5c94-7736-4e25-95ad-3fa95f62b66e"
    Grants 'write' access to the application with ID '89ea5c94-7736-4e25-95ad-3fa95f62b66e' in the specified SharePoint site.
.EXAMPLE
    Set-GraphSharepointAppAccess -siteID "contoso.sharepoint.com,69d2cbc2-dd48-4df7-9090-1116242350d9,cde51e0b-cc35-4c03-942b-821b2fb8869c" -accessLevel "Remove" -DelegateToID "89ea5c94-7736-4e25-95ad-3fa95f62b66e"
    Removes the access rights for the application with ID '89ea5c94-7736-4e25-95ad-3fa95f62b66e' from the specified SharePoint site.
.AUTHOR
   https://github.com/LordZewo
#>



#Requires -Modules "Microsoft.Graph.sites"
#Requires -Modules "Microsoft.Graph.users"
#Requires -Modules "Microsoft.Graph.groups"
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Site ID")]
        [string]$siteID,

        [Parameter(Mandatory = $true, HelpMessage = "Access level ('read', 'write', 'owner', 'Remove')")]
        [ValidateSet('read', 'write', 'owner', 'Remove')]
        [ArgumentCompleter({ 'read', 'write', 'owner', 'Remove' })]
        [string]$accessLevel,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "ID of App, Group, or User to grant access")]
        [string]$DelegateToID
    )

    # Connect to Microsoft Graph
    Connect-Graph -Scopes ("Sites.FullControl.All","User.ReadWrite.All","Group.ReadWrite.All")
    
    # Determine the roles based on the specified access level
    switch ($accessLevel) {
        'read' {
            $roles = @('read')
            break
        }
        'write' {
            $roles = @('write')
            break
        }
        'owner' {
            $roles = @('owner')
            break
        }
        'Remove' {
            Remove-MgSitePermission -SiteId $siteID -PermissionId $DelegateToID
            Write-Host "Access has been removed for $DelegateToID."
            return
        }
    }

    # Create the parameters for creating/updating the site permission
    $params = @{
        roles = $roles
        grantedToIdentities = @(
            @{
                application = @{
                    id = $DelegateToID
                    displayName = $DelegateToID
                }
            }
        )
    }

    # Determine if the site permission already exists
    $existingPermission = Get-MgSitePermission -SiteId $siteID -Filter "grantedToIdentities/any(ai: ai/application/id eq '$DelegateToID')"

    if ($existingPermission) {
        # Update the existing site permission
        Update-MgSitePermission -SiteId $siteID -PermissionId $existingPermission.id -BodyParameter $params
        Write-Host "Access has been updated for $DelegateToID."
    }
    else {
        # Create a new site permission
        New-MgSitePermission -SiteId $siteID -BodyParameter $params
        Write-Host "Access has been granted to $DelegateToID."
    }
# Enables strict mode, which helps detect common coding errors
Set-StrictMode -Version Latest
# Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}
