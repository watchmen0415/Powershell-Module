Function Get-FileContent {
    <#
    .SYNOPSIS
        Get text file content.

    .DESCRIPTION
        Get text file content then convert it to html format.

    .EXAMPLE
        Get-FileContent -Path 'TestDrive:\test.txt'
        
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # File path
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )
    process {
        $Result = 
        if (Test-Path($Path)) {
            Get-Content $Path | ConvertTo-Html -Fragment -Property @{label = $Path;expression = {$_}}
        }
        else {
            ConvertTo-Html -Fragment -PreContent $Path -PostContent 'File Not Exist'
        }
        $Result
    }
}