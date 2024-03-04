#Region function name and func
function Get-DNSSPF {
<#
.SYNOPSIS
    Retrieves the TXT value of a DNS record and searches for a specific string.
.DESCRIPTION
    The Get-DNSSPF function retrieves the TXT value of a DNS record for a given domain name and searches for a specific string.
    It uses the Resolve-DnsName cmdlet to perform the DNS query and returns the searched TXT value as a string.
    This function is useful for scenarios where you need to quickly check for include etc values in spf.
.NOTES
    This function requires the Resolve-DnsName cmdlet, which is available in Windows PowerShell 3.0 or later.
    It does not support Linux or other non-Windows operating systems.
.LINK
    https://example.com/help/Get-DNSSPF
.EXAMPLE
    Get-DNSSPF -DomainName "example.com" -SearchString "exclaimer"
    Retrieves the TXT value of the DNS record for the domain name "example.com" and searches for the string "exclaimer".
.AUTHOR
    https://github.com/LordZewo
#>

        
    # Enables tab-completion for parameter names
    [CmdletBinding()]

        #define parameter
        Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Domain of Sender address")]
        [string] $Domain,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="IP of Sending Server")]
        [string] $SearchString = "spf"
        )
        $result = ""

        if ($SearchString -like "*spf*") {
            $Result = Resolve-DnsName -Name $Domain -Type TXT |Select-Object -ExpandProperty strings |Select-String $SearchString |ForEach-Object { $_ -split " "}
         }
         else {
            $Result = Resolve-DnsName -Name $Domain -Type TXT |Select-Object -ExpandProperty strings |Select-String $SearchString |ForEach-Object { $_ -split " "} |Select-String $SearchString
         }
         
             return $Result

    # Enables strict mode, which helps detect common coding errors
    Set-StrictMode -Version Latest
    # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}
#EndRegion