function Get-DriverInfo {
    <#
    .SYNOPSIS
        Get drivers information.

    .DESCRIPTION
        Get drivers information with several properties.
        Arrange the result into table form.
        Output in html format.

    .EXAMPLE
        $Property = @('DeviceName','Manufacturer','Signer','DriverVersion')
        $Driver = @('Intel(R) HD Graphics','Microsoft Camera Front')
        Get-DriverInfo -Drivers $Driver -Property $Property        
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # Array with drivers name
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Drivers,

        # Array with property name 
        # Property must have 'DeviceName' and at least one other property
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Property
    )
    begin { 
        $DriversAll = Get-WmiObject Win32_PnpSignedDriver | Select-Object -Property $Property
    }
    process {
        $Result = 
        foreach ($Driver in $Drivers) {
            $Match = $DriversAll | Where-Object {$_.DeviceName -eq $Driver}
            if ($Match) {
                $Match
            }
            else {
                $NoMatch = New-Object -TypeName psobject
                $Property.ForEach({ $NoMatch = $NoMatch | Add-Member -MemberType NoteProperty -Name $_ -Value 'NA' -PassThru })
                $NoMatch.DeviceName = $Driver
                $NoMatch
            }
        }
        $Result | ConvertTo-Html -Fragment
    }
}