@echo off
title Preparar Sistema para Scripts PowerShell
color 0A

echo.
echo =============================================
echo Atualizando App Installer via Microsoft Store
echo =============================================
echo.

powershell -Command "Start-Process ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"

echo.
echo Aguarde a atualização do App Installer manualmente na loja...
pause

echo.
echo =============================================
echo Liberando politica de execucao do PowerShell
echo =============================================
echo.

powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

echo.
echo =============================================
echo PRONTO!
echo Agora voce pode executar scripts do PowerShell.
echo =============================================
echo.

pause
exit