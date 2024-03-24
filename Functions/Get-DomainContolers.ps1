#Region Get-DomainControlers
function Get-DomainContolers {
        <#
        .SYNOPSIS
            Retrieves the domain controllers for a specified domain using DNS resolution.
        .DESCRIPTION
            The Get-DomainControllers function retrieves the domain controllers for a specified domain using DNS resolution. 
            It queries the DNS server for the SRV records associated with the domain controllers and returns the results.
        .PARAMETER domainName
            Specifies the name of the domain for which to retrieve the domain controllers.
        .NOTES
            This function requires the Resolve-DnsName cmdlet from the DNSClient module.
        .LINK
            https://learn.microsoft.com/en-us/powershell/module/dnsclient/resolve-dnsname?view=windowsserver2022-ps
        .EXAMPLE
            Get-DomainControllers -domainName "contoso.com"
            Retrieves the domain controllers for the "contoso.com" domain using DNS resolution.
        .AUTHOR
        https://github.com/LordZewo
        #>
           
   # Enables tab-completionfor parameter names and whatif
   [cmdletbinding(SupportsShouldProcess=$True)]
 
        #define parameter
        Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Domain")]
        [string] $domainName
        )

        
        $dnsResult = Resolve-DnsName -Name "_ldap._tcp.dc._msdcs.$domainName" -Type ALL
        return $dnsResult
   
   # Enables strict mode, which helps detect common coding errors
   Set-StrictMode -Version Latest
   # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
   Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}
   #EndRegion