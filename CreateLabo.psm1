[CmdletBinding()]
Param()

$CreateLabo = @(Get-ChildItem -Path "$PSScriptRoot\Include\ActiveDirectory\*.ps1", "$PSScriptRoot\Include\Requirements\*.ps1" -Recurse -ErrorAction SilentlyContinue)

Foreach($import in $CreateLabo)
{
    Try {
        . $import.fullname
        Write-Verbose "CreateLabo Module: Imported $import.fullname"
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}
Export-ModuleMember -Function $CreateLabo.Basename