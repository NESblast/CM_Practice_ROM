.MEMORYMAP 
SLOTSIZE   $2000
DEFAULTSLOT   0
SLOT 0      $8000       "$8000"
SLOT 1      $A000       "$A000"
SLOT 2      $C000       
SLOT 3      $E000
SLOT 4 		$0000		"RAM_NES"
SLOT 5 	    $6000		"RAM_CART"
.ENDME

.ROMBANKMAP
BANKSTOTAL   48
BANKSIZE   $2000
BANKS      48
.ENDRO

.BACKGROUND "CM_1_0_noheader.nes"

.INCLUDE "NES_labels.asm"
.INCLUDE "src\CM_Build_Constants.asm"
.INCLUDE "src\CM_Build_RAM.asm"
.INCLUDE "src\CM_Graphics.asm"


.BANK $0C SLOT "$A000"
.ORG $0000
.INCBIN "src\bank0C_mapdata.bin"

; Title Screen Version
.BANK $1D SLOT "$A000"
.ORG $020B
.db "PRACTICE ROM V1.03         "

.BANK 0 SLOT "$8000"
.ORG $1129

    JMP InputViewer

.ORG $11CA

    INX
    SBC #$64
    NOP
    NOP
    NOP
    NOP
PPUReturn:
    LDY #$20
    STY PpuAddr_2006
    LDA #$32
    STA PpuAddr_2006
    LDA $0E
    CMP #$0B


.ORG $1E82
CheckSelect:
    LDA #$20
    AND Input
    BNE +
    -
    JMP DrawHUDValues
    +
    LDA $07F8
    EOR #$08
    BEQ -
    JMP $1fff   ; Jump To SelectWarp

.ORG $1F20

InputViewer:
    LDA #$80
    STA PpuControl_2000
    LDX #$20
    LDY #$03
    LDA #Up_Dir
    JSR InputPPUWrite
    LDY #$04
    LDA #B_Button
    JSR InputPPUWrite
    LDY #$05
    LDA #A_Button
    JSR InputPPUWrite
    LDY #$22
    LDA #Left_Dir
    JSR InputPPUWrite
    LDY #$23
    LDA #Down_Dir
    JSR InputPPUWrite
    LDY #$24
    LDA #Right_Dir
    JSR InputPPUWrite
    JMP CheckSelect
InputPPUWrite:
    STX PpuAddr_2006
    STY PpuAddr_2006
    AND Input
    BEQ NoInput
    TYA
    ADC #$10
    TAY
NoInput:
    STY PpuData_2007
    RTS

.ORG $1F7B
DrawHUDValues:
    STX PpuAddr_2006
    LDY #$12
    STY PpuAddr_2006
    LDA #$9E
    STA PpuData_2007
    LDA XSpeed
    TAX
    AND #$80
    BEQ +
    LDA #$01
    SBC XSpeed
    TAX
    +
    STX PpuData_2007
    LDA #$9F
    STA PpuData_2007
    LDA YSpeed
    TAX
    AND #$80
    BEQ +
    LDA #$01
    SBC YSpeed
    TAX
    +
    STX PpuData_2007
    LDY #$24
    JMP PPUReturn

.BANK $1E SLOT "$8000"

; hijack and transfer the player to the menu routine
.ORG $0B3C
  BEQ BEQMapRoutine

.ORG $0B49
BEQMapRoutine:
  JMP MapRoutine

.ORG $0E90
  LDA $0590 ; scanline counter
  CMP #$03
  BEQ +

  ; waste cycles for raster
  PHP
  PLP
  NOP

  LDY #$30
  STY $5128
  INY
  STY $5129
  LDA #$D8
  STA $5203 ; scanline for next IRQ
  INC $0590
  RTS
+
  LDY #$00
  STY PPU_MASK
  RTS

.ORG $1120
MapRoutine:
  ; LDA #%00011000
  ; STA PPUMaskVar

  LDA IsInMap
  AND #%10000000
  BNE JumpBackFromMapRoutine

  JSR MapMenuToggle
  LDX IsOnMapMenu
  BEQ +

  JSR MenuRoutine
  JSR GoThroughSettings
  LDA #$00
+
  JMP UpdateXYMapTiles
  LDA #$00
JumpBackFromMapRoutine:
  JMP $8B4E

MapMenuToggle:
  LDA Input
  AND #Select_Button
  BEQ +
  AND DelayedInput
  BNE +
  LDA IsOnMapMenu
  EOR #%00000001
  STA IsOnMapMenu
  JSR MenuIsToggling
+
  RTS

MenuIsToggling:
  LDA #Sfx_EnemySmack
  STA Square1SoundQueue
  LDA IsOnMapMenu
  ;BEQ +
  JSR UpdateMenuTexts
;+
  ;JMP DrawAllMenuValues


GoThroughSettings:
  LDA MenuSelector
  ASL A ; times two
  TAY

  LDA MenuSettingsAddr,Y
  STA TempAddr
  INY
  LDA MenuSettingsAddr,Y
  STA TempAddr+1

  JMP (TempAddr)

MenuSettingsAddr:
	.word CheckToChangeMapWorld

CheckToChangeMapWorld:
  LDX TempWorldNumber
  LDA Input
  AND #Right_Dir
  BEQ +
  AND DelayedInput
  BNE +
  INX
  CPX #$04
  BNE ++
  LDX #$01
  JMP ++
+
  LDA Input
  AND #Left_Dir
  BEQ +++
  AND DelayedInput
  BNE +++
  DEX
  CPX #$00
  BNE ++
  LDX #$03
++
  STX TempWorldNumber
  CLC
  ;JSR DrawWorldValue
  LDA #$00
  ;INC DrawMapRowCounter
  STA PPU_MASK
  LDA #$30
  STA PpuAddr_2006
  LDA #$00
  STA PpuAddr_2006
  TXA
  ;JSR ChangeMapTiles
  LDA #$81
  STA IsInMap
  ;LDA #$0A
  ;STA DrawMapFlags
  ;JSR PlaySwooshSFX
+++
  RTS


UpdateXYMapTiles:
  LDA #$B0
  STA PpuControl_2000
  LDA #$20
  STA PpuAddr_2006
  LDA #$D7
  STA PpuAddr_2006
  LDA TempWorldNumber
  ADC #$01
  STA PpuData_2007
  LDA #$20
  STA PpuAddr_2006
  LDA #$DA
  STA PpuAddr_2006
  LDA MapCursorX
  STA PpuData_2007
  LDA #$20
  STA PpuAddr_2006
  LDA #$DD
  STA PpuAddr_2006
  LDA MapCursorY
  ADC #$02
  STA PpuData_2007
  JMP $8B51

.ORG $15C0
MenuRoutine:
  LDA Input
  AND #Up_Dir
  BEQ +++
  AND DelayedInput
  BNE +++

; play stomp SFX
  LDX #Sfx_StompSQ
  STX Square1SoundQueue

  DEC MenuSelector
  BPL ++
  LDA #$07
  STA MenuSelector
  JMP ++
+++:
  LDA Input
  AND #Down_Dir
  BEQ ++
  AND DelayedInput
  BNE ++

; play stomp SFX
  LDX #Sfx_StompSQ
  STX Square1SoundQueue

  LDX MenuSelector
  INX
  CPX #$08
  BNE +
  LDX #$00
  +
  STX MenuSelector
  ++
  LDA MenuSelector
  TAY
  ASL A
  ASL A
  ASL A
  ADC #$7B
  CPY #$07
  BNE +
  SBC #$38
  STA $0230
  LDA #$B0
  STA $0233
  RTS
  +
  STA $0230
  LDA #$58
  STA $0233
  RTS

UpdateMenuTexts:
  ;LDA IsOnMapMenu
  ;BNE +
  ;RTS

;+
  LDA #lobyte(MenuTexts)
  STA TempAddr
  LDA #hibyte(MenuTexts)
  STA TempAddr+1

  LDA #$22
  STA PpuAddr_2006
  LDA #$46
  STA PpuAddr_2006

  LDX #$05
-
  LDA (TempAddr),Y
  STA PpuData_2007
  INY
  DEX
  BNE -

  LDA #$22
  STA PpuAddr_2006
  LDA #$65
  STA PpuAddr_2006
  LDX #$06
-
  LDA (TempAddr),Y
  STA PpuData_2007
  INY
  DEX
  BNE -

  LDA #$22
  STA PpuAddr_2006
  LDA #$84
  STA PpuAddr_2006
  LDX #$07
-
  LDA (TempAddr),Y
  STA PpuData_2007
  INY
  DEX
  BNE -

  LDA #$22
  STA PpuAddr_2006
  LDA #$A4
  STA PpuAddr_2006
  LDX #$07
-
  LDA (TempAddr),Y
  STA PpuData_2007
  INY
  DEX
  BNE -

  LDA #$22
  STA PpuAddr_2006
  LDA #$C5
  STA PpuAddr_2006
  LDX #$06
-
  LDA (TempAddr),Y
  STA PpuData_2007
  INY
  DEX
  BNE -

  LDA #$22
  STA PpuAddr_2006
  LDA #$E1
  STA PpuAddr_2006
  LDX #$0A
-
  LDA (TempAddr),Y
  STA PpuData_2007
  INY
  DEX
  BNE -

  LDA #$23
  STA PpuAddr_2006
  LDA #$04
  STA PpuAddr_2006
  LDX #$07
-
  LDA (TempAddr),Y
  STA PpuData_2007
  INY
  DEX
  BNE -

  LDA #$22
  STA PpuAddr_2006
  LDA #$57
  STA PpuAddr_2006
  LDX #$08
-
  LDA (TempAddr),Y
  STA PpuData_2007
  INY
  DEX
  BNE -
  RTS

MenuTexts:
.db "World"
.db "Dashes"
.db "Collect"
.db "Display"
.db "Select"
.db "Death Warp"
.db "Respawn"
.db "Powerups"

.ORG $1760
CheckToChangeMaxDashes:
  LDX MaxDashesCount
  LDA Input
  AND #Right_Dir
  BEQ +
  AND DelayedInput
  BNE +
  INX
  CPX #$08
  BNE ++
  LDX #$01
  JMP ++
+ ; check if pressing left
  LDA Input
  AND #Left_Dir
  BEQ +++
  AND DelayedInput
  BNE +++
  DEX
  CPX #$00
  BNE ++
  LDX #$07
++: ; do stuff
  STX MaxDashesCount
  ; JSR DrawDashesValue
  JSR $9390
+++: ; end
  LDX #$00
  RTS

CheckToChangeCollect:
  LDA PracticeFlags
  TAY
  AND #%00000110
  LSR A
  TAX
  LDA Input
  AND #Right_Dir
  BEQ +
  AND DelayedInput
  BNE +
  INX
  CPX #$04
  BNE UpdateMenuCollect
  LDX #$00
  JMP UpdateMenuCollect
+
  LDA Input
  AND #Left_Dir
  BEQ SkipUpdateMenuCollect
  AND DelayedInput
  BNE SkipUpdateMenuCollect
  DEX
  BPL UpdateMenuCollect
  LDX #$03
UpdateMenuCollect:
  TXA
  ASL A
  STA PracticeFlags
  TYA
  AND #$F9
  ADC PracticeFlags
  STA PracticeFlags
  ; JSR DrawCollectValues
  ; JSR PlaySwooshSFX
SkipUpdateMenuCollect:
  LDX #$00
  RTS
	

