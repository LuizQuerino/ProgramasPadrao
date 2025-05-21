# Libera a política de execução para o usuário atual
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Verifica se o winget está disponível
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "`n❌ O winget não está instalado neste sistema. Tentando instalar o App Installer..."
    try {
        winget install --id=Microsoft.AppInstaller -e --accept-source-agreements --accept-package-agreements
        Write-Host "`n✅ App Installer instalado com sucesso. Reinicie o script."
    } catch {
        Write-Host "`n❌ Falha ao instalar o App Installer. Por favor, instale manualmente através da Microsoft Store: https://apps.microsoft.com/store/detail/app-installer/9NBLGGH4NNS1"
    }
    exit
}

# Define os programas disponíveis
$programas =@{
    1=@{ Nome ="Adobe Reader";              Id ="Adobe.Acrobat.Reader.64-bit" }
    2=@{ Nome ="TeamViewer";                Id ="TeamViewer.TeamViewer" }
    3=@{ Nome ="Java Runtime Environment";  Id ="Oracle.JavaRuntimeEnvironment" }
    4=@{ Nome ="Google Chrome";             Id ="Google.Chrome" }
    5=@{ Nome ="Mozilla Firefox";           Id ="Mozilla.Firefox" }
    6=@{ Nome ="WinRAR";                    Id ="RARLab.WinRAR" }
    7=@{ Nome ="Microsoft Teams";           Id ="Microsoft.Teams" }
    8=@{ Nome ="Visual C++ 2015-2022 X64";  Id ="Microsoft.VCRedist.2015+.x64" }
    9=@{ Nome ="PDF Creator Free";          Id ="Avanquestpdfforge.PDFCreator-Free" }
   10=@{ Nome ="AnyDesk";                   Id ="AnyDesk.AnyDesk" }
}

# Exibe o menu
Write-Host "`n=====INSTALADOR DE PROGRAMAS ====="
foreach ($key in $programas.Keys) {
    Write-Host "$key - $($programas[$key].Nome)"
}
Write-Host "99 - Instalar TODOS os programas"
Write-Host "0  - Sair"
Write-Host "==================================="

# Entrada do usuário
$selecionado=Read-Host "`nDigite o número do programa que deseja instalar"

# Verifica se o usuário quer sair
if ($selecionados -match '\b0\b') {
    Write-Host "`nSaindo..."
    exit
}

# Instala todos, se a opção 99 estiver presente
if ($selecionado -match '\b99\b') {
    Write-Host "`n📦 Instalando todos os programas..."
    foreach ($item in $programas.GetEnumerator()) {
        $nome=$item.Value.Nome
        $id=$item.Value.Id
        Write-Host "`n📥 Instalando $nome..."
        winget install --id=$id -e --accept-source-agreements --accept-package-agreements
    }
} else {
        try {
            $indice = [int]$selecionado
            if ($programas.ContainsKey($indice)) {
                $nome = $programas[$indice].Nome
                $id   = $programas[$indice].Id

                Write-Host "`n📥 Instalando $nome..."
                Write-Host "ID do pacote: $id"
                winget install --id=$id -e --accept-source-agreements --accept-package-agreements
    }
}
catch {
    Write-Host "`n❌ Entrada inválida. Digite um número válido."
    }
    
}

Write-Host "`n✅ Instalação finalizada."
#Get-Variable -Scope Local
pause