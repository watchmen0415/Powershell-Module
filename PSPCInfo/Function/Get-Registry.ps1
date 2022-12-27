Function Get-Registry {
    <#
    .SYNOPSIS
        Search registry keys value.

    .DESCRIPTION
        Search registry keys value then arrange result into table form.
        Output in html format.

    .EXAMPLE
        Get-Registry @{'TestRegistry:\TestLocation' = @('Subkey1','Subkey2')}.

    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # Hashtable with registry information.
        # Key equal to path,value equal to subkey name.
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $Path
    )
    process {
        $Result = 
        foreach ($p in $Path.GetEnumerator()) {
            foreach ($SubKey in $p.value) {
                try {
                    $KeyValue = (Get-ItemProperty -Path $p.key -Name $SubKey -ErrorAction Stop).($SubKey)
                    New-Object psobject -Property @{Path = $p.key;KeyName = $SubKey;KeyValue = $KeyValue}
                } 
                catch [System.Management.Automation.PSArgumentException] {
                    New-Object psobject -Property @{Path = $p.key;KeyName = 'PSArgumentException';KeyValue = 'NA'}
                    continue
                }
                catch [System.Management.Automation.ItemNotFoundException] {
                    New-Object psobject -Property @{Path = $p.key;KeyName = 'ItemNotFoundException';KeyValue = 'NA'}
                    continue
                }       
            }
        }
        $Result | ConvertTo-Html -Fragment
    }
}