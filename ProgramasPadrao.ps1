# Verifica se o winget está disponível
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "`n❌ O winget não está instalado neste sistema. Encerrando o script."
    exit
}

Write-Host "`n🚀 Iniciando instalação dos programas..."

# Adobe Acrobat Reader
Write-Host "`n📥 Instalando Adobe Reader..."
winget install --id=Adobe.Acrobat.Reader.64-bit -e --accept-source-agreements --accept-package-agreements

# TeamViewer
Write-Host "`n📥 Instalando TeamViewer..."
winget install --id=TeamViewer.TeamViewer -e --accept-source-agreements --accept-package-agreements

# Oracle Java Runtime Environment
Write-Host "`n📥 Instalando Java Runtime Environment..."
winget install --id=Oracle.JavaRuntimeEnvironment -e --accept-source-agreements --accept-package-agreements

# Google Chrome
Write-Host "`n📥 Instalando Google Chrome..."
winget install --id=Google.Chrome -e --accept-source-agreements --accept-package-agreements

# Mozilla Firefox
Write-Host "`n📥 Instalando Mozilla Firefox..."
winget install --id=Mozilla.Firefox -e --accept-source-agreements --accept-package-agreements

# WinRAR
Write-Host "`n📥 Instalando WinRAR..."
winget install --id=RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements

# Microsoft Teams
Write-Host "`n📥 Instalando Microsoft Teams..."
winget install --id=Microsoft.Teams -e --accept-source-agreements --accept-package-agreements

# Microsoft Visual C++ 2015-2022 Redistributable (x64)
Write-Host "`n📥 Instalando Visual C++ 2015-2022 X64..."
winget install --id=Microsoft.VCRedist.2015+.x64 -e --accept-source-agreements --accept-package-agreements

# PDF Creator Free
Write-Host "`n📥 Instalando PDF Creator Free..."
winget install --id=Avanquestpdfforge.PDFCreator-Free -e --accept-source-agreements --accept-package-agreements

# AnyDesk
Write-Host "`n📥 Instalando AnyDesk..."
winget install --id=AnyDesk.AnyDesk -e --accept-source-agreements --accept-package-agreements

Write-Host "`n✅ Todos os programas foram instalados (ou já estavam presentes)."
