Function RenameComputer
{
    param(
        $Name
    )

    $NameComputer = $env:COMPUTERNAME

    if ($Name -ne $NameComputer)
    {
        Rename-Computer -NewName $Name -Force -Restart
    }
}