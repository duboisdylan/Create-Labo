Function Install-BackInfo {
    Try{
        if (Test-Path -Path "HKLM:\SOFTWARE\BackInfo")
        {
            Write-Msg -OK -Messages "Folder already exist" 
        }
        
        Else 
        {
            Write-Msg -Warning -Messages "Folder Registry doesn't exist"
            New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\" -Name "BackInfo"
        }
        
        if (Get-ItemProperty -Path "HKLM:\SOFTWARE\BackInfo" -Name "Installed" -ErrorAction Ignore)
        {
            Write-Msg -OK -Messages "Registry already exist" 
        }
        else {
             #Mise en place du BackInfo
             New-Item "C:\backinfo" -ItemType "Directory"
             Invoke-RestMethod -Uri "http://files.dylan-dubois.fr/Formation/Supervision/20221216/Backinfo.zip" -OutFile "C:\backinfo\backinfo.zip"
             Expand-Archive "C:\backinfo\backinfo.zip" -DestinationPath "C:\"
             & "C:\backinfo\startup.cmd"
             & "C:\backinfo\BackInfo.exe"
         
             Write-Msg -Warning -Messages "Registry doesn't exist"
             New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\BackInfo" -Name Installed -Value 1 -PropertyType "DWORD"
             Write-Msg -Info -Messages "Registry created" -Log
        }
    }
    Catch {
        Write-Msg -Error -Messages "Une erreur est survenue !" -Log
        Write-Msg -Error -Messages "$($_.Exception.Message)" -Log
    }
   
}


