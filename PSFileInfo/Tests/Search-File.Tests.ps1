BeforeAll {
    function Search-File_Test {
        [CmdletBinding()]
        [OutputType([string])]
        param (
            [Parameter(Mandatory = $true,
                       ValueFromPipeline = $false)]
            [string[]] 
            $Path
        )
        process {
            $Result = 
            $Path.ForEach({
                try {
                    $MatchFile = Get-ChildItem $_ -Name -Force -ErrorAction Stop
                    if($MatchFile){
                        $MatchFile
                    }
                    else{
                        'No Match File'
                    }
                }
                catch [System.Management.Automation.ItemNotFoundException]{
                    'File Not Exist'
                }
            })
            $Result
        }
    }
}
Describe 'Search-File' {
    BeforeAll {
        New-Item 'TestDrive:\test1.txt'
        New-Item 'TestDrive:\test2.txt'
        New-Item 'TestDrive:\aaa.txt'
    }
    Context 'Search With Pattern' {
        It 'No Match' {
            Search-File_Test -Path 'TestDrive:\*.jpg' | Should -Be 'No Match File'
        }
        It 'One Match' {
            Search-File_Test -Path 'TestDrive:\a*.txt' | Should -Be 'aaa.txt'
        }
        It 'Two Match' {
            Search-File_Test -Path 'TestDrive:\test[12].txt' | Should -Be @('test1.txt','test2.txt')
        }
        It 'Two Search Pattern' {
            Search-File_Test -Path @('TestDrive:\test1.txt','TestDrive:\test2.txt') | Should -Be @('test1.txt','test2.txt')
        }
    }
    Context 'Search With Full File Name' {
        It 'File Not Exist' {
            Search-File_Test -Path 'TestDrive:\test3.txt' | Should -Be 'File Not Exist'
        }
    }
}