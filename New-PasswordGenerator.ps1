
function New-PasswordGenerator {
    <#
    .SYNOPSIS
        Generates a random password consisting of 12 characters from the English alphabet, numbers, and special characters.
    .DESCRIPTION
        The New-PasswordGenerator function generates a random password with a length of 12 characters. 
        The password includes letters from the English alphabet, numbers, and the following special characters: !"#$%&/()+-
    .NOTES
        This function does not require any parameters.
        The password is randomly generated each time the function is called.
    .EXAMPLE
        PS C:\> New-PasswordGenerator
        Generates a random password like "2V!7ca5H+X9L".
    .AUTHOR
       https://github.com/LordZewo
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Specify the length of the password")]
        [ValidateRange(1, 265)]
        [int] $PasswordLength = 12
    )

    $caractersUppercounter = 0
    $caractersLowercounter = 0
    $caractersNumbercounter = 0
    $charactersSpecialcounter = 0
    $passcounter = 0
    $pass = ""


    # Define the character sets for the password
    $alphabetLower = 'abcdefghijklmnopqrstuvwxyz'.ToCharArray()
    $alphabetUpper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.ToCharArray()
    $numbers = '0123456789'.ToCharArray()
    $specialChars = '!#$%&'.ToCharArray()

    # Combine all character sets into a single array
    do {
        $caractersUpper = $caractersUpper += (Get-Random -InputObject $alphabetUpper -Count 1)
    
        # Increment the counter
        $caractersUppercounter++
    } while ($caractersUppercounter -LT $PasswordLength)

    do {
        $caractersLower = $caractersLower += (Get-Random -InputObject $alphabetLower -Count 1)
    
        # Increment the counter
        $caractersLowercounter++
    } while ($caractersLowercounter -LT $PasswordLength)
    do {
        $caractersNumber = $caractersNumber += (Get-Random -InputObject $numbers -Count 1)
    
        # Increment the counter
        $caractersNumbercounter++
    } while ($caractersNumbercounter -LT $PasswordLength)
    do {
        $charactersSpecial = $charactersSpecial += (Get-Random -InputObject $specialChars -Count 1)
    
        # Increment the counter
        $charactersSpecialcounter++
    } while ($charactersSpecialcounter -LT $PasswordLength)
    # Generate the password by selecting 12 random characters
    $compile = -join ($caractersUpper + $caractersLower +$caractersNumber +$charactersSpecial)
    $password = $compile.replace(" ", "")
    $PArray =  $password.ToCharArray()

    do {
    $randomNumber = Get-Random -Maximum $PArray.lenght
        $pass = $pass += $PArray[$randomNumber] 
    
        $passcounter++
    } while ($passcounter -LT $PasswordLength)
    return $pass
}

