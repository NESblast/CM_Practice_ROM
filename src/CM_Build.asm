.MEMORYMAP 
SLOTSIZE   $2000
DEFAULTSLOT   0
SLOT 0      $8000       "$8000"
SLOT 1      $A000       "$A000"
SLOT 2      $C000       
SLOT 3      $E000
SLOT 4 		  $0000		"RAM_NES"
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

.ORG $0314
  JSR StartPressed

.ORG $03CF
SetCursorPosition:
  LDX MinimapOffset
  LDA #$01
  STA $059B
  TXA
  AND #$1F
  STA MapCursorX
  EOR MinimapOffset
  LSR A
  LSR A
  LSR A
  LSR A
  LSR A
  STA MapCursorY
  RTS

.ORG $04A6
MapWarper:
  JSR CheckIfCanMoveMapCursor
  LDY #$00
  LDA Input
  AND #$0C
  TAX
  BEQ ++
  AND DelayedInput
  BNE ++
  CPX #Up_Dir
  BNE +
  LDA MapCursorY
  BEQ +
  DEC MapCursorY
+
  CPX #Down_Dir
  BNE +
  LDA MapCursorY
  CMP #$07
  BEQ +
  INC MapCursorY
++
  LDA Input
  AND #$03
  TAX
  BEQ ++
  AND DelayedInput
  BNE ++
  CPX #$02
  BNE +
  LDA MapCursorX
  CMP #$03
  BCC +
  DEC MapCursorX
+
  CPX #$01
  BNE +++
  LDA MapCursorX
  CMP #$1D
  BCS +++
  INC MapCursorX
++
  LDA Input
  AND #$C0
  TAX
  BEQ MapWarperRTS
  AND DelayedInput
  BNE MapWarperRTS
  CPX #$40
  BNE +++
  LDA #$00
  STA $059B
  JMP SetCursorPosition
+++
  CPX #$80
  BNE MapWarperRTS
  LDA MapCursorY
  ASL A
  ASL A
  ASL A
  ASL A
  ASL A
  ORA MapCursorX
  STA TempRoomID
  TAX
  LDA $7B00,X
  CMP #$00
  BEQ MapWarperRTS
  STX WarpIDLast
MapWarp:
  LDA #$8C                 ;bankswitch (18000)
  STA PRGPort1
  LDA TempWorldNumber
  STA WarpWorldLast
  ASL A
  ASL A
  ASL A
  CLC
  ADC #$9B
  STA $03
  JSR MapGetData
  STA RoomID
  JSR MapGetData
  STA SpawnXHigh
  JSR MapGetData
  STA SpawnX
  JSR MapGetData
  STA SpawnYHigh
  JSR MapGetData
  STA SpawnY
  JSR MapGetData
  STA SpawnType
  STA SpawnTypeUsed
  JSR MapGetData
  STA RoomOffset
  JSR MapGetData
  STA SpawnSwitchStatus
  LDA #$0E
  STA PlayerState
  STY $0765
  JMP MapWarpRest
MapWarperRTS:
  RTS

.ORG $1FE0
MapGetData:
  LDA (TempRoomID),Y
  INC $03
  RTS

; remove check for save point when map warping
; .ORG $0516
;   NOP
;   NOP
;   NOP
;   NOP
;   NOP
;   NOP
;   NOP

.ORG $1129
  JMP InputViewer

; don't draw mario text (bottom left)
.ORG $1175
  RTS

CheckIfCanMoveMapCursor:
  LDA IsOnMapMenu
  BNE +
  RTS
+
  JMP MapWarperRTS

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

.ORG $17BF
  TAX
  AND #$0F
  STA $07FE
  TXA
  AND #$F0
  BEQ Here ; weird branch, might not be necessary
  ASL A
  ORA $07FE
  STA MinimapTiles,Y
  RTS

; .ORG $17D0
StartPressed:
  LDA WorldNumber
Here:
  STA TempWorldNumber
  LDA IsInMap
  AND #%00000001
  BEQ +
  LDA WorldNumber
  ; JSR UpdateMapTiles
  LDA IsInMap
+
  RTS

; removing some of the text will give us more space
.ORG $1D9D
ItemGetTextPointers:
	.DW SaveGame_Intro ;1
	.DW CannotSave_Intro ;2
	.DW GiantMoon_Intro ;3, currently vacant	
	.DW VITUpgrade_Intro	;4
	.DW MAGUpgrade_Intro	;5
	.DW PowerMoon_Intro ;6
	.DW Shapeshift_Intro
	.DW TheWorld_Intro
	.DW XRay_Intro
	.DW Starman_Intro
	.DW Feather_Intro
	.DW DoubleJump_Intro
	.DW SpeedBooster_Intro
	.DW ScrewAttack_Intro
	.DW FireSuit_Intro
	.DW ChargeShot_Intro
	.DW SuperFire_Intro
	.DW UltraFire_Intro
	.DW SpringBoots_Intro
	.DW Morphball_Intro
	.DW WallGrip_Intro
	.DW FastTravel_Intro
	
.ORG $1DCA
SaveGame_Intro:
	.db $0A
	.db "GAME SAVED.", $00
CannotSave_Intro:
	.db $0A
	.db "CANNOT SAVE!", $00
MAGShroom_Intro:
; 	.db $14
; 	.db 'Next MAG upgrade: ', 0
VITUpgrade_Intro:
; 	.db $0C
; 	.db 'VIT LEVEL UP!', 0
MAGUpgrade_Intro:
	.db $06
	.db "MAX DASHES INCREASED!", $00
PowerMoon_Intro:
	.db $09
	.db "YOU GOT A MOON!", $00
GiantMoon_Intro:
	.db $06
	.db "YOU GOT A SUPER MOON!", $00
Feather_Intro:
; 	.db $0A
; 	.db 'WING BOOTS', 0
DoubleJump_Intro:
; 	.db $0A
; 	.db 'SPACE JUMP', 0
Shapeshift_Intro:
; 	.db $0A
; 	.db 'SHAPESHIFT', 0
TheWorld_Intro:
; 	.db $09
; 	.db 'THE WORLD', 0
XRay_Intro:
	.db $0A
	.db "X-RAY SCOPE", $00
Starman_Intro:
; 	.db $0E
; 	.db 'STELLA',$27,'S MAGIC', 0
SpeedBooster_Intro:
; 	.db $0D
; 	.db 'SPEED BOOSTER', 0
ScrewAttack_Intro:
; 	.db $0C
; 	.db 'SCREW ATTACK', 0
FireSuit_Intro:
; 	.db $09
; 	.db 'FIRE SUIT', 0
ChargeShot_Intro:
	.db $0C
	.db "AIR DASH", $00
SuperFire_Intro:
; 	.db $0A
; 	.db 'SUPER FIRE', 0
UltraFire_Intro:
; 	.db $0A
; 	.db 'ULTRA FIRE', 0
SpringBoots_Intro:
; 	.db $0C
; 	.db 'SPRING BOOTS', 0
Morphball_Intro:
; 	.db $09
; 	.db 'MORPHBALL', 0
WallGrip_Intro:
	.db $0B
	.db "WALL GRIP", $00
FastTravel_Intro:
; 	.db $08
; 	.db 'FAST WARP', 0
IceFlower_Intro:
; 	.db $0A
; 	.db 'ICE FLOWER', 0


; .ORG $1E82
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

; .ORG $1F20

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
    BEQ +
    TYA
    ADC #$10
    TAY
+
    STY PpuData_2007
    RTS

; .ORG $1F7B
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

; .ORG $1FBB
MapWarpRest:
  LDA TempWorldNumber
  STA WorldNumber
  JMP $830F

.BANK $1D SLOT "$A000"

.ORG $0AFD
  JMP AddIRQFix

.ORG $1A20
AddIRQFix:
  LDA #$00
  STA $00
  LDA #$3C
  STA $5120

  LDA #$00
  STA PpuAddr_2006
  LDA #$30
  STA PpuAddr_2006

  LDA PpuData_2007
  LDA PpuData_2007
  CMP #$22
  BNE +
  JMP $AB7E
+
  LDA #$5C
  PHA
  LDA #$80
  STA PpuAddr_2006
  LDA #$00
  STA PpuAddr_2006
  JMP $AB00

.BANK $0D SLOT "$A000"

.ORG $0C81
  .db lobyte(DrawMapTopText)
  .db hibyte(DrawMapTopText)

.ORG $0F0A
  JMP DrawMapTopText

MapTopTextFirstRow:
  ; first row
  .db $8A, $89, $8B, $89, $8C, $8D, $85, $86, $89, $8E, $8F, $00
MapTopTextSecondRow:
  ; second row
  .db $84, $85, $86, $87, $88, $89, $9C, $94, $85, $95, $96, $97, $98, $00
  ; unused
  .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; removed code related to displaying "NO MAP"
.ORG $164B
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP

; removed world number check
.ORG $166B
  NOP
  NOP
  NOP
  NOP
  NOP

.ORG $1760
DrawMapTopText:
; set nametable address
  LDA #$20
  STA PpuAddr_2006
  LDA #$A2
  STA PpuAddr_2006

  LDX #$00
-
  LDA MapTopTextFirstRow.W,X
  BEQ + ; end of text for first row
  STA PpuData_2007
  INX
  BNE -
+
  LDA #$20
  STA PpuAddr_2006
  LDA #$C2
  STA PpuAddr_2006

  LDX #$00
-
  LDA MapTopTextSecondRow.W,X
  BEQ +
  STA PpuData_2007
  INX
  BNE -
+
  LDX #$20
  STX PpuAddr_2006
  LDX #$D6
  STX PpuAddr_2006

  LDX #$9D
  STX PpuData_2007
  STA PpuData_2007
  STA PpuData_2007

  LDX #$9E
  STX PpuData_2007
  STA PpuData_2007
  STA PpuData_2007

  LDX #$9F
  STX PpuData_2007
  STA PpuData_2007
  INC PPUIORoutine
  RTS

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

;.ORG $0F3A
;  JSR IRQFix

;.ORG $1800


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
  INC PPUIOStep
  LDA #$00
  STA PPU_MASK
  LDA #$30
  STA PpuAddr_2006
  LDA #$00
  STA PpuAddr_2006
  TXA ; TempWorldNumber
  JSR ChangeMapTiles
  LDA #$81
  STA IsInMap
  LDA #$0A
  STA PPUIORoutine
  JSR PlaySwooshSFX
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
  JSR DrawLoop

  LDA #$22
  STA PpuAddr_2006
  LDA #$65
  STA PpuAddr_2006
  LDX #$06
  JSR DrawLoop

  LDA #$22
  STA PpuAddr_2006
  LDA #$84
  STA PpuAddr_2006
  LDX #$07
  JSR DrawLoop

  LDA #$22
  STA PpuAddr_2006
  LDA #$A4
  STA PpuAddr_2006
  LDX #$07
  JSR DrawLoop

  LDA #$22
  STA PpuAddr_2006
  LDA #$C5
  STA PpuAddr_2006
  LDX #$06
  JSR DrawLoop

  LDA #$22
  STA PpuAddr_2006
  LDA #$E1
  STA PpuAddr_2006
  LDX #$0A
  JSR DrawLoop

  LDA #$23
  STA PpuAddr_2006
  LDA #$04
  STA PpuAddr_2006
  LDX #$07
  JSR DrawLoop

  LDA #$22
  STA PpuAddr_2006
  LDA #$57
  STA PpuAddr_2006
  LDX #$08
  JSR DrawLoop
  RTS

DrawLoop:
  LDA (TempAddr),Y
  STA PpuData_2007
  INY
  DEX
  BNE DrawLoop
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

ChangeMapTiles:
  CLC
  ADC #$9F
  STA $07
  AND #$1F
  LDY #$00
  STY $06
  STY $04
  LSR A
  ROR $04
  LSR A
  ROR $04
  ORA #$70
  STA $05
  LDA #$8C
  STA PRGPort1
  LDY #$FF
  STY TempRoomID
  LDY #$3F
-
  LDA #$01
  STA RAMPort
  LDA ($04),Y
  DEY
  STY $03
  LDY #$00
  STY RAMPort
  LDY TempRoomID
  PHA
  AND #$C0
  STA $00
  LDA ($06),Y
  STA MinimapTiles,Y
  AND #$3F
  ORA $00
  STA MinimapFlags,Y
  JSR +
  PLA
  ASL A
  ASL A
  DEY
  PHA
  AND #$C0
  STA $00
  LDA ($06),Y
  STA MinimapTiles,Y
  AND #$3F
  ORA $00
  STA MinimapFlags,Y
  JSR +
  PLA
  ASL A
  ASL A
  DEY
  PHA
  AND #$C0
  STA $00
  LDA ($06),Y
  STA MinimapTiles,Y
  AND #$3F
  ORA $00
  STA MinimapFlags,Y
  JSR +
  PLA
  ASL A
  ASL A
  DEY
  PHA
  AND #$C0
  STA $00
  LDA ($06),Y
  STA MinimapTiles,Y
  AND #$3F
  ORA $00
  STA MinimapFlags,Y
  JSR +
  PLA
  ASL A
  ASL A
  DEY
  STY TempRoomID
  LDY $03
  BMI ++
  JMP -
+
  TAX
  AND #$0F
  STA $07FE
  TXA
  AND #$F0
++
  ASL A
  ORA $07FE
  STA $7B00,Y
  RTS

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
  ; JSR $9390
  JSR PlaySwooshSFX
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
  JSR PlaySwooshSFX
SkipUpdateMenuCollect:
  LDX #$00
  RTS

PlaySwooshSFX:
  LDA #Sfx_StompNOI
  STA Square1SoundQueue
  RTS

	

