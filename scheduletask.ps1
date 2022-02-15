
<#PSScriptInfo

.VERSION 0.0.1

.GUID 77d80190-5d5e-425f-9c01-2fa883f0d199

.AUTHOR Andre Silva - https://andreswebs.dev

.COMPANYNAME andre's web services

.COPYRIGHT The Unlicense

.TAGS automation configuration windows

.LICENSEURI https://unlicense.org/

.PROJECTURI https://github.com/andreswebs/ps-scheduletask

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

.PRIVATEDATA

#>

<#

.SYNOPSIS
Schedule a script as a task

.DESCRIPTION
Schedule a script as a task.
This creates a script and a scheduled task that will run that script on machine start.
It can be run once, or at every start.
The scheduled task generated script in turn runs an existing script in the file system.

.PARAMETER TaskName
Name of the scheduled task.

.PARAMETER TaskScriptPath
Path to an existing script that will be run by the task.

.PARAMETER TaskFilePath
Path where the generated script for the task will be created.

.PARAMETER TaskLogPath
Path to a file where the task will write error logs.

.PARAMETER SelfUnregister
If set, the task will run once and then unregister itself.

#>

[CmdletBinding()]
Param (

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $TaskName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TaskScriptPath,

    [ValidateNotNullOrEmpty()]
    [string] $TaskFilePath = "C:\$($TaskName).ps1",

    [ValidateNotNullOrEmpty()]
    [string] $TaskLogPath = "C:\$($TaskName).log",

    [switch] $SelfUnregister = $false

)

Write-Output @"
`$ErrorActionPreference = 'Stop'
try {
    powershell.exe $TaskScriptPath
} catch {
    Write-Output "[`$(Get-Date -Format 'yyyy-MM-dd HH:mm K')] $TaskName Task Error: `$_" | Out-File -Append -FilePath '$TaskLogPath'
    Exit 1
}
"@ | Out-File -FilePath $filePath

if ($SelfUnregister) {
    $unregisterCmd = "Unregister-ScheduledTask -TaskName $TaskName -Confirm:`$false"
    Write-Output "$unregisterCmd" | Out-File -Append -FilePath $TaskFilePath
}

schtasks /Create /TN "$TaskName" /SC onstart /TR "powershell.exe $TaskFilePath" /RU SYSTEM
