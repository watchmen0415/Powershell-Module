BeforeAll {
    function Get-FileContent_Test {
        [CmdletBinding()]
        [OutputType([string])]
        param (
            [Parameter(Mandatory = $true,
                       ValueFromPipeline = $false)]
            [ValidateNotNullOrEmpty()]
            [string]
            $Path
        )
        process {
            $Result = 
            if( Test-Path($Path) ) {
                Get-Content $Path
            }
            else {
                'File Not Exist'
            }
            $Result
        }
    }
}
Describe 'Get-FileContent' {
    BeforeAll {
        New-Item 'TestDrive:\test.txt' -Value "line1`rline2"
        New-Item 'TestDrive:\test1.txt' -Value ''
    }
    Context 'File Exist' {
        It 'Content with two lines' {
            Get-FileContent_Test -Path 'TestDrive:\test.txt' | Should -Be @('line1', 'line2')
        }
        It 'No content' {
            Get-FileContent_Test -Path 'TestDrive:\test1.txt' | Should -Be $null
        }
    }
    Context 'File Not Exist' {
        It 'File Not Exist' {
            Get-FileContent_Test -Path 'TestDrive:\test2.txt' | Should -Be 'File Not Exist'
        }
    }
}