    # Configuration IP et ajout dans le domaine
    $IPConf = Get-NetIPConfiguration
    $domain = $Global:DomainName
    $UserAdmin = $Global:SuperUser
    $PasswordAdmin = $Global:PasswordAdminLocal | ConvertTo-SecureString -asPlainText -Force
    $Credential = New-object -TypeName System.Management.Automation.PSCredential -ArgumentList ($UserAdmin, $PasswordAdmin)

    Set-DnsClientServerAddress -InterfaceIndex $IpConf.InterfaceIndex -ServerAddresses 10.0.0.101
    Add-Computer -DomainName $domain -Credential $Credential -Restart -Force