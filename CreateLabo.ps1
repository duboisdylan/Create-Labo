# On importe le module CreateLabo avec les fonctions qui vont bien.
Import-Module -Name ".\CreateLabo.psd1" -Force 
Write-Msg -OK -Message "Module MigrationFullWeb was imported" -Log

# Call config.ps1
& "$PSScriptRoot\Configurations\Config.ps1"