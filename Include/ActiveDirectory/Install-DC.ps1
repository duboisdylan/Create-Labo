Function Install-DC {
    # Ajout de la fonctionnalité ADDS
    Add-WindowsFeature AD-Domain-Services

    # Ajout autorisation Ping
    Set-NetFirewallRule -DisplayName "Virtual Machine Monitoring (Echo Request - ICMPv4-In)" -Enabled True

    # Ajout des RSAT Tools
    Install-WindowsFeature -Name "RSAT-ADDS-Tools"

    # Chiffrement du mot de passe
    $SafeModeAdministratorPassword = ConvertTo-SecureString $PasswordAdminLocal -AsPlaintext -Force

    # Installation ADDS
    Import-Module ADDSDeployment
    Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName $DomainName `
    -DomainNetbiosName $NetBiosName `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true `
    -SafeModeAdministratorPassword $SafeModeAdministratorPassword

    # Creation of admin account
    New-ADUser -Name $SuperUser -AccountPassword $SafeModeAdministratorPassword -Passwordneverexpires $true -Enabled $true
    Add-ADGroupMember -Identity "Admins du domaine" -Members $SuperUser
}