<#
=============================================================================================
Author          = Mikail AYDIN
Creation Date   = 12.09.2023

============================================================================================
#>


Function DisplayMenu {
    param (
        [string]$Title = 'TLS Configuration Menu'
    )
    Clear-Host
    Write-Host "=============== $Title ==============="
    Write-Host '1: Enable TLS 1.2'
    Write-Host '2: Enable TLS 1.3' 
    Write-Host '3: Disable Other TLS Versions' 
    Write-Host '4: DotNetTLS' 
    Write-Host 'Rec: Recommended Configuration' 
    Write-Host '5: Exit' 
}

Function DotNetTLS {

    $NetPathArray = New-Object System.Collections.ArrayList
    $NetPathArray = [System.Collections.ArrayList]@(
        'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319'
        'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727'
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727'
    )

    $StrongCrypto = 'SchUseStrongCrypto'
    $DefaultTlsVersion = 'SystemDefaultTlsVersions'

    foreach ($NetPath in $NetPathArray) {
        Set-ItemProperty -Path $NetPath -Name $StrongCrypto -Value '1'
        Set-ItemProperty -Path $NetPath -Name $DefaultTlsVersion '1'
    }

}

Function Enable-TLS12 {

    $RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server'

    if (Test-Path -Path $RegPath) {        
        DotNetTLS
        
        # Enable TLS 1.2
        New-ItemProperty -Path $RegPath -Name 'Enabled' -Value '1' -PropertyType 'DWord' -Force
        New-ItemProperty -Path $RegPath -Name 'DisabledByDefault' -Value '0' -PropertyType 'DWord' -Force
        Write-Host "TLS 1.2 Enabled" -ForegroundColor Green
    }
    else {
        Write-Host("Path not found!")
        $choice = Read-Host  ("Create Path : (y)es or (n)o")
        switch ($choice) {
            'y' {
                New-Item -Path $RegPath -Force
                Enable-TLS12
            }
            'n' {
                Write-Host "Current process is cancelled." -ForegroundColor Red
                break;
            }
        }
    }
}

Function Enable-TLS13 {

    $RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Server'

    if (Test-Path -Path $RegPath) {
        DotNetTLS
        # Enable TLS 1.3
        New-ItemProperty -Path $RegPath -Name 'Enabled' -Value '1' -PropertyType 'DWord' -Force
        New-ItemProperty -Path $RegPath -Name 'DisabledByDefault' -Value '0' -PropertyType 'DWord' -Force
        Write-Host "TLS 1.3 Enabled" -ForegroundColor Green
    }

    else {
        Write-Host("Path not found!")
        $choice = Read-Host  ("Create Path : (y)es or (n)o")
        switch ($choice) {
            'y' {
                New-Item -Path $RegPath -Force
                Enable-TLS13
            }
            'n' {
                Write-Host "Current process is cancelled." -ForegroundColor Red
                break;
            }
        }
    }
}

Function Disable-OtherTLSVersions {
    $TLS10Server = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server'
    $TLS11Server = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server'

    # Disable TLS 1.0
    New-ItemProperty -Path $TLS10Server -Name 'Enabled' -Value '0' -PropertyType 'DWord' -Force
    New-ItemProperty -Path $TLS10Server -Name 'DisabledByDefault' -Value '1' -PropertyType 'DWord' -Force
    # Disable TLS 1.1
    New-ItemProperty -Path $TLS11Server -Name 'Enabled' -Value '0' -PropertyType 'DWord' -Force
    New-ItemProperty -Path $TLS11Server -Name 'DisabledByDefault' -Value '1' -PropertyType 'DWord' -Force
    
    Write-Host "Other TLS versions have been disabled" -ForegroundColor Yellow
}

$exitLoop = $false

while ($exitLoop -eq $false) {
    DisplayMenu
    $choice = Read-Host "Please make a selection"
    
    switch ($choice) {
        '1' {
            Enable-TLS12
            Start-Sleep -Seconds 3
        }
        '2' {
            Enable-TLS13
            Start-Sleep -Seconds 3
        }
        '3' {
            Disable-OtherTLSVersions
            Start-Sleep -Seconds 3
        }
        '4' {
            DotNetTLS
            Start-Sleep -Seconds 3
        }
        'Rec' {
            Enable-TLS12
            Enable-TLS13
            Disable-OtherTLSVersions
            Start-Sleep -Seconds 3
        }
        '5' {
            Write-Host "Exiting..." 
            $exitLoop = $true
            break
        }
    }
    
    if ($exitLoop -eq $false) {
        Write-Host 'Press any key to continue ...'
        $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}