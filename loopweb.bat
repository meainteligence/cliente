@echo off
setlocal enabledelayedexpansion
title Loop 26 - Optimizer Pro
color 0A

net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo ========================================================
    echo   ERRO: EXECUTE COMO ADMINISTRADOR
    echo   loopweb.company
    echo ========================================================
    pause
    exit
)

:menu
cls
echo ========================================================
echo                LOOPWEB.COMPANY SERVICE
echo         Auditoria, Diagnostico e Manutencao
echo ========================================================
echo.
echo  [F] Desligar              [R] Reiniciar
echo  [S] Suspender             [X] Recuperacao Avancada
echo.
echo  [U] Atualizar Windows     [D] Atualizar Drivers
echo  [T] Temperatura           [H] Hardware Completo
echo  [I] Rede Avancada         [L] Limpeza Total
echo  [A] Saude do Sistema      [B] Benchmark Real
echo  [M] Deep Scan Malware     [P] Qualidade das Pecas
echo  [O] Processos e Portas    [G] Manual do Usuario
echo  [Q] Sair
echo.
echo ========================================================

choice /c FRSXUDTHILABMPOGQ /n /m "Escolha uma opcao: "

if errorlevel 17 exit
if errorlevel 16 goto manual_usuario
if errorlevel 15 goto processos_portas
if errorlevel 14 goto qualidade_pecas
if errorlevel 13 goto scan_malware
if errorlevel 12 goto benchmark
if errorlevel 11 goto saude_sistema
if errorlevel 10 goto limpar
if errorlevel 9 goto rede_avancada
if errorlevel 8 goto hardware_detalhado
if errorlevel 7 goto temperatura_cpu
if errorlevel 6 goto atualizar_drivers
if errorlevel 5 goto atualizar_pc
if errorlevel 4 goto recuperacao
if errorlevel 3 goto hiberne
if errorlevel 2 goto reboot
if errorlevel 1 goto poweroff
goto menu

:loading
set "msg=%~1"
set /a i=0
:loading_loop
set /a i+=1
set /a s=i %% 4
if !s!==0 set "dots="
if !s!==1 set "dots=."
if !s!==2 set "dots=.."
if !s!==3 set "dots=..."
<nul set /p ="!msg!!dots!     `r"
timeout /t 1 /nobreak >nul
if exist "%temp%\loop_done.flag" (
    del "%temp%\loop_done.flag" >nul 2>&1
    echo.
    exit /b
)
goto loading_loop

:atualizar_pc
cls
echo ========================================================
echo                 WINDOWS UPDATE
echo ========================================================
if exist "%temp%\loop_done.flag" del "%temp%\loop_done.flag" >nul 2>&1
start "" /b cmd /c powershell -command "$updateSession = New-Object -ComObject Microsoft.Update.Session; $updateSearcher = $updateSession.CreateUpdateSearcher(); $searchResult = $updateSearcher.Search('IsInstalled=0 and Type=''Software'''); if ($searchResult.Updates.Count -gt 0) { $downloader = $updateSession.CreateUpdateDownloader(); $downloader.Updates = $searchResult.Updates; $downloader.Download(); $installer = $updateSession.CreateUpdateInstaller(); $installer.Updates = $searchResult.Updates; $installer.Install(); Write-Host 'Atualizacao concluida.' -ForegroundColor Green } else { Write-Host 'Nenhuma atualizacao pendente.' -ForegroundColor Cyan }" && echo done>"%temp%\loop_done.flag"
call :loading "Atualizando sistema"
pause
goto menu

:atualizar_drivers
cls
echo ========================================================
echo               ATUALIZACAO DE DRIVERS
echo ========================================================
pnputil /scan-devices
pnputil /update-drivers *
pause
goto menu

:temperatura_cpu
cls
echo ========================================================
echo                   TEMPERATURA
echo ========================================================
powershell -command "$t = Get-WmiObject -Namespace root/wmi -Class MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue; if($t){ foreach($item in $t){ Write-Host 'Temperatura:' (($item.CurrentTemperature / 10) - 273.15) 'C' -ForegroundColor Yellow } } else { Write-Host 'Sensores indisponiveis.' -ForegroundColor Red }"
pause
goto menu

:hardware_detalhado
cls
echo ========================================================
echo                HARDWARE COMPLETO
echo ========================================================
echo.
echo [+] CPU
wmic cpu get name,numberofcores,maxclockspeed

echo.
echo [+] MEMORIA
powershell -command "Get-CimInstance Win32_PhysicalMemory | Select Manufacturer,PartNumber,@{N='GB';E={[math]::round($_.Capacity/1GB,0)}},Speed | ft"

echo.
echo [+] VIDEO
wmic path win32_VideoController get name,driverversion

echo.
echo [+] DISCO
wmic diskdrive get model,status,size

pause
goto menu

:rede_avancada
cls
echo ========================================================
echo                 REDE AVANCADA
echo ========================================================
echo.
echo [+] IPv4
ipconfig | findstr "IPv4"

echo.
echo [+] DNS
ipconfig /all | findstr "DNS"

echo.
echo [+] TESTE DE REDE
ping 8.8.8.8 -n 4

pause
goto menu

:limpar
cls
echo ========================================================
echo                 LIMPEZA TEMP
echo ========================================================
taskkill /f /im explorer.exe >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
mkdir "%temp%" >nul 2>&1
rd /s /q "C:\Windows\Temp" >nul 2>&1
mkdir "C:\Windows\Temp" >nul 2>&1
start explorer.exe
echo Limpeza concluida.
pause
goto menu

:saude_sistema
cls
echo ========================================================
echo               SAUDE DO SISTEMA
echo ========================================================
echo.
echo [1] SFC
echo [2] DISM
echo [3] SFC + DISM
choice /c 123 /n /m "Escolha: "

if errorlevel 3 goto saude_ambos
if errorlevel 2 goto saude_dism
if errorlevel 1 goto saude_sfc

:saude_sfc
sfc /scannow
pause
goto menu

:saude_dism
DISM /Online /Cleanup-Image /RestoreHealth
pause
goto menu

:saude_ambos
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
pause
goto menu

:benchmark
cls
echo ========================================================
echo                BENCHMARK REAL
echo ========================================================
echo.

if exist "%temp%\loop_done.flag" del "%temp%\loop_done.flag" >nul 2>&1

start "" /b cmd /c powershell -command ^
"$cpuStart=Get-Date; 1..4 | %% { Get-ChildItem $env:windir -Recurse -ErrorAction SilentlyContinue ^| Out-Null }; $cpu=((Get-Date)-$cpuStart).TotalSeconds; $diskStart=Get-Date; winsat disk -drive c >$null; $disk=((Get-Date)-$diskStart).TotalSeconds; $memStart=Get-Date; winsat mem >$null; $mem=((Get-Date)-$memStart).TotalSeconds; Write-Host ''; Write-Host '================ RESULTADO ================' -ForegroundColor Cyan; Write-Host ('CPU  : ' + [math]::Round($cpu,2) + ' s'); Write-Host ('DISK : ' + [math]::Round($disk,2) + ' s'); Write-Host ('MEM  : ' + [math]::Round($mem,2) + ' s'); if($cpu -lt 8 -and $disk -lt 12){Write-Host 'SCORE: ALTO' -ForegroundColor Green} elseif($cpu -lt 15){Write-Host 'SCORE: MEDIO' -ForegroundColor Yellow} else{Write-Host 'SCORE: BASICO' -ForegroundColor Red}" && echo done>"%temp%\loop_done.flag"

call :loading "Executando benchmark"

pause
goto menu

:scan_malware
cls
echo ========================================================
echo               MICROSOFT DEFENDER
echo ========================================================
echo.
echo [1] Rapido
echo [2] Completo
echo [3] Atualizar + Completo
choice /c 123 /n /m "Escolha: "

if errorlevel 3 goto scan_full_update
if errorlevel 2 goto scan_full
if errorlevel 1 goto scan_quick

:scan_quick
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
pause
goto menu

:scan_full
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
pause
goto menu

:scan_full_update
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
pause
goto menu

:qualidade_pecas
cls
echo ========================================================
echo              QUALIDADE DAS PECAS
echo ========================================================
echo.
echo [+] CPU
wmic cpu get name,maxclockspeed,numberofcores

echo.
echo [+] RAM
powershell -command "Get-CimInstance Win32_PhysicalMemory | Select Manufacturer,PartNumber,@{N='GB';E={[math]::round($_.Capacity/1GB,0)}},Speed | ft"

echo.
echo [+] DISCO SMART
wmic diskdrive get model,status,size

echo.
echo [+] BATERIA
powercfg /batteryreport /output "%temp%\battery-report.html" >nul 2>&1
if exist "%temp%\battery-report.html" (
    echo Relatorio salvo em:
    echo %temp%\battery-report.html
)

pause
goto menu

:processos_portas
cls
echo ========================================================
echo              PROCESSOS E PORTAS
echo ========================================================
echo.
echo [+] PORTAS
netstat -ano

echo.
echo [+] PROCESSOS
tasklist /v

pause
goto menu

:manual_usuario
cls
echo ========================================================
echo               LOOPWEB.COMPANY - MANUAL
echo ========================================================
echo.
echo F  - Desliga o computador em 30 segundos
echo R  - Reinicia imediatamente
echo S  - Coloca o sistema em suspensao
echo X  - Abre a recuperacao avancada do Windows
echo.
echo U  - Procura, baixa e instala atualizacoes
echo D  - Forca nova deteccao e atualizacao de drivers
echo.
echo T  - Mostra temperatura reportada pelos sensores
echo H  - Exibe detalhes completos de hardware
echo.
echo I  - Mostra IP, DNS e teste de conectividade
echo L  - Limpa arquivos temporarios do sistema
echo.
echo A  - Executa verificacao de integridade
echo      SFC, DISM ou ambos
echo.
echo B  - Executa benchmark real
echo      CPU, disco e memoria
echo.
echo M  - Executa verificacao de malware
echo      Rapida, completa ou completa com update
echo.
echo P  - Exibe qualidade das pecas
echo      CPU, RAM, SMART do disco e bateria
echo.
echo O  - Mostra portas abertas e processos ativos
echo.
echo G  - Exibe este manual
echo Q  - Sai do sistema
echo.
echo ========================================================
echo Este utilitario foi desenvolvido para auditoria,
echo diagnostico, manutencao e analise de desempenho.
echo ========================================================
pause
goto menu

:recuperacao
shutdown /r /o /f /t 0
goto menu

:poweroff
shutdown /s /t 30
goto menu

:reboot
shutdown /r /t 0
goto menu

:hiberne
rundll32.exe powrprof.dll,SetSuspendState 0,1,0
goto menu