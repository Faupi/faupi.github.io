function Install-Winget {
    function Get-Winget-Status {
        (Get-AppxPackage | Where-Object Name -eq Microsoft.DesktopAppInstaller).Status
    }

    If ((Get-Winget-Status) -eq "Ok") {
        Write-Output "Winget already installed"
        Return
    }

    Start-Process ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1  # Winget in the MS store
    While ((Get-Winget-Status) -ne "Ok") {
        Start-Sleep 1
    }
    Write-Output "Winget installed OK"
}

function Install-Winget-Packages {
    winget install Microsoft.WindowsTerminal  # Available in Choco but it has permission issues
}

function Install-Choco-Packages {
    choco install -y git --params="'/GitAndUnixToolsOnPath /NoAutoCrlf'"
    
    choco install -y `
        1password vscodium imageglass oh-my-posh`
        firefox `
        msiafterburner equalizerapo `
        modernflyouts nilesoft-shell start10 `
        telegram steam discord spotify `
        sharex paint.net

    # choco install icue --version 4.33.138 -y
    # choco install cura-new --version 5.3.0 -y
    # choco install winbox --version 3.37 -y
    # choco install scrcpy --version 2.0 -y
}

# Prompt manual Winget install while Choco pulls packages
$WingetJob = Start-Job -ScriptBlock ${Function:Install-Winget}
$ChocoPkgsJob = Start-Job -ScriptBlock ${Function:Install-Choco-Packages}

# Start pulling Winget packages
Write-Output "=== WINGET ==="
$WingetJob | Wait-Job | Receive-Job
$WingetPkgsJob = Start-Job -ScriptBlock ${Function:Install-Winget-Packages}
$WingetPkgsJob | Wait-Job | Receive-Job

Write-Output "=== CHOCO ==="
$ChocoPkgsJob | Wait-Job | Receive-Job

Write-Output "Setting up oh-my-posh for current profile"
If (-Not(Test-Path -Path "$PROFILE" -PathType Leaf)) {
    Write-Output "Creating profile"
    New-Item -Path "$PROFILE" -ItemType File > $NULL
}
Set-Content -Path $PROFILE -Value "oh-my-posh init pwsh --config `"https://faupi.net/faupi.omp.json`" | Invoke-Expression"

Write-Output "All done!"
