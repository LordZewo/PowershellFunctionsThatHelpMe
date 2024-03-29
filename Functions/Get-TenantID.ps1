#region Get-TenantID
function Get-TenantID {
 <#
    .SYNOPSIS
        Retrieves the Azure AD tenant ID for a given domain.
    .DESCRIPTION
        This function retrieves the Azure AD tenant ID associated with a specified domain by querying the Azure AD
        well-known OpenID configuration endpoint. It extracts the tenant ID from the issuer URL provided in the response.
        This function is useful for scenarios where you need to programmatically determine the tenant ID based on a domain.
    .NOTES
        This function requires internet connectivity to query the Azure AD OpenID configuration endpoint.
    .EXAMPLE
        Get-TenantID -Domain "contoso.com"
        Retrieves the Azure AD tenant ID for the domain "contoso.com".
    .AUTHOR
        https://github.com/LordZewo
        14.Feb.2024
    #>
        
# Enables tab-completion for parameter names
[CmdletBinding()]

        #define parameters
        Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Domain of Sender address")]
        [string] $Domain
        )
        $ErrorText1 = "        TenantID not found for domain $Domain. Please check the domain name and try again.
        Hint: copy / paste  senders domain name, check a domain registar or try the following powershell commands:
        resolve-dnsname -name $domain -type MX
        resolve-dnsname -name $domain -type NS" 
        #Region working variables
        $TenantID = ""
       #Endregion
        
        try {
            $issuer = invoke-restmethod -uri "https://login.microsoftonline.com/$Domain/.well-known/openid-configuration" -method get
            $TenantID =  $issuer.issuer.Split("/")[3]
        }
        catch {
            write-host $ErrorText1 -ForegroundColor Yellow
            return $null
        }

            $CustomObject = [PSCustomObject]@{
                Domain = $Domain
                TenantID = $TenantID
                }

        return $CustomObject

        

# Enables strict mode, which helps detect common coding errors
Set-StrictMode -Version Latest
# Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}
#EndRegion
