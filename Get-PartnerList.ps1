#Region Get-PartnerList
function Get-PartnerList {

    <#
    .SYNOPSIS
        Retrieves a list of partners from a CSP tenant.

    .DESCRIPTION
        This function retrieves a list of partners from a CSP tenant.
        It can be used to get information about partners for further processing or analysis.
    .PARAMETER Permissions
        required permissions to list partners Directory.Read.All
    .EXAMPLE
        Get-PartnerList -Domain "contoso.com"
        Retrieves the information for the partner with the specified domain.
    .EXAMPLE
        Get-PartnerList -TenantID "12345678-1234-1234-1234-123456789012"
        Retrieves the information for the partner with the specified tenant ID.
    .NOTES
        Requires the Microsoft.Graph.Identity.DirectoryManagement module.
        Requires the Connect-MgGraph function.
        Requires the Directory.Read.All access.

    .AUTHOR
        Sigurður R. Magnússon
        15.Feb.2024
    #>

    # Enables tab-completion for parameter names
    [CmdletBinding()]

    #requires -Module Microsoft.Graph.Identity.DirectoryManagement
        
#define parameters
    Param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Search for Partner by TenantID")]
    [string] $TenantID,
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Search for Partner by Domain")]
    [string] $Domain
    )

    Connect-MgGraph -Scopes Directory.Read.All -NoWelcome
    $partnerlist = Get-MgContract -Property "defaultDomainName,customerId,DisplayName" -All

        if ($TenantID) {

        $partnerlist = Get-MgContract -Property "defaultDomainName,customerId,DisplayName" -All| Where-Object {$_.customerId -eq $TenantID}
        if (!$partnerlist) {
            Throw "No Partner found with TenantID: $TenantID"
        }
        else {
            $CustomObject = [PSCustomObject]@{
                DisplayName = $partnerlist.DisplayName
                DefaultDomainName = $partnerlist.defaultDomainName
                TenantID = $partnerlist.customerId
                }
            
        }

        }
            elseif ($Domain) {
                if ($Domain.Split(".")[-2] -eq "onmicrosoft") {
                    $partnerlist = ""
                    $partnerlist = Get-MgContract -Property "defaultDomainName,customerId,DisplayName" -All| Where-Object {$_.defaultDomainName -eq $Domain}
                    if (!$partnerlist) {
                        Throw "No Partner found with Domain: $domain"
                    }
                    else {
                        $CustomObject = [PSCustomObject]@{
                            DisplayName = $partnerlist.DisplayName
                            DefaultDomainName = $partnerlist.defaultDomainName
                            TenantID = $partnerlist.customerId
                            }
                        
                    }

                }
                else {
                    $partnerlist = ""
                    $partnerlist = Get-MgContract -Property "defaultDomainName,customerId,DisplayName" -All
                    try {
                        $issuer = invoke-restmethod -uri "https://login.microsoftonline.com/$Domain/.well-known/openid-configuration" -method get
                        $TenantID =  $issuer.issuer.Split("/")[3]
                    }
                    catch {
                        write-host "Domain not connected to M365" -ForegroundColor Yellow
                        return $null
                    }
            
                    $TenantID =  $issuer.issuer.Split("/")[3]
                    if ($partnerlist.CustomerId -notcontains $TenantID) {
                    Throw "No Partner found with TenantID: $TenantID"
                    }
                        elseif ($partnerlist.CustomerId -contains $TenantID){
                        $partner = $partnerlist | Where-Object customerId -eq $TenantID
                        $CustomObject = [PSCustomObject]@{
                            DisplayName = $partner.DisplayName
                            DefaultDomainName = $partner.defaultDomainName
                            TenantID = $partner.customerId
                            }
                        
                        }
                }
            
            
            }
                elseif (!$TenantID -and !$Domain) {
                    Return $partnerlist
                    Throw $null
                }
                    
                
        return $CustomObject 

   # Enables strict mode, which helps detect common coding errors
   Set-StrictMode -Version Latest
   # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
   Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}
#EndRegion
