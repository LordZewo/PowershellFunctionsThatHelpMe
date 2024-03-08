<#
.SYNOPSIS
    Tests connectivity to a list of computers on specified ports using Test-NetConnection and outputs the results as a table grouped by computer name.
.DESCRIPTION
    This function tests connectivity to a list of computers on specified ports using the Test-NetConnection cmdlet and outputs the results as a table grouped by computer name.
.PARAMETER ComputerNames
    An array of computer names to test connectivity to.
.PARAMETER PortNumbers
    An array of port numbers to test connectivity on. The default value is "3389","445","443","80","8080".
.PARAMETER CommonTCPPortsOnly
    Switch parameter to set a wider array of standard ports to test. If specified, the PortNumbers parameter will be ignored.
.EXAMPLE
    Start-PortPounder -ComputerNames "Computer1", "Computer2" -PortNumbers "3389", "443"
.EXAMPLE
    $computernames = ("Computer1","Computer2","Computer3")
    $computernames | Start-PortPounder
.EXAMPLE
    $computernames = ("Computer1","Computer2","Computer3")
    Start-PortPounder -ComputerNames $computernames
.AUTHOR
   https://github.com/LordZewo
    Date: [04.05.2023]
    Version: 0.2
#>

# Define the Start-PortPounder function
function Start-PortPounder {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "The computer names to test connectivity to.")]
        [ValidateNotNullOrEmpty()]
        [array]$ComputerNames,

        [Parameter(Mandatory = $false, HelpMessage = "The port numbers to test connectivity on.")]
        [ValidateRange(1, 65535)]
        [array]$PortNumbers = @(3389, 445, 443, 80, 8080),

        [Parameter(Mandatory = $false, HelpMessage = "Test most common TCP ports.")]
        [switch]$CommonTCPPortsOnly
    )

    # If CommonTCPPortsOnly switch is specified, limit the port numbers to common TCP ports
    if ($CommonTCPPortsOnly) {
        $PortNumbers = @(20, 21, 22, 23, 25, 53, 80, 110, 143, 443, 445, 465, 587, 993, 995, 1723, 3306, 3389, 5900, 8080)
    }

    $results = @()

    # Loop through each computer name and port number, and test the connection using Test-NetConnection
    foreach ($Computer in $ComputerNames) {
        $computerResult = @()

        foreach ($Port in $PortNumbers) {
            $Result = Test-NetConnection -ComputerName $Computer -Port $Port -WarningAction SilentlyContinue -ErrorAction SilentlyContinue |Select-Object *

            if ($Result.TcpTestSucceeded) {
                $connected = ("Port Accessable From " + $Result.SourceAddress.IPAddress)
            } else {
                $connected = ("Port Closed For " + $Result.SourceAddress.IPAddress)
            }

            $portResult = [pscustomobject]@{
                ComputerName = $Computer
                PingSucceeded = $Result.PingSucceeded
                Port = $Port
                Result = $connected
            }

            $computerResult += $portResult
        }

        $results += $computerResult
    }

    $results | Format-Table -AutoSize -GroupBy ComputerName

# Enables strict mode, which helps detect common coding errors
Set-StrictMode -Version Latest
# Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}

