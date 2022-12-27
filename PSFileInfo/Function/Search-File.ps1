Function Search-File {
    <#
    .SYNOPSIS
        Search files in the folder.

    .DESCRIPTION
        Search file name or filename extension in the folder.
        List the match files and arrange them into table form.
        Output in html format.

    .EXAMPLE
        Search-File -Path 'TestDrive:\test1.txt'.

    .EXAMPLE
        Search-File -Path 'TestDrive:\a*.txt'.

    .EXAMPLE
        Search-File -Path @('TestDrive:\test1.txt','TestDrive:\test2.txt')

    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # Folder path and the file search pattern
        # Can use array to search different files if needed
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path
    )
    process {
        $Result = 
        foreach ($p in $Path) {
            try {
                $MatchFile = Get-ChildItem $p -Name -Force -ErrorAction Stop
                if ($MatchFile) {
                    $MatchFile.foreach({ New-Object psObject -Property @{Path = $p;FileName = $_} })
                }
                else {
                    New-Object psobject -Property @{Path = $p;FileName = 'No Match File'}
                }
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                New-Object psobject -Property @{Path = $p;FileName = 'File Not Exist'}
            }
        }
        $Result | ConvertTo-Html -Fragment

        # Use Dictionary
        # $Result = @{}
        # foreach ($p in $Path) {
        #     try {
        #         $MatchFile = Get-ChildItem $p -Name -Force -ErrorAction Stop
        #         if ($MatchFile) {
        #             $MatchFile.foreach({ 
        #                 $Result.Add('Path',$p)
        #                 $Result.Add('FileName',$_)
        #             })
        #         }
        #         else {
        #             $Result.Add('Path',$p)
        #             $Result.Add('FileName','No Match File')
        #         }
        #     }
        #     catch [System.Management.Automation.ItemNotFoundException] {
        #         $Result.Add('Path',$p)
        #         $Result.Add('FileName','File Not Exist')
        #     }
        # }
        # New-Object psobject -Property $Result | ConvertTo-Html -Fragment
    }
}