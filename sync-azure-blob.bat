@echo off

SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

:start
rem ----- begin ----

call :Info "---    Azure Blob static web host must use standard v2 blob    ---"

call az version 1>nul 2>&1 
if %errorlevel% equ 0 (
	call :Debug "Azure client found"
	call :Debug "Use 'az login' to authorize if rclone fails to authorize."
) else (
	call :Error "Azure client not found." 
	echo "Download Azure client from https://docs.microsoft.com/zh-cn/cli/azure/install-azure-cli"
	exit /b 1
)

call r1clone version 1>nul 2>&1 
if %errorlevel% equ 0 (
	call :Debug "Rclone client found"
) else (
	call :Error "Rclone client not found." 
	echo "Download Rclone client from https://rclone.org/downloads/"
	exit /b 2
)


set RCLONE_CONF=%1
if "%RCLONE_CONF%" equ "" (
	call :Error "You must sepcify argument #1 for Rclone config name."
	call :Debug "Use 'rclone config' to config or list."
	exit /b 3
) else (
	call :Debug "RCLONE_CONF is %RCLONE_CONF%"
)

rem  azrue blob standard v2 default container for static web host 
set BLOB_CONTAINER=$web

pushd .

cd /d %~dp0
set BLOG_PATH=%cd%
echo "BLOG_PATH is %BLOG_PATH%"

call :Info "Generating and checking ..."
call hexo gen && call rclone check ./public %RCLONE_CONF%:%BLOB_CONTAINER%

call :Info "Press [y] then [ENTER] to start. [CTRL] + [C] to break."
set /p K= 1>nul 2>&1
if "%K%" equ "y" (
	rem pass
) else (
	if "%K%" equ "Y" (
		rem pass
	) else (
		exit /b 4
	)
)

call :Info "Synchronizing to %RCLONE_CONF% %BLOB_CONTAINER%."
rclone sync ./public %RCLONE_CONF%:%BLOB_CONTAINER%

popd

rem ----- end -----

goto :eof

rem ---------- functions ----------

:Debug
call :ColorText 08 "%~1"
echo.
goto :eof

:Info
call :ColorText 0b "%~1"
echo.
goto :eof

:Error
call :ColorText 0c "%~1"
echo.
goto :eof


:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof
