function Write-Msg {
    <#
    .SYNOPSIS
    This function is used to log an action or an information.
    
    .DESCRIPTION
    This function is used to log an action or an information.
    
    .LINK
    GitLab repository : https://gitlab.gcp.kiabi.pro/system-and-databases/windows/office-365/migration-magasins-fullweb
    #>
        [CmdletBinding(PositionalBinding)]
        param (
            [Parameter(
                Position = 1,
                ValueFromPipeline,
                Mandatory
            )]
            [Alias('Msg')]
            [PSObject[]]
            $Messages,
                 
            [String]
            $Suffix = "",
    
            [switch]
            $Info = $false,
    
            [switch]
            $OK = $false,
    
            [Alias('Warning')]
            [switch]
            $Warn = $false,
    
            [Alias('None')]
            [switch]
            $NoPrefix = $false,
    
            [Alias('Error')]
            [switch]
            $Err = $false,
    
            [switch]
            $Title = $false,
    
            [switch]
            $Log,
    
            [string]
            [ValidateScript({
                    Test-Path -Path $_ -IsValid -PathType Leaf
                })]
            $LogFile,
    
            [switch]
            $TS,
    
            [Alias('L')]
            [ValidateRange(0, 10)]
            [int]
            $Level = 0
        )
    
        Begin {
            If ($PSBoundParameters.ContainsKey('Info')) {
                $MsgType = "Info"
            }
            elseif ($PSBoundParameters.ContainsKey('Warn')) {
                $MsgType = "Warning"
            }
            elseif ($PSBoundParameters.ContainsKey('Err')) {
                $MsgType = "Error"
            }
            elseif ($PSBoundParameters.ContainsKey('Verbose')) {
                $MsgType = "Verbose"
            }
            elseif ($PSBoundParameters.ContainsKey('OK')) {
                $MsgType = "OK"
            }
            ElseIf ($PSBoundParameters.ContainsKey("Debug")) {
                $MsgType = "Debug"
            }
            ElseIf ($PSBoundParameters.ContainsKey("NoPrefix")) {
                $MsgType = "NoPrefix"
            }
            ElseIf ($PSBoundParameters.ContainsKey("Title")) {
                $MsgType = "Title"
            }
            $StandardColor = "Gray"
    
            switch ($MsgType) {
                'OK'        { $Prefix = "[+]  "     ; $Color = $StandardColor = "Green" }
                'Warning'   { $Prefix = "[!]  "     ; $Color = $StandardColor = "Yellow" }
                'Error'     { $Prefix = "[X]  "     ; $Color = $StandardColor = "Red" }
                'Debug'     { $Prefix = "[DBG]  "   ; $Color = "DarkGray" }
                'Verbose'   { $Prefix = "[VER]  "   ; $Color = "DarkGray" }
                'Info'      { $Prefix = "[I]  "     ; $Color = "White" }
                'NoPrefix'  { $Prefix = ""          ; $Color = "White" }
                'Title'     { $Prefix = "`r`n------[  " ; $Color = $StandardColor = "White" ; $Suffix = "  ]------------" }
                Default     { $Prefix = ""          ; $Color = "White" }
            }
    
            If ($null -eq $Script:bPSWriteColorModulePresent) {
                If (Get-Module -Name PSWriteColor -ErrorAction SilentlyContinue) {
                    $Script:bPSWriteColorModulePresent = $true
                }
                Else {
                    If(Get-InstalledModule -Name PSWriteColor -ErrorAction SilentlyContinue) {
                        Import-Module -Name PSWriteColor
                        $Script:bPSWriteColorModulePresent = $true
                    } Else {
                        $Script:bPSWriteColorModulePresent = $false
                    }
                }
            }
        }
    
        Process {
            ForEach ($Message in $Messages) {
                If ($Message.GetType().BaseType.Name -eq "DictionaryBase" -or $Message.GetType().Name -in @('Hashtable','PSCustomObject')) {
                    $bObject = $true
                }
                If ($MsgType -eq "Debug" -and $PSBoundParameters["Debug"] -eq $false) {
                    return
                }
                If ($MsgType -eq "Verbose" -and $PSBoundParameters["Verbose"] -eq $false) {
                    return
                }
                If ($Level -gt 0) {
                    $Prefix = (" " * 2 * $Level) + $Prefix
                }
                If ($bObject) {
                    Out-Host -InputObject $Message
                } 
                ElseIf ($Script:bPSWriteColorModulePresent) {
                    Write-Color -Text $Prefix, $Message, $Suffix -Color $Color, $StandardColor, $Color
                }
                Else {
                    Write-Host -Object $($Prefix, $Message, $Suffix) -ForegroundColor $Color
                }
                If ($Log -and $Script:MyInvocation.MyCommand.Path -and $Script:MyInvocation.MyCommand.Name) {
                    If ($MsgType -eq "Title")
                    {
                        $Prefix = $Prefix
                    }
                    Else {
                        $Prefix = $(Get-Date -Format 'yyyy/MM/dd HH:mm:ss') + " " + $Prefix
                    }
                    If ([string]::IsNullOrEmpty($LogFile)) {
                            $LogFolder = Join-Path -Path $( Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent ) -ChildPath "Logs"
                            $LogFile = Join-Path -Path $LogFolder -ChildPath ((Get-Date -Format "yyyyMMdd") + "_" + $Script:MyInvocation.MyCommand.Name.Replace('.ps1','').Replace('.psm1','') + ".log")
                        }
                    Else {
                        $LogFolder = Split-Path -Path $LogFile -Parent
                    }
                    If (-not(Test-Path $LogFolder -PathType Container)) {
                        New-Item -ItemType Directory -Path $LogFolder
                    }
                    If ($bObject) {
                        $Message | Out-File -FilePath $LogFile -NoClobber -Append
                    } Else {
                        [string]::Concat($Prefix, $Message, $Suffix) | Out-File -FilePath $LogFile -NoClobber -Append
                    }
                }
            }
        }
    }
    