# Enforce TLS 1.2 for GitHub API compatibility
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repo = "Spearton-CS/FixMicVolume"
$installDir = "$env:APPDATA\SpeartonCS\FixMicVolume"
$exePath = "$installDir\FixMicVolume.exe"
$taskName = "FixMicVolume"

try {
    Write-Host "Starting installation for $taskName..." -ForegroundColor Cyan

    # 1. Create the installation directory if it does not exist
    if (-not (Test-Path $installDir)) {
        Write-Host "Creating directory: $installDir"
        New-Item -Path $installDir -ItemType Directory -ErrorAction Stop | Out-Null
    }

    # 2. Fetch the latest release information from GitHub
    Write-Host "Fetching release information from GitHub..."
    $apiUrl = "https://api.github.com/repos/$repo/releases/latest"
    $release = Invoke-RestMethod -Uri $apiUrl -ErrorAction Stop

    # 3. Find the .exe asset in the release
    $exeAsset = $release.assets | Where-Object { $_.name -like "*.exe" } | Select-Object -First 1

    if (-not $exeAsset) {
        throw "Could not find an .exe file in the latest release on GitHub."
    }

    # 4. Download the executable
    Write-Host "Downloading $($exeAsset.name)..."
    Invoke-WebRequest -Uri $exeAsset.browser_download_url -OutFile $exePath -ErrorAction Stop

    # Unblock the downloaded file to prevent Windows SmartScreen execution issues
    Unblock-File -Path $exePath -ErrorAction SilentlyContinue

    # 5. Create and register the Task Scheduler job
    Write-Host "Configuring Task Scheduler to run on system logon..."
    $action = New-ScheduledTaskAction -Execute $exePath -Argument "noConsole" -WorkingDirectory $installDir
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

    $task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings
    Register-ScheduledTask -TaskName $taskName -InputObject $task -Force -ErrorAction Stop | Out-Null

    Write-Host "Success! FixMicVolume has been installed and scheduled." -ForegroundColor Green
    Start-Sleep -Seconds 3 # Closes automatically after 3 seconds on success
}
catch {
    Write-Host ""
    Write-Host "Installation failed!" -ForegroundColor Red
    Write-Host "Error Details: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}