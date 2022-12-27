BeforeAll {
    function Get-Registry_Test {
        [CmdletBinding()]
        [OutputType([string])]
        param (
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [hashtable]
            $Path
        )
        process {
            $Result = 
            foreach ($p in $Path.GetEnumerator()) {
                foreach ($SubKey in $p.value) {
                    try {
                        (Get-ItemProperty -Path $p.key -Name $SubKey -ErrorAction Stop).($SubKey)
                    } 
                    catch [System.Management.Automation.PSArgumentException] {
                        'PSArgumentException'
                        continue
                    }
                    catch [System.Management.Automation.ItemNotFoundException] {
                        'ItemNotFoundException'
                        continue
                    }       
                }
            }
            $Result
            # #Use foreach method
            # $Path.GetEnumerator().foreach({
            #     $_.value.foreach({
            #         try {
            #             (Get-ItemProperty -Path $Path -Name $_ -ErrorAction Stop).($_)
            #         }
            #         catch [System.Management.Automation.PSArgumentException] {
            #             'PSArgumentException'
            #             continue
            #         }
            #         catch [System.Management.Automation.ItemNotFoundException] {
            #             'ItemNotFoundException'
            #             continue
            #         }
            #     })
            # })
        }
    }
}
Describe 'Get-Registry' {
    BeforeAll {
        New-Item -Path 'TestRegistry:\' -Name 'TestLocation'
        New-ItemProperty -Path 'TestRegistry:\TestLocation' -Name 'Subkey1' -Value '1'
        New-ItemProperty -Path 'TestRegistry:\TestLocation' -Name 'Subkey2' -Value '2'
    }
    Context 'Path Exist' {
        It 'Subkey Not Exist' {
            Get-Registry_Test @{'TestRegistry:\TestLocation' = @('Subkey1','Subkey3')} | Should -Be @('1','PSArgumentException')
        }
        It 'Subkey Exist' {
            Get-Registry_Test @{'TestRegistry:\TestLocation' = @('Subkey1','Subkey2')} | Should -Be @('1','2')
        }
    }
    Context 'Path Not Exist' {
        It 'Subkey Not Exist' {
            Get-Registry_Test @{'TestRegistry:\TestLocation1' = @('Subkey3')} | Should -Be 'ItemNotFoundException'
        }
    }
}