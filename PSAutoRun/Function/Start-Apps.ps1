function Start-Apps {
    <#
    .SYNOPSIS
        Open apps in manual mode or auto mode.

    .DESCRIPTION
        Open apps in manual mode or auto mode.
        Console will show the result if apps work properly.

    .EXAMPLE
        Start-Apps -AppList $MyApps -Manual

    .EXAMPLE
        Start-Apps -AppList $MyApps -Auto -Delay 10

    #>
    [CmdletBinding(DefaultParameterSetName = 'Manual')]
    param (
        # Hashtable with apps information.
        # Key equal to app name,value equal to app id.
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'Manual',
                   ValueFromPipeline = $true)]
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'Auto',
                   ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $AppList,

        # Manual mode.
        # Apps will not open until pressing a key.
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'Manual')]
        [switch]
        $Manual,

        # Auto mode.
        # Apps will automatically open in seconds.
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'Auto')]
        [switch]
        $Auto,

        # The time(second) until the next app automatically open.
        # Default value is 5 seconds.
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'Auto')]
        [int]
        $Delay = 5
    )
    process {
        if ($Manual) {
            $AppList.GetEnumerator().foreach({
                try {
                    Write-Host $_.key -NoNewline -ForegroundColor Green
                    pause
                    Start-Process "shell:appsfolder\$( $_.value )"
                }
                catch [System.InvalidOperationException] {
                    Write-Host 'App Not Found' -ForegroundColor 'Red'
                }
            })
        }
        if ($Auto) {
            foreach ($app in $AppList.GetEnumerator()) {
                try {
                    Start-Process "shell:appsfolder\$( $app.value )"
                    Write-Host $app.key -ForegroundColor 'Green'
                    Start-Sleep -Seconds $Delay
                }
                catch [System.InvalidOperationException] {
                    Write-Host $app.key -ForegroundColor 'Red'
                }
            }
        }
    }
}