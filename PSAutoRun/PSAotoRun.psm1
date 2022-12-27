$FunctionPath = "$PSScriptRoot/Function"
Get-ChildItem  $FunctionPath | ForEach-Object {.$FunctionPath/$_}