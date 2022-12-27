Function Add-HightLight {
    <#
    .SYNOPSIS
        Hightlight specific words.

    .DESCRIPTION
        Add html background tag with color to specific words.

    .EXAMPLE
        Add-HightLight -HtmlFragment $HtmlFragment -HightLight @{'pass' = 'green';'fail' = 'red'}.

    #>    
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # Html format strings,can input from pipeline.
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $HtmlFragment,

        # Hashtable with hightlight information.
        # Key equal to word,value equal to color.
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