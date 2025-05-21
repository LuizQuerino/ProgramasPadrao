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
   11 = @{ Nome = "Ativacao do Windows";       Id = "ativacao" }
}

# Exibe o menu
Write-Host "`n===== INSTALADOR DE PROGRAMAS ====="

foreach ($key in ($programas.Keys | Sort-Object)) {
    $nome = $programas[$key].Nome
    Write-Host "$key - $nome"
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
:Ativacao
# Codigo de ativacao do Windows
$troubleshoot = 'https://massgrave.dev/troubleshoot'
if ($ExecutionContext.SessionState.LanguageMode.value__ -ne 0) {
    $ExecutionContext.SessionState.LanguageMode
    Write-Host "Windows PowerShell is not running in Full Language Mode."
    Write-Host "Help - https://gravesoft.dev/fix_powershell" -ForegroundColor White -BackgroundColor Blue
    return
}

function Check3rdAV {
    $avList = Get-CimInstance -Namespace root\SecurityCenter2 -Class AntiVirusProduct | Where-Object { $_.displayName -notlike '*windows*' } | Select-Object -ExpandProperty displayName
    if ($avList) {
        Write-Host '3rd party Antivirus might be blocking the script - ' -ForegroundColor White -BackgroundColor Blue -NoNewline
        Write-Host " $($avList -join ', ')" -ForegroundColor DarkRed -BackgroundColor White
    }
}

function CheckFile { 
    param ([string]$FilePath) 
    if (-not (Test-Path $FilePath)) { 
        Check3rdAV
        Write-Host "Failed to create MAS file in temp folder, aborting!"
        Write-Host "Help - $troubleshoot" -ForegroundColor White -BackgroundColor Blue
        throw 
    } 
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$URLs = @(
    'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/a149fc5f2048b135c649a04da89e1b2f3178b449/MAS/All-In-One-Version-KL/MAS_AIO.cmd',
    'https://dev.azure.com/massgrave/Microsoft-Activation-Scripts/_apis/git/repositories/Microsoft-Activation-Scripts/items?path=/MAS/All-In-One-Version-KL/MAS_AIO.cmd&versionType=Commit&version=a149fc5f2048b135c649a04da89e1b2f3178b449',
    'https://git.activated.win/massgrave/Microsoft-Activation-Scripts/raw/commit/a149fc5f2048b135c649a04da89e1b2f3178b449/MAS/All-In-One-Version-KL/MAS_AIO.cmd'
)

foreach ($URL in $URLs | Sort-Object { Get-Random }) {
    try { $response = Invoke-WebRequest -Uri $URL -UseBasicParsing; break } catch {}
}

if (-not $response) {
    Check3rdAV
    Write-Host "Failed to retrieve MAS from any of the available repositories, aborting!"
    Write-Host "Help - $troubleshoot" -ForegroundColor White -BackgroundColor Blue
    return
}

$releaseHash = '99B9D8E20701DDCA02676146F7878ECC79BC403CB7B51FBB1B15B2D8D8BC64C4'
$stream = New-Object IO.MemoryStream
$writer = New-Object IO.StreamWriter $stream
$writer.Write($response)
$writer.Flush()
$stream.Position = 0
$hash = [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($stream)) -replace '-'
if ($hash -ne $releaseHash) {
    Write-Warning "Hash ($hash) mismatch, aborting!`nReport this issue at $troubleshoot"
    $response = $null
    return
}

$paths = "HKCU:\SOFTWARE\Microsoft\Command Processor", "HKLM:\SOFTWARE\Microsoft\Command Processor"
foreach ($path in $paths) { 
    if (Get-ItemProperty -Path $path -Name "Autorun" -ErrorAction SilentlyContinue) { 
        Write-Warning "Autorun registry found, CMD may crash! `nManually copy-paste the below command to fix...`nRemove-ItemProperty -Path '$path' -Name 'Autorun'"
    } 
}

$rand = [Guid]::NewGuid().Guid
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MAS_$rand.cmd" } else { "$env:USERPROFILE\AppData\Local\Temp\MAS_$rand.cmd" }
Set-Content -Path $FilePath -Value "@::: $rand `r`n$response"
CheckFile $FilePath

$env:ComSpec = "$env:SystemRoot\system32\cmd.exe"
$chkcmd = & $env:ComSpec /c "echo CMD is working"
if ($chkcmd -notcontains "CMD is working") {
    Write-Warning "cmd.exe is not working.`nReport this issue at $troubleshoot"
}
saps -FilePath $env:ComSpec -ArgumentList "/c \"\"\"$FilePath\" $args\"\"" -Wait
CheckFile $FilePath

$FilePaths = @("$env:SystemRoot\Temp\MAS*.cmd", "$env:USERPROFILE\AppData\Local\Temp\MAS*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }

#Get-Variable -Scope Local
pause
