# Création d'un Switch Interne pour le NAT
New-VMSwitch -SwitchType Internal -SwitchName "CONTOSO"

# Trouver les informations sur l'interface pour la lier au Switch vNAT
Get-NetAdapter

# Configurer Adresse IP du Switch
New-NetIPAddress -IPAddress 10.0.0.254 -PrefixLength 24 -InterfaceAlias "vEthernet (CONTOSO)"

# Configurer le NAT
New-NetNat -Name "CONTOSO NAT" -InternalIPInterfaceAddressPrefix 10.0.0.0/24
