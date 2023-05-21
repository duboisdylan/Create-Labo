# On importe le module CreateLabo avec les fonctions qui vont bien.
Import-Module -Name "$(MyInvocation.MyCommand.Path)..\CreateLabo.psd1" -Force -Verbose
Write-Msg -OK -Message "Module MigrationFullWeb was imported" -Log