wla-6502 -v -o %1.obj .\src\%1.asm
IF %errorlevel% GTR 0 GOTO :pause

wlalink -v -s linkfile %1.nes
IF %errorlevel% GTR 0 GOTO :pause

copy /b header.bin+%1.nes %1_ROM.nes

powershell.exe -ExecutionPolicy Bypass -file %CD%\NES_ram_to_mlb.ps1 %CD%\ %1
IF %errorlevel% GTR 0 GOTO :pause

powershell.exe -ExecutionPolicy Bypass -file %CD%\NES_sym_to_mlb.ps1 %CD%\ %1
IF %errorlevel% GTR 0 GOTO :pause

REM Put a Shortcut for Mesen in this folder named Mesen2.lnk
start "" Mesen2.lnk %CD%\%1_ROM.nes
REM %vbindiff% CM_Build_ROM.NES C:\Users\Bill\Downloads\Nes\dev\celesteHack\_103k\CMZnD_Practice_Rom_v1.03k.nes
GOTO end

:pause
PAUSE

:end