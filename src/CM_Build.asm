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

; %vbindiff% CMZND_~2.nes CM_BUI~1.nes

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


.ORG $0357
_insert00:	
	JSR $918C


.ORG $04A6
_insert01:
	JMP $9181
  LDY #$00
	
.ORG $0519
_insert02:
	CMP #$00
	BEQ $0053
	STX $07FD
	LDA #$8C
	STA $5115
	LDA $07FB
	STA $07FC
	ASL A
	ASL A
	ASL A
	CLC
	ADC #$9B
	STA $03
	JSR $9FE0
	STA $074D
	JSR $9FE0
	STA $0753
	JSR $9FE0
	STA $0758
	JSR $9FE0
	STA $0759
	JSR $9FE0
	STA $075A
	JSR $9FE0
	STA $075C
	STA $0751
	JSR $9FE0
	STA $075B
	JSR $9FE0
	STA $7F16
	LDA #$0E
	STA $0E
	STY $0765
	JMP $9FD5
	
.ORG $1129
  JMP InputViewer
	
.ORG $1180
_insert03:
	RTS
	LDA $07FA
	BNE +
		JMP $84A9
	+
	JMP $8570
	LDA #$00
	STA $07FA
	LDA $7C07
	RTS
	LDX #$01
	STX $07F8
	LDX $0119
	RTS
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
_insert04:
	TAX
	AND #$0F
	STA $07FE
	TXA
	AND #$F0
	ASL A
	ORA $07FE
	STA $7B00,Y
	RTS
					
.ORG $17D0
StartPressed:
  LDA WorldNumber
  STA TempWorldNumber
  LDA IsInMap
  AND #%00000001
  BEQ +
  LDA WorldNumber
  JSR $96FD;UpdateMapTiles
  LDA IsInMap
+
  RTS
	NOP
	NOP
	NOP

.ORG $192E
_insert05:
	JMP $9FB0
	
;.ORG $1DA0
	

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
    BEQ +
    TYA
    ADC #$10
    TAY
+
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
		
.ORG $1FB0
_insert06:
	STA $36
	LDA #$00
	STA $77EE
	STA $77EF
	RTS
	LDY #$00
	LDA $0751
	;BNE $A7
	.DB $D0,$95 ; BNE $95
	LDA $07FC
	.DB $F0,$90 ; BEQ $90
	;BEQ $A7
	STA $057F
	INC $04BD
	LDA $07FD
	STA $02
	JMP $8520
	LDA $07FB
	STA $057F
	JMP $830F
	BRK
	;hey
	LDA ($02),Y
	INC $03
	RTS
	LDA $07FA
	BEQ +
	LDX #$22
	STX $2006
	LDX #$4D
	STX $2006
	LDA $057F
	ADC #$30
	STA $2007
	+
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

	

