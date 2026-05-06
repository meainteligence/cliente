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

:voltar_menu
echo.
set /p "=Pressione ENTER para voltar ao menu..."
goto menu

:atualizar_pc
cls
echo ========================================================
echo                 ATUALIZAR WINDOWS
echo ========================================================
echo.
echo O sistema vai procurar, baixar e instalar
echo atualizacoes disponiveis.
echo.
set /p "conf=Pressione ENTER para continuar ou digite C para cancelar: "
if /i "%conf%"=="C" goto menu

cls
echo Procurando atualizacoes...
echo Aguarde.
echo.

powershell -NoProfile -Command ^
"$updateSession = New-Object -ComObject Microsoft.Update.Session; " ^
"$updateSearcher = $updateSession.CreateUpdateSearcher(); " ^
"$searchResult = $updateSearcher.Search('IsInstalled=0 and Type=''Software'''); " ^
"if ($searchResult.Updates.Count -gt 0) { " ^
"  Write-Host ('Encontradas ' + $searchResult.Updates.Count + ' atualizacoes.'); " ^
"  $downloader = $updateSession.CreateUpdateDownloader(); " ^
"  $downloader.Updates = $searchResult.Updates; " ^
"  $downloader.Download() | Out-Null; " ^
"  $installer = $updateSession.CreateUpdateInstaller(); " ^
"  $installer.Updates = $searchResult.Updates; " ^
"  $installer.Install() | Out-Null; " ^
"  Write-Host 'Instalacao concluida.' -ForegroundColor Green " ^
"} else { " ^
"  Write-Host 'Nenhuma atualizacao pendente.' -ForegroundColor Cyan " ^
"}"

call :voltar_menu

:atualizar_drivers
cls
echo ========================================================
echo               ATUALIZACAO DE DRIVERS
echo ========================================================
echo.
echo Este processo procura alteracoes de hardware
echo e reaplica drivers existentes no sistema.
echo.
echo [1] Reescanear hardware
echo [2] Reescanear e reiniciar dispositivos
echo.
choice /c 12C /n /m "Escolha uma opcao: "

if errorlevel 3 goto menu
if errorlevel 2 goto drivers_restart
if errorlevel 1 goto drivers_scan

:drivers_scan
cls
echo Procurando alteracoes de hardware...
pnputil /scan-devices
echo.
echo Processo concluido.
call :voltar_menu

:drivers_restart
cls
echo Procurando alteracoes de hardware...
pnputil /scan-devices
echo.
echo Reiniciando dispositivos...
powershell -command "Get-PnpDevice -PresentOnly | ForEach-Object { try { pnputil /restart-device ""$($_.InstanceId)"" >$null 2>&1 } catch {} }"
echo.
echo Processo concluido.
call :voltar_menu

:temperatura_cpu
cls
echo ========================================================
echo                   TEMPERATURA
echo ========================================================
powershell -command "$t = Get-WmiObject -Namespace root/wmi -Class MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue; if($t){ foreach($item in $t){ Write-Host 'Temperatura:' (($item.CurrentTemperature / 10) - 273.15) 'C' -ForegroundColor Yellow } } else { Write-Host 'Sensores indisponiveis.' -ForegroundColor Red }"
call :voltar_menu

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

call :voltar_menu

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

call :voltar_menu

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
call :voltar_menu

:saude_sistema
cls
echo ========================================================
echo               SAUDE DO SISTEMA
echo ========================================================
echo.
echo [1] Verificar arquivos do Windows
echo     Procura arquivos corrompidos e corrige.
echo.
echo [2] Reparar componentes internos
echo     Corrige arquivos internos do sistema.
echo.
echo [3] Verificacao completa
echo     Executa as duas verificacoes.
echo.
choice /c 123C /n /m "Escolha uma opcao: "

if errorlevel 4 goto menu
if errorlevel 3 goto saude_ambos
if errorlevel 2 goto saude_dism
if errorlevel 1 goto saude_sfc

:saude_sfc
cls
echo Verificando arquivos do Windows...
sfc /scannow
call :voltar_menu

:saude_dism
cls
echo Reparando componentes internos...
DISM /Online /Cleanup-Image /RestoreHealth
call :voltar_menu

:saude_ambos
cls
echo Executando verificacao completa...
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
call :voltar_menu

:benchmark
cls
echo ========================================================
echo                BENCHMARK REAL
echo ========================================================
echo.
echo Este teste mede processador, disco e memoria.
echo.
set /p "conf=Pressione ENTER para iniciar ou digite C para cancelar: "
if /i "%conf%"=="C" goto menu

cls
echo Executando benchmark...
echo Aguarde alguns instantes.
echo.

powershell -NoProfile -Command ^
"$cpuStart=Get-Date; " ^
"1..3 | ForEach-Object { Get-ChildItem $env:windir -Recurse -ErrorAction SilentlyContinue | Out-Null }; " ^
"$cpu=((Get-Date)-$cpuStart).TotalSeconds; " ^
"$diskStart=Get-Date; " ^
"winsat disk -drive c | Out-Null; " ^
"$disk=((Get-Date)-$diskStart).TotalSeconds; " ^
"$memStart=Get-Date; " ^
"winsat mem | Out-Null; " ^
"$mem=((Get-Date)-$memStart).TotalSeconds; " ^
"Write-Host ''; " ^
"Write-Host '================ RESULTADO ================' -ForegroundColor Cyan; " ^
"Write-Host ('CPU  : ' + [math]::Round($cpu,2) + ' s'); " ^
"Write-Host ('DISCO: ' + [math]::Round($disk,2) + ' s'); " ^
"Write-Host ('MEM  : ' + [math]::Round($mem,2) + ' s'); " ^
"if($cpu -lt 8 -and $disk -lt 12){Write-Host 'SCORE: ALTO' -ForegroundColor Green} " ^
"elseif($cpu -lt 15){Write-Host 'SCORE: MEDIO' -ForegroundColor Yellow} " ^
"else{Write-Host 'SCORE: BASICO' -ForegroundColor Red}"

call :voltar_menu

:scan_malware
cls
echo ========================================================
echo               MICROSOFT DEFENDER
echo ========================================================
echo.
echo [1] Verificacao rapida
echo [2] Verificacao completa
echo [3] Atualizar assinaturas e verificar
echo.
choice /c 123 /n /m "Escolha: "

if errorlevel 3 goto scan_full_update
if errorlevel 2 goto scan_full
if errorlevel 1 goto scan_quick

:scan_quick
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
call :voltar_menu

:scan_full
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
call :voltar_menu

:scan_full_update
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
call :voltar_menu

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
echo [+] DISCO
wmic diskdrive get model,status,size

echo.
echo [+] BATERIA
powershell -NoProfile -Command ^
"$b = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue; " ^
"if(!$b){ " ^
"  Write-Host 'Status da bateria: SEM CARGA' -ForegroundColor Red; " ^
"} else { " ^
"  $full = $b.FullChargeCapacity; " ^
"  $design = $b.DesignCapacity; " ^
"  if(!$full -or !$design -or $design -eq 0){ " ^
"    Write-Host 'Status da bateria: FUNCIONAMENTO LIMITADO' -ForegroundColor Yellow; " ^
"  } else { " ^
"    $saude = [math]::Round(($full / $design) * 100,0); " ^
"    Write-Host ('Saude estimada: ' + $saude + '%'); " ^
"    if($saude -ge 80){ " ^
"      Write-Host 'Status da bateria: OK' -ForegroundColor Green; " ^
"    } elseif($saude -ge 50){ " ^
"      Write-Host 'Status da bateria: FUNCIONAMENTO LIMITADO' -ForegroundColor Yellow; " ^
"    } else { " ^
"      Write-Host 'Status da bateria: RUIM' -ForegroundColor Red; " ^
"    } " ^
"  } " ^
"}"

echo.
powercfg /batteryreport /output "%temp%\battery-report.html" >nul 2>&1
if exist "%temp%\battery-report.html" (
    echo Relatorio detalhado salvo em:
    echo %temp%\battery-report.html
)

call :voltar_menu

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

call :voltar_menu

:manual_usuario
cls
echo ========================================================
echo               LOOPWEB.COMPANY - MANUAL
echo ========================================================
echo.
echo F  - Desliga o computador
echo R  - Reinicia o computador
echo S  - Suspende o sistema
echo X  - Recuperacao avancada
echo.
echo U  - Atualiza o Windows
echo D  - Atualiza drivers instalados
echo.
echo T  - Mostra temperatura
echo H  - Mostra hardware completo
echo.
echo I  - Mostra informacoes de rede
echo L  - Limpa arquivos temporarios
echo.
echo A  - Verifica a saude do sistema
echo B  - Mede desempenho real
echo M  - Faz verificacao de malware
echo P  - Mostra estado das pecas
echo O  - Lista portas e processos
echo.
echo G  - Abre este manual
echo Q  - Sai do sistema
echo.
call :voltar_menu

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