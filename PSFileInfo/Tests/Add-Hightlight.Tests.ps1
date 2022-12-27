BeforeAll {
    function Add-HightLight_Test {
        [CmdletBinding()]
        [OutputType([string])]
        param (
            [Parameter(Mandatory = $true,
                       ValueFromPipeline = $true)]
            [ValidateNotNullOrEmpty()]
            [string]
            $HtmlFragment,

            [Parameter(Mandatory = $true,
                       ValueFromPipeline = $false)]
            [ValidateNotNullOrEmpty()]
            [hashtable]
            $HightLight
        )
        process {
            foreach ($h in $HightLight.GetEnumerator()) {
                $HtmlFragment = $HtmlFragment.foreach({ $_ -replace $h.key,"<font style = background:$( $h.value )>$( $h.key )</font>" })
            }
            $HtmlFragment
        }
    }
}
Describe 'Add-HightLight' {
    Context 'Match words to hightlight' {
        BeforeAll {
            $HtmlFragment = "line1`rline2"
            $HightLight = @{'line1' = 'red';'line2' = 'green'}
        }
        It 'Value in Parameter' {
            Add-HightLight_Test -HtmlFragment $HtmlFragment -HightLight $HightLight | 
            Should -Be "<font style = background:red>line1</font>`r<font style = background:green>line2</font>"
        }
        It 'Value From Pipeline' {
            $HtmlFragment | Add-HightLight_Test -HightLight $HightLight |
            Should -Be "<font style = background:red>line1</font>`r<font style = background:green>line2</font>"
        }
    }
    Context 'No match word to hightlight' {
        BeforeAll {
            $HtmlFragment = "line1`rline2"
            $HightLight = @{'line3' = 'red';'line4' = 'green'}
        }
        It 'Value in Parameter' {
            Add-HightLight_Test -HtmlFragment $HtmlFragment -HightLight $HightLight | 
            Should -Be "line1`rline2"
        }
        It 'Value From Pipeline' {
            $HtmlFragment | Add-HightLight_Test -HightLight $HightLight |
            Should -Be "line1`rline2"
        }
    }
}