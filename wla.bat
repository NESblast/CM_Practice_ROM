wla-6502 -v -o %1.obj %1.asm
IF %errorlevel% GTR 0 GOTO :pause

wlalink -v -s linkfile %1.nes
IF %errorlevel% GTR 0 GOTO :pause

copy /b header.bin+%1.nes %1_ROM.nes

REM NES_sym_to_mlb.ps1 %CD%\%1
powershell.exe -ExecutionPolicy Bypass -file %CD%\NES_sym_to_mlb.ps1 %CD%\%1
IF %errorlevel% GTR 0 GOTO :pause

REM Put a Shortcut for Mesen in this folder named Mesen2.lnk
start "" Mesen2.lnk %CD%\%1_ROM.nes
GOTO end

:pause
PAUSE

:end