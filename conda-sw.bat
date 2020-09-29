@echo off

REM Check if peco command exists

where peco.exe >nul 2>&1
if ErrorLevel 1 (
  echo ERROR: peco.exe is not found.>&2
  exit /B 1
)

REM Get the path of an activate.bat

where activate.bat >nul 2>&1
if ErrorLevel 1 (
  set ACTIVATE_BAT_PATH=C:\ProgramData\Anaconda3\condabin\activate.bat
  if not exist "%ACTIVATE_BAT_PATH%" (
    set ACTIVATE_BAT_PATH=C:\ProgramData\Anaconda2\condabin\activate.bat
    if not exist "%ACTIVATE_BAT_PATH%" (
      echo ERROR: activate.bat is not found.>&2
      exit /B 1
    )
  )
) else (
  for /F "delims=" %%a in ('where activate.bat') do set ACTIVATE_BAT_PATH=%%a
)

REM Activate base conda environment to use conda command

call "%ACTIVATE_BAT_PATH%" base

REM Get the list of conda environments

set ENVLIST=%TMP%\_%~n0_envlist.txt
type nul>"%ENVLIST%"
for /F %%a in ('conda info -e ^| findstr /C:"  "') do (
  echo %%a>>"%ENVLIST%"
)

REM Select a conda environment

for /F "delims=" %%a in ('peco "%ENVLIST%"') do set ENV=%%a

REM Activate the selected conda environment

call "%ACTIVATE_BAT_PATH%" "%ENV%"
