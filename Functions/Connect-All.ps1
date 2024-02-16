
#Region Connect-All
function Connect-All {
    <#
.SYNOPSIS
   Connects to Microsoft Online Services, Azure Active Directory, Exchange Online, and IPPSSession.
   For the admin on the go.
.DESCRIPTION
   This function connects to various Microsoft services, 
   including Microsoft Online Services, Azure Active Directory,
   and Exchange Online. It sets up the necessary connections to work with these services.
.NOTES
   This function requires the Microsoft Azure PowerShell module, MSOnline module, and Exchange Online module.
   Make sure you have the appropriate permissions to connect to and access the specified services.
   Ensure that you have the required version of PowerShell installed.
.EXAMPLE
   Connect-All
.AUTHOR
   https://github.com/LordZewo
#>
       Connect-MsolService
       Connect-ExchangeOnline
       Connect-AzureAD
       Connect-IPPSSession
       

   # Enables strict mode, which helps detect common coding errors
   Set-StrictMode -Version Latest
   # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
   Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}
#EndRegion
