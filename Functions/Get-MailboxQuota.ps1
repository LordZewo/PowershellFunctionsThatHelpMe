#region Function: Get-MailboxQuota

function Get-MailboxQuota {
    <#
    .SYNOPSIS
        Checks mailbox quota and returns details for mailboxes exceeding a specified threshold.

    .DESCRIPTION
        This function checks the mailbox quota for Exchange Online mailboxes and returns details for mailboxes 
        exceeding a specified threshold. It retrieves details such as display name, total item size, and attachment
        total size for each mailbox.

    .PARAMETER Users
        An optional parameter that accepts an array of user email addresses. If provided, the function will only 
        process these mailboxes instead of retrieving all mailboxes.

    .NOTES
        This function requires the 'ExchangeOnlineManagement' module to be installed and the user running the 
        script to have appropriate permissions to connect to Exchange Online.

    .EXAMPLE
        Get-MailboxQuota -Users "user1@domain.com", "user2@domain.com"
        Checks the mailbox quota for the specified users.

    .EXAMPLE
        Get-MailboxQuota
        Checks the mailbox quota for all mailboxes in Exchange Online.

    .EXAMPLE
        Get-MailboxQuota -Users $users
        Checks the mailbox quota for mailboxes specified in the $users array.

    .LINK
        https://docs.microsoft.com/powershell/module/exchange/connect-exchangeonline

    .AUTHOR
    https://github.com/LordZewo
    18.Mars.2024
    #>

    # Enables tab-completion for parameter names
    [CmdletBinding()]

    # Define parameters
    Param (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Get Spesific Users")]
        [array] $Users
    )

    # Import the ExchangeOnlineManagement module
    Import-Module ExchangeOnlineManagement -ErrorAction Stop

    # Connect to Exchange Online
    Connect-ExchangeOnline -ErrorAction Stop

    # Retrieve mailboxes based on provided users or all mailboxes
    if ($Users) {
        $Mailboxes = Get-Mailbox -Identity $Users
    }
    else {
        $Mailboxes = Get-Mailbox -ResultSize Unlimited
    }

    # Array to store output
    $Output = @()

    # Iterate through each mailbox
    foreach ($Mailbox in $Mailboxes) {
        $MailboxStats = Get-MailboxStatistics -Identity $Mailbox.UserPrincipalName |Select-Object DisplayName,TotalItemSize,AttachmentTableTotalSize

        # Check if the mailbox size exceeds a threshold
        if ($MailboxStats.TotalItemSize.Value -like "*GB*") {
            $prohibitSendReceiveQuota = (($m.prohibitsendquota) -split " ")[0]
            $prohibitSendReceiveQuotaBytes = [long]($prohibitSendReceiveQuota -replace ',', '')
            $totalItemSizeGB = (($mbxStats.TotalItemSize.Value) -split " ")[0]
            $TotalItemSizeGBByte = [long]($totalItemSizeGB -replace ',', '') 

            if ($TotalItemSizeGBByte -gt ($prohibitSendReceiveQuotaBytes * 0.8)) {
                Write-Host "The mailbox $($Mailbox.UserPrincipalName) has a total item size $($MailboxStats.TotalItemSize.Value) "
                $Output += [PSCustomObject]@{
                    Identity = $Mailbox.UserPrincipalName
                    DisplayName = $MailboxStats.DisplayName
                    TotalItemSize = $MailboxStats.TotalItemSize.Value
                    AttachmentTotalSize = $MailboxStats.AttachmentTableTotalSize.Value
                }
            }
        }
    }

        # Output the result
        return $Output
    # Enables strict mode, which helps detect common coding errors
    Set-StrictMode -Version Latest
    # Sets the Tab key to the MenuComplete function, which provides tab-completion for parameter names
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}

#endregion
