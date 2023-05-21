# Call config.ps1
& "$PSScriptRoot\..\Configurations\Config.ps1"

# Configuration de l'interface et de la route par defaut
# Get-NetAdapter -Name "Ethernet*" | New-NetIPAddress -IPAddress 10.0.0.102 -PrefixLength 24 -DefaultGateway 10.0.0.254

# Call config.ps1
& "$PSScriptRoot\..\Include\ActiveDirectory\Add-ComputerInDomain.ps1"