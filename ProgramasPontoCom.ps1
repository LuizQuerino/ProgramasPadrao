# Define politica de execucao (para evitar erro de script bloqueado)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Verifica se o winget esta disponivel
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "`n❌ O winget nao esta instalado neste sistema. Encerrando o script."
    exit
}

# Define os programas disponiveis
$programas = @{
    1  = @{ Nome = "Adobe Reader";              Id = "Adobe.Acrobat.Reader.64-bit" }
    2  = @{ Nome = "TeamViewer";                Id = "TeamViewer.TeamViewer" }
    3  = @{ Nome = "Java Runtime Environment";  Id = "Oracle.JavaRuntimeEnvironment" }
    4  = @{ Nome = "Google Chrome";             Id = "Google.Chrome" }
    5  = @{ Nome = "Mozilla Firefox";           Id = "Mozilla.Firefox" }
    6  = @{ Nome = "WinRAR";                    Id = "RARLab.WinRAR" }
    7  = @{ Nome = "Microsoft Teams";           Id = "Microsoft.Teams" }
    8  = @{ Nome = "Visual C++ 2015-2022 X64";  Id = "Microsoft.VCRedist.2015+.x64" }
    9  = @{ Nome = "PDF Creator Free";          Id = "Avanquestpdfforge.PDFCreator-Free" }
    10 = @{ Nome = "AnyDesk";                   Id = "AnyDesk.AnyDesk" }
    11 = @{ Nome = "Ativacao do Windows";       Id = "ativacao" }
}

# Exibe o menu ordenado
Write-Host "`n===== INSTALADOR DE PROGRAMAS ====="
foreach ($key in ($programas.Keys | Sort-Object)) {
    Write-Host "$key - $($programas[$key].Nome)"
}
Write-Host "99 - Instalar TODOS os programas"
Write-Host "0  - Sair"
Write-Host "==================================="

# Entrada do usuario
$selecionados = Read-Host "`nDigite o(s) numero(s) do(s) programa(s) que deseja instalar (ex: 1 4 6 ou 99 para todos)"

# Sair
if ($selecionados -match '\b0\b') {
    Write-Host "`nSaindo..."
    exit
}

# Instalar todos
if ($selecionados -match '\b99\b') {
    Write-Host "`n📦 Instalando todos os programas..."
    foreach ($item in ($programas.GetEnumerator() | Sort-Object Key)) {
        $nome = $item.Value.Nome
        $id   = $item.Value.Id
        if ($id -eq "ativacao") {
            continue
        }
        Write-Host "`n📥 Instalando $nome..."
        winget install --id=$id -e --accept-source-agreements --accept-package-agreements
    }
} else {
    # Instalar selecionados
    $opcoes = $selecionados -split '\s+'
    foreach ($opcao in $opcoes) {
        if ([int]::TryParse($opcao, [ref]$null) -and $programas.ContainsKey([int]$opcao)) {
            $nome = $programas[[int]$opcao].Nome
            $id   = $programas[[int]$opcao].Id
            if ($id -eq "ativacao") {
                Write-Host "`n🔐 Iniciando ativacao do Windows..."
                Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command \"irm https://get.activated.win | iex"" -Verb RunAs
                continue
            }
            Write-Host "`n📥 Instalando $nome..."
            winget install --id=$id -e --accept-source-agreements --accept-package-agreements
        } else {
            Write-Host "`n⚠️ Opcao invalida: $opcao"
        }
    }
}

Write-Host "`n✅ Instalacao finalizada."
pause
exit
