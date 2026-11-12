$taskName = "FixMicVolume"
$installDir = "$env:APPDATA\SpeartonCS\FixMicVolume"
$processName = "FixMicVolume"

try {
    Write-Host "Starting uninstallation of $taskName..." -ForegroundColor Cyan

    # 1. Stop the application if it is currently running
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "Stopping active process ($processName)..."
        Stop-Process -Name $processName -Force -ErrorAction Stop
    }

    # 2. Delete the task from Task Scheduler
    $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    if ($task) {
        Write-Host "Removing Scheduled Task: $taskName..."
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
    } else {
        Write-Host "Scheduled Task not found. Skipping..." -ForegroundColor DarkGray
    }

    # 3. Delete the application files and folder
    if (Test-Path $installDir) {
        Write-Host "Deleting directory: $installDir..."
        Remove-Item -Path $installDir -Recurse -Force -ErrorAction Stop
    } else {
        Write-Host "Installation directory not found. Skipping..." -ForegroundColor DarkGray
    }

    Write-Host "Success! FixMicVolume has been completely removed." -ForegroundColor Green
    Start-Sleep -Seconds 3 # Closes automatically after 3 seconds on success
}
catch {
    Write-Host ""
    Write-Host "Uninstallation failed!" -ForegroundColor Red
    Write-Host "Error Details: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}