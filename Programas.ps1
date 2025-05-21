# Verifica se o winget está disponível
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "`n❌ O winget não está instalado neste sistema. Encerrando o script."
    exit
}

# Define os programas disponíveis
$programas = @{
    1 = @{ Nome = "Adobe Reader";              Id = "Adobe.Acrobat.Reader.64-bit" }
    2 = @{ Nome = "TeamViewer";                Id = "TeamViewer.TeamViewer" }
    3 = @{ Nome = "Java Runtime Environment";  Id = "Oracle.JavaRuntimeEnvironment" }
    4 = @{ Nome = "Google Chrome";             Id = "Google.Chrome" }
    5 = @{ Nome = "Mozilla Firefox";           Id = "Mozilla.Firefox" }
    6 = @{ Nome = "WinRAR";                    Id = "RARLab.WinRAR" }
    7 = @{ Nome = "Microsoft Teams";           Id = "Microsoft.Teams" }
    8 = @{ Nome = "Visual C++ 2015-2022 X64";  Id = "Microsoft.VCRedist.2015+.x64" }
    9 = @{ Nome = "PDF Creator Free";          Id = "Avanquestpdfforge.PDFCreator-Free" }
   10 = @{ Nome = "AnyDesk";                   Id = "AnyDesk.AnyDesk" }
}

# Exibe o menu
Write-Host "`n===== INSTALADOR DE PROGRAMAS ====="
foreach ($key in $programas.Keys) {
    Write-Host "$key - $($programas[$key].Nome)"
}
Write-Host "99 - Instalar TODOS os programas"
Write-Host "0  - Sair"
Write-Host "==================================="

# Entrada do usuário
$selecionados = Read-Host "`nDigite o(s) número(s) do(s) programa(s) que deseja instalar (ex: 1 4 6 ou 99 para todos)"

# Verifica se o usuário quer sair
if ($selecionados -match '\b0\b') {
    Write-Host "`nSaindo..."
    exit
}

# Instala todos, se a opção 99 estiver presente
if ($selecionados -match '\b99\b') {
    Write-Host "`n📦 Instalando todos os programas..."
    foreach ($item in $programas.GetEnumerator()) {
        $nome = $item.Value.Nome
        $id = $item.Value.Id
        Write-Host "`n📥 Instalando $nome..."
        winget install --id=$id -e --accept-source-agreements --accept-package-agreements
    }
} else {
    # Divide os números digitados e instala apenas os selecionados
    $opcoes = $selecionados -split '\s+'
    foreach ($opcao in $opcoes) {
        if ($programas.ContainsKey([int]$opcao)) {
            $nome = $programas[$opcao].Nome
            $id   = $programas[$opcao].Id
            Write-Host "`n📥 Instalando $nome..."
            winget install --id=$id -e --accept-source-agreements --accept-package-agreements
        } else {
            Write-Host "`n⚠️ Opção inválida: $opcao"
        }
    }
}

Write-Host "`n✅ Instalação finalizada."
pause