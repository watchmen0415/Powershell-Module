BeforeAll {
    function Search-Content_Test {
        [CmdletBinding()]
        [OutputType([string])]
        param (
            [Parameter(Mandatory = $true,
                       ValueFromPipeline = $false)]
            [ValidateNotNullOrEmpty()]
            [string]
            $Path,

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
                    $MatchResult | Select-Object -Property Pattern,Line
                }
                else {
                    'No Match'
                }
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                'File Not Exist'
            }
            $Result 
        }
    }
}
Describe 'Search-Content_Test' {
    BeforeAll {
        New-Item 'TestDrive:test.txt' -Value "Line1:aaa`nLine2:bbb"
    }
    Context 'File Exist' {
        It 'No Match' {
            Search-Content_Test -Path 'TestDrive:test.txt' -Text 'abc' | Should -Be 'No Match'
        }
        It 'One Match' {
            Search-Content_Test -Path 'TestDrive:test.txt' -Text "aaa" | Should -Be '@{Pattern=aaa; Line=Line1:aaa}' 
        }
        It 'Two Match' {
            Search-Content_Test -Path 'TestDrive:test.txt' -Text 'Line' | Should -Be @('@{Pattern=Line; Line=Line1:aaa}','@{Pattern=Line; Line=Line2:bbb}')
        }
    }
    Context 'File Not Exist' {
        It 'File Not Exist' {
            Search-Content_Test -Path 'TestDrive:test1.txt' -Text 'aaa' | Should -Be 'File Not Exist'
        }
    }
}