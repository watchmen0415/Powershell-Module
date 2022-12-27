Function Search-Content {
    <#
    .SYNOPSIS
        Search specific word in a file.

    .DESCRIPTION
        Search specific word in a file.
        List the match lines and arrange them into table form.
        Output in html format.

    .EXAMPLE
        Search-Content -Path 'TestDrive:test.txt' -Text 'pass'

    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # File path
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        # Key word
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Text
    )
    process {
        $Result = 
        try {
            $MatchResult = Select-String -Path $Path -Pattern $Text -ErrorAction Stop
            if ($MatchResult) {
                $MatchResult | Select-Object -Property 'Pattern','Line' | ConvertTo-Html -Fragment
            }
            else {
                ConvertTo-Html -Fragment -PreContent $Path -PostContent "No Match Pattern `"$Text`""
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            ConvertTo-Html -Fragment -PreContent $Path -PostContent 'File Not Exist'
        }
        $Result 
    }
}