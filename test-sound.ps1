# Test all Windows system sounds
Write-Host "Testing Windows System Sounds..."
Write-Host ""

Write-Host "1. Playing Asterisk sound (Information)..."
[System.Media.SystemSounds]::Asterisk.Play()
Start-Sleep -Seconds 1

Write-Host "2. Playing Beep sound..."
[System.Media.SystemSounds]::Beep.Play()
Start-Sleep -Seconds 1

Write-Host "3. Playing Exclamation sound (Warning)..."
[System.Media.SystemSounds]::Exclamation.Play()
Start-Sleep -Seconds 1

Write-Host "4. Playing Hand sound (Error)..."
[System.Media.SystemSounds]::Hand.Play()
Start-Sleep -Seconds 1

Write-Host "5. Playing Question sound..."
[System.Media.SystemSounds]::Question.Play()
Start-Sleep -Seconds 1

Write-Host ""
Write-Host "Testing Windows default notification sound..."
$sound = New-Object System.Media.SoundPlayer
$sound.SoundLocation = "C:\Windows\Media\Windows Notify System Generic.wav"
if (Test-Path $sound.SoundLocation) {
    Write-Host "Playing: $($sound.SoundLocation)"
    $sound.Play()
} else {
    Write-Host "Default notification sound not found at expected location"
}

Write-Host ""
Write-Host "Sound test complete!"