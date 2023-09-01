.MEMORYMAP 
SLOTSIZE   $2000
DEFAULTSLOT   0
SLOT 0      $8000       "$8000"
SLOT 1      $A000       "$A000"
SLOT 2      $C000       ; Don't Use!!! SFX!!!
SLOT 3      $E000				"$E000"
SLOT 4 		  $0000		"RAM_NES"
SLOT 5 	    $6000		"RAM_CART"
.ENDME

.ROMBANKMAP
BANKSTOTAL   48
BANKSIZE   $2000
BANKS      48
.ENDRO

.BACKGROUND "CM_1_0_noheader.nes"

.INCLUDE "src\CM_Build_Constants.asm"
.INCLUDE "src\CM_Build_RAM.asm"
.INCLUDE "src\CM_Graphics.asm"


.BANK 0 SLOT "$8000"


.ORG $0314
  JSR BtnStartPressed


.ORG $0357
_insert_b00_00:	
	JSR $918C


.ORG $04A6
_insert_b00_01:
	JMP $9181
  LDY #$00
	
	
.ORG $0519
_insert_b00_02:
	CMP #$00
	BEQ $0053
	STX $07FD
WarpMap:
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
	JSR WarpMapTableGetByte
	STA $074D
	JSR WarpMapTableGetByte
	STA $0753
	JSR WarpMapTableGetByte
	STA $0758
	JSR WarpMapTableGetByte
	STA $0759
	JSR WarpMapTableGetByte
	STA $075A
	JSR WarpMapTableGetByte
	STA $075C
	STA $0751
	JSR WarpMapTableGetByte
	STA $075B
	JSR WarpMapTableGetByte
	STA $7F16
	LDA #$0E
	STA $0E
	STY $0765
	JMP $9FD5
	
	
.ORG $1129
  JMP InputViewer
	
	
.ORG $1180
_insert_b00_03:
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
_insert_b00_04:
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
BtnStartPressed:
  LDA worldNumber
  STA worldNumber_temp
  LDA mapIsIn
  AND #%00000001
  BEQ +
  LDA worldNumber
  JSR $96FD;UpdateMapTiles
  LDA mapIsIn
+
  RTS
	NOP
	NOP
	NOP


.ORG $192E
_insert_b00_05:
	JMP $9FB0
	

.ORG $1E82
BtnSelectCheck:
    LDA #$20
    AND input
    BNE +
    -
    JMP HUDDraw
    +
    LDA $07F8
    EOR #$08
    BEQ -
    JMP WarpSelect   ; Jump To WarpSelect


.ORG $1F20
InputViewer:
  LDA #$80
  STA PpuControl_2000
  LDX #$20
  LDY #$03
  LDA #$08
  JSR InputPPUWrite
  INY
  LDA #$40
  JSR InputPPUSkipPointer
  INY
  LDA #$80
  JSR InputPPUSkipPointer
  LDY #$22
  LDA #$02
  JSR InputPPUWrite
  INY
  LDA #$04
  JSR InputPPUSkipPointer
  INY
  LDA #$01
  JSR InputPPUSkipPointer
SpawnPointActivatePrint:
  LDA spawnTilePrint
  STA PpuData_2007
  LDA #$02
  STA spawnTilePrint
  JMP BtnSelectCheck
InputPPUWrite:
  STX PpuAddr_2006
  STY PpuAddr_2006
InputPPUSkipPointer:
  AND input
  BEQ +
  TYA
  ADC #$10
  STA PpuData_2007
  RTS
	+
  STY PpuData_2007
  RTS


.ORG $1F7B
HUDDraw:
  STX PpuAddr_2006
  LDY #$12
  STY PpuAddr_2006
  LDA #$9E
  STA PpuData_2007
  LDA $50
  TAX
  AND #$80
  BEQ +
		LDA #$01
		SBC $50
		TAX
	+
  STX PpuData_2007
  LDA #$9F
  STA PpuData_2007
  LDA $8F
  TAX
  AND #$80
  BEQ +
		LDA #$01
		SBC $8F
		TAX
	+
  STX PpuData_2007
  LDY #$24
  JMP $91D1
	
FrameTimerReset:
  STA $36 ; Replaced
  LDA #$00
  STA frameTimer_hi
  STA frameTimer_lo
  RTS
	
WarpSelect:
  LDY #$00
  LDA spawnTypeUsed
  BNE HUDDraw
  LDA warpWorldLast
  BEQ HUDDraw
  STA worldNumber
  INC mapIsIn
  LDA warpIDLast
  STA roomID_temp
  JMP WarpMap
	
WarpMapRest:
  LDA worldNumber_temp
  STA worldNumber
  JMP $830F
  BRK ; WHY IS THIS A 2 BYTE INSTRUCTION?! WTF WLA?!?!?!?!
	
WarpMapTableGetByte:
  LDA (roomID_temp),Y
  INC $03
  RTS
	
WarpMapWorldNumberRedraw:
  LDA isOnMapMenu
  BEQ +
		LDX #$22
		STX PpuAddr_2006
		LDX #$4D
		STX PpuAddr_2006
		LDA worldNumber
		ADC #$30
		STA PpuData_2007
	+
  RTS


.BANK $03 SLOT "$A000"


.ORG $0C21
_insert_b03_00:
	JSR $9880
	
	
.ORG $0D88
_insert_b03_01:
	NOP
	NOP
	NOP


.ORG $1641
_insert_b03_02:
	JSR _insert_b03_03
	JMP $B64C
	NOP
	NOP
	NOP
	NOP
	NOP
	
	
.ORG $1FC0
_insert_b03_03:
	LDA $07F8
	AND #$04
	BEQ +
		LDA #$10
		STA $06E0
		ORA $7F20,Y
		STA $7F20,Y
	+
	RTS


.BANK $04 SLOT "$A000"


.ORG $112C
_insert_b04_00:
.DB $04,$02


.ORG $182C
_insert_b04_01:
	NOP
	NOP
	
	
.ORG $1845
_insert_b04_02:
	NOP
	NOP
	NOP
	NOP
	JSR $98A0
	
	
.ORG $1880
_insert_b04_03:
	TAY
	LDA $07F8
	AND #$04
	BEQ +
	TYA
	STA $7F20,X
	+
	RTS


.ORG $18A0
_insert_b04_04:
	LDA $07F8
	AND #$02
	BEQ +
		LDA $7F0D
		CLC
		ADC $9876,Y
	RTS
	+
	LDA $7F0D
	RTS
	
	
.BANK $05 SLOT "$A000"


.ORG $10C2
FrameTimerInject:
	NOP
  JSR FrameTimerIncrement
	
	
.ORG $18B0
FrameTimerIncrement:
	CLC
	LDA frameTimer_lo
	ADC #$01
	CMP #$64
	BCC ++
		LDA frameTimer_hi
		ADC #$00;$01 w/c
		CMP #$64
		BCC +
			LDA #$00
		+
		STA frameTimer_hi
		LDA #$00
	++
	STA frameTimer_lo
	STA coinCount_lo
	LDA frameTimer_hi
	STA coinCount_hi
	LDA marioControllable ; Replaced
	CMP #$07 ; Replaced
	RTS

	
.BANK $08 SLOT "$8000"


.ORG $0B8C
	JSR SpawnTriggerDisplaySet_B08


.ORG $19B0
SpawnTriggerDisplaySet_B08:
	STA spawnX
	LDA #$12
	STA spawnTilePrint
  RTS
	
	
.BANK $09 SLOT "$A000"


.ORG $04DD
_insert_b09_00:
	JSR $BFE0
	NOP
	NOP
	NOP
	NOP
	NOP
	
	
.ORG $1FE0
_insert_b09_01:
	LDA $07F8
	AND #$04
	BEQ +
		LDA #$10
		ORA $7F20,X
		STA $7F20,X
	+
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
	NOP
	NOP
	NOP
	NOP
	
	
; Map Data
.BANK $0C SLOT "$A000"


.ORG $0000
.INCBIN "src\bank0C_mapdata.bin"


.BANK $0D SLOT "$A000"


.ORG $0EB2
_insert_b0D_00:
	JMP $B760
	CLC
	JMP $B880
	NOP
	
	
.ORG $0ECE
_insert_b0D_01:
	CPY #$60
	
	
.ORG $0EE3
_insert_b0D_02:
	LDA #$AA
	STA $5105
	LDA $0742
	AND #$FB
	STA $2000
	LDA #$23
	STA $2006
	LDA #$D0
	STA $2006
	LDY #$00
	LDA #$AA
	-
		STA $2007
		INY
		CPY #$28
	BNE -
	INC $7C07
	RTS
	
; Uh data i guess?
.DB $4C,$00,$B8,$8A, $89,$8B,$89,$8C
.DB $8D,$85,$86,$89, $8E,$8F,$00,$84
.DB $85,$86,$87,$88, $89,$9C,$94,$85
.DB $95,$96,$97,$98, $00,$00,$00,$00
.DB $00,$00,$00,$00, $00,$00,$00,$00
.DB $00,$00,$00,$00, $00,$00,$00,$00

.ORG $0F65
_insert_b0D_03:
	JMP $B780
	
	
.ORG $0FD6
_insert_b0D_04:
	JMP MapDrawLoadEndDrawXY
	RTS
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP


.ORG $166B
insert_b0D_05:
	LDA #$08
  STA $2001


.ORG $1760
insert_b0D_06:
  LDA isOnMapMenu
  BNE +
		-
		LDA mapDrawRowCounter
		JMP $AEB5
	+
  LDA #$FC
  ADC mapDrawRowCounter
  BMI -
  JMP $AEDA
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
.DB $00;BRK
	
MapDrawIgnoreMenuRows:
  LDA mapDrawRowCounter
  CMP #$07
  BEQ ++
  CMP #$06
  BEQ ++
  CMP #$05
  BEQ ++
  LDA isOnMapMenu
  BEQ +
		LDA mapDrawRowCounter
		JMP $AF68
	+
  LDA mapDrawRowCounter
	++
  JMP $AF8D

.DB $00,$00,$00,$00, $00,$00,$00,$00
.DB $00,$00,$00,$00, $00,$00,$00,$00
.DB $00,$00,$00,$00, $00,$00,$00,$00
.DB $00,$00,$00,$00, $00,$00,$00,$00
	
MapDrawLoadEndDrawXY:
  LDA #$00
  STA mapDrawFlags
  LDA #$01
  STA mapIsIn
  NOP
  NOP
  NOP
  RTS
	
	
.ORG $1800
MapDraw_maybe:
	LDA #$20
  STA PpuAddr_2006
  LDA #$A2
  STA PpuAddr_2006
  LDX #$00
	-
		LDA $AF0D,X
		BEQ +
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
		LDA $AF19,X
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
  INC mapDrawFlags
  RTS


.ORG $1880
MapDrawData_maybe:
.DB $0A,$A8,$B9,$9E, $B8,$8D,$06,$20
.DB $C8,$B9,$9E,$B8, $8D,$06,$20,$4C
.DB $C7,$AE,$00,$00, $00,$00,$00,$00
.DB $00,$00,$00,$00, $00,$00,$00,$00
.DB $21,$00,$21,$60, $21,$C0,$22,$20
.DB $22,$80,$22,$E0, $22,$E0,$00,$00


.BANK $0E SLOT "$A000"


.ORG $0B04
insert_b0E_00:
.DB $67,$20,$72 ; A text fix? huh?


.ORG $1B04
insert_b0e_01:
.DB $C9,$00,$EA ; A text fix? huh?


.BANK $10 SLOT "$A000"


.ORG $0042
insert_b10_00:
.DB $01,$D5,$D0 ; Graphics?


.ORG $01BA
insert_b10_01:
.DB $01,$9C ; Graphics?


.ORG $01F7
insert_b10_02:
.DB $01,$D0 ; Graphics?


.ORG $0295
insert_b10_03:
.DB $38,$C1 ; Graphics?


.ORG $0495
insert_b10_04:
.DB $01,$C7 ; Graphics?


.ORG $0805
insert_b10_05:
.DB $01,$41 ; Graphics?


.ORG $0C9A
insert_b10_06:
.DB $01,$87 ; Graphics?


.BANK $11 SLOT "$A000"


.ORG $05B1
insert_b11_00:
.DB $02,$A8 ; Graphics?


.ORG $14D8
insert_b11_01:
.DB $02,$AE ; Graphics?


.ORG $154E
insert_b11_02:
.DB $02,$90 ; Graphics?


; Title Screen Version
.BANK $1D SLOT "$A000"


.ORG $020B
.DB "PRACTICE HACK v1.03"
.DB $00,$00,$00,$00, $00,$00,$00,$00


.ORG $19CE
	JSR SpawnTriggerDisplaySet_B1D


.ORG $1FD0
SpawnTriggerDisplaySet_B1D:
	STA spawnX
	LDA #$12
	STA spawnTilePrint
	LDA spawnX
  RTS


.BANK $1E SLOT "$8000"


; hijack and transfer the player to the menu routine
.ORG $0B3C
  BEQ +


.ORG $0B49
	+
  JMP MapRoutine
	NOP
	NOP


.ORG $0E90
ScanlineInterruptHandle_maybe:
  LDA $0590 ; scanline counter
  CMP #$03
  BEQ +
		; waste cycles for raster
		;PHP
		;PLP
		;NOP
		NOP
		NOP
		NOP
		NOP
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
  STY PpuMask_2001
  RTS


.ORG $1120
MapRoutine:
  LDA #%00011000
  STA PPUMaskVar

  LDA mapIsIn
  AND #%10000000
  BNE ++

  JSR MapMenuToggle
  LDX isOnMapMenu
  BEQ +
		JSR PracticeMenuRoutine
		JSR PracticeMenuSettingsHandle
		LDA #$00
	+
  JMP MapTilesUpdateXY
  LDA #$00
	++
  JMP $8B4E
	
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

MapTilesUpdateXY:
  LDA #$B0
  STA PpuControl_2000
  LDA #$20
  STA PpuAddr_2006
  LDA #$D7
  STA PpuAddr_2006
  LDA worldNumber_temp
  ADC #$01
  STA PpuData_2007
  LDA #$20
  STA PpuAddr_2006
  LDA #$DA
  STA PpuAddr_2006
  LDA mapCursorX
  STA PpuData_2007
  LDA #$20
  STA PpuAddr_2006
  LDA #$DD
  STA PpuAddr_2006
  LDA mapCursorY
  ADC #$02
  STA PpuData_2007
  JMP $8B51
	
	; Free
.DB $00,$00,$00,$00, $00,$00,$00,$00
.DB $00,$00,$00,$00, $00,$00,$00,$00
.DB $00,$00,$00,$00, $00,$00,$00,$00
.DB $00
 
PracticeMenuSettingsHandle:
  LDA practiceMenuCursorPos
  ASL A ; times two
  TAY

  LDA PracticeMenuSettings,Y
  STA addr03_temp+1
  INY
  LDA PracticeMenuSettings,Y
  STA addr03_temp

  JMP (addr03_temp)	
	RTS
	
	
.ORG $11C0
_dataOrSomething0_maybe:
	PHA
  PLA
  PHA
  PLA
.DB $AD


.ORG $11F0
_dataOrSomething1_maybe:
.DB $AD,$F7,$07,$D0, $08,$A9,$AA,$8D
.DB $05,$51,$4C,$52, $8E,$A9,$00,$8D
	
	
.ORG $1314
MapMenuToggle:
  LDA input
  AND #BTN_Select
  BEQ +
  AND inputDelayed
  BNE +
  LDA isOnMapMenu
  EOR #%00000001
  STA isOnMapMenu
  JSR PracticeMenuToggle
+
  RTS
	NOP
	NOP

CheckToChangeMapWorld:
  LDX worldNumber_temp
  LDA input
  AND #BTN_Right
  BEQ +
  AND inputDelayed
  BNE +
  INX
  CPX #$04
  BNE ++
  LDX #$01
  JMP ++
+
  LDA input
  AND #BTN_Left
  BEQ +++
  AND inputDelayed
  BNE +++
  DEX
  CPX #$00
  BNE ++
  LDX #$03
++
  STX worldNumber_temp
  CLC
  JSR PracticeMenuWorldDraw
  INC PPUIOStep
  LDA #$00
  STA PpuMask_2001
  LDA #$30
  STA PpuAddr_2006
  LDA #$00
  STA PpuAddr_2006
  TXA ;worldNumber_temp
  JSR MapTilesChange
  LDA #$81
  STA mapIsIn
  LDA #$0A
  STA PPUIORoutine
  JSR SFXPlaySwoosh
+++
  RTS
	NOP
	
PracticeMenuToggle:
  LDA #SFX_EnemySmack
  STA square1SoundQueue
  LDA isOnMapMenu
  BEQ +
		JSR PracticeMenuTextUpdate
	+
  JMP PracticeMenuDrawAll
	
	
.ORG $139A
SFXPlaySwoosh:
  LDA #SFX_StompNOI
  STA square1SoundQueue
  RTS
	
.DB $EA,$EA,$EA,$EA, $EA,$EA,$EA,$EA
.DB $EA,$EA,$EA,$EA, $EA,$EA,$EA,$EA
.DB $EA,$EA,$EA,$EA, $EA,$EA,$EA,$EA
.DB $EA,$EA,$EA,$EA, $EA,$EA,$EA,$EA
.DB $EA,$EA,$EA,$EA, $EA,$EA,$EA,$EA
.DB $EA,$EA,$EA,$EA, $EA,$EA,$EA,$EA
.DB $EA,$EA,$EA,$EA, $EA,$EA,$EA,$EA
.DB $EA,$EA,$EA,$EA, $EA,$EA,$EA,$EA


.ORG $13E0
PracticeMenuSettings:
	.DB $93,$2C,$97,$60, $97,$94,$00,$00
	.DB $9B,$00,$00,$00, $97,$E0,$99,$40
	.DB $00,$00,$00,$00, $00,$00,$00,$00
	.DB $00,$00,$A0,$00, $8C,$43,$07,$60
	
	
.ORG $14AD
MapTilesChange:
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
  STA BANK_PRG_A000_5115
  LDY #$FF
  STY roomID_temp
  LDY #$3F
-
  LDA #$01
  STA BANK_SRAM_6000_5113 ; WTF RiYAN? Isn't this entirely visible?! wut the bloddie fook is this mayte?!?!
  LDA ($04),Y
  DEY
  STY $03
  LDY #$00
  STY BANK_SRAM_6000_5113 ; WTF RiYAN? Isn't this entirely visible?! wut the bloddie fook is this mayte?!?!
  LDY roomID_temp
  PHA
  AND #$C0
  STA $00
  LDA ($06),Y
  STA minimapTiles,Y
  AND #$3F
  ORA $00
  STA minimapFlags,Y
  JSR +
  PLA
  ASL A
  ASL A
  DEY
  PHA
  AND #$C0
  STA $00
  LDA ($06),Y
  STA minimapTiles,Y
  AND #$3F
  ORA $00
  STA minimapFlags,Y
  JSR +
  PLA
  ASL A
  ASL A
  DEY
  PHA
  AND #$C0
  STA $00
  LDA ($06),Y
  STA minimapTiles,Y
  AND #$3F
  ORA $00
  STA minimapFlags,Y
  JSR +
  PLA
  ASL A
  ASL A
  DEY
  PHA
  AND #$C0
  STA $00
  LDA ($06),Y
  STA minimapTiles,Y
  AND #$3F
  ORA $00
  STA minimapFlags,Y
  JSR +
  PLA
  ASL A
  ASL A
  DEY
  STY roomID_temp
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


.ORG $1560
PracticeMenuTexts:
.DB "World"
.DB "Dashes"
.DB "Collect"
.DB "Display"
.DB "Select"
.DB "Death"
.DB $00 
.DB "Warp"
.DB "Respawn"
.DB "Powerups"


.ORG $15C0
PracticeMenuRoutine:
  LDA input
  AND #BTN_Up
  BEQ +++
  AND inputDelayed
  BNE +++

; play stomp SFX
  LDX #SFX_StompSQ
  STX square1SoundQueue

  DEC practiceMenuCursorPos
  BPL ++
  LDA #$07
  STA practiceMenuCursorPos
  JMP ++
	+++
  LDA input
  AND #BTN_Down
  BEQ ++
  AND inputDelayed
  BNE ++

; play stomp SFX
  LDX #SFX_StompSQ
  STX square1SoundQueue

  LDX practiceMenuCursorPos
  INX
  CPX #$08
  BNE +
  LDX #$00
  +
  STX practiceMenuCursorPos
  ++
  LDA practiceMenuCursorPos
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


.ORG $1640
PracticeMenuTextUpdate:
  LDA isOnMapMenu
  BNE +
		RTS
	+
  LDA #$60
  STA addr0A_temp
  LDA #$95
  STA addr0A_temp+1
  LDA #$22
  STA PpuAddr_2006
  LDA #$46
  STA PpuAddr_2006
  LDX #$05
	-
  LDA (addr0A_temp),Y
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
  LDA (addr0A_temp),Y
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
  LDA (addr0A_temp),Y
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
  LDA (addr0A_temp),Y
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
  LDA (addr0A_temp),Y
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
  LDA (addr0A_temp),Y
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
  LDA (addr0A_temp),Y
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
  LDA (addr0A_temp),Y
  STA PpuData_2007
  INY
  DEX
  BNE -
  RTS
  NOP
  NOP


.ORG $1760
PracticeMenuMaxDashesChange:
  LDX maxDashesCount
  LDA input
  AND #BTN_Right
  BEQ +
  AND inputDelayed
  BNE +
  INX
  CPX #$08
  BNE ++
  LDX #$01
  JMP ++
+ ; check if pressing left
  LDA input
  AND #BTN_Left
  BEQ +++
  AND inputDelayed
  BNE +++
  DEX
  CPX #$00
  BNE ++
  LDX #$07
++: ; do stuff
  STX maxDashesCount
  JSR PracticeMenuDashesDraw
  JSR SFXPlaySwoosh
+++: ; end
  LDX #$00
  RTS

PracticeMenuCollectChange:
  LDA practiceFlags
  TAY
  AND #%00000110
  LSR A
  TAX
  LDA input
  AND #BTN_Right
  BEQ +
  AND inputDelayed
  BNE +
  INX
  CPX #$04
  BNE ++
  LDX #$00
  JMP ++
	+
  LDA input
  AND #BTN_Left
  BEQ +++
  AND inputDelayed
  BNE +++
  DEX
  BPL ++
		LDX #$03
	++
  TXA
  ASL A
  STA practiceFlags
  TYA
  AND #$F9
  ADC practiceFlags
  STA practiceFlags
  JSR PracticeMenuCollectDraw
  JSR SFXPlaySwoosh
	+++
  LDX #$00
  RTS
	
	
.ORG $17E0
PracticeMenuRespawnChange:
  LDA input
  AND #$01
  BEQ +
  AND inputDelayed
  BNE +
  LDA practiceFlags
  EOR #$01
  JMP ++
	+
  LDA input
  AND #$02
  BEQ +
  AND inputDelayed
  BNE +
	++
  LDA practiceFlags
  EOR #$01
  STA practiceFlags
  JSR PracticeMenuRespawnDraw
  JSR SFXPlaySwoosh
	+
  LDX #$00
  RTS

	
.ORG $1820
PracticeMenuCollectDraw:
  LDA #$22
  STA PpuAddr_2006
  LDA #$8D
  STA PpuAddr_2006
  LDA practiceFlags
  TAX
  AND #$02
  BEQ +
  LDA #$82
  JMP ++
	+
  LDA #$80
	++
  STA PpuData_2007
  TXA
  AND #$04
  BEQ +
  LDA #$81
  JMP ++
	+
  LDA #$80
  ++
	STA PpuData_2007
  RTS

	
.ORG $1860
PracticeMenuWorldDraw:
  LDA #$22
  STA PpuAddr_2006
  LDA #$4D
  STA PpuAddr_2006
  LDA worldNumber_temp
  ADC #$30
  STA PpuData_2007
  RTS
	
	
.ORG $1880
PracticeMenuDashesDraw:
  LDA #$22
  STA PpuAddr_2006
  LDA #$6D
  STA PpuAddr_2006
  CLC
  LDA maxDashesCount
  ADC #$30
  STA PpuData_2007
  RTS
	
	
.ORG $18A0
PracticeMenuRespawnDraw:
  LDA #$23
  STA PpuAddr_2006
  LDA #$0D
  STA PpuAddr_2006
  LDA practiceFlags
  AND #$01
  BNE +
		LDA #$53
		STA PpuData_2007
		LDA #$6C
		STA PpuData_2007
		LDA #$6F
		STA PpuData_2007
		LDA #$77
		STA PpuData_2007
		RTS
	+
  LDA #$46
  STA PpuData_2007
  LDA #$61
  STA PpuData_2007
  LDA #$73
  STA PpuData_2007
  LDA #$74
  STA PpuData_2007
  RTS

	
.ORG $1900
PracticeMenuDrawAll:
  JSR PracticeMenuWorldDraw
  JSR PracticeMenuDashesDraw
  JSR PracticeMenuCollectDraw
  JSR PracticeMenuSelectDraw
  JSR PracticeMenuRespawnDraw
  JSR PracticeMenuAbilityDraw
  JMP $8B51
	
	
.ORG $1940
PracticeMenuAbilitiesChange:
  LDA #$00
  LDX abilityWallJump
  BEQ +
		ADC #$01 ; PROB: WHAT IS THE CARRY FLAG?!
	+
  LDX abilityDash
  BEQ +
		ADC #$02
	+
  LDX inventoryItem
  BEQ +
		ADC #$04
	+
  TAX
  LDA input
  AND #$01
  BEQ +
  AND inputDelayed
  BNE +
  INX
  CPX #$08
  BNE ++
  LDX #$00
  JMP ++
	+
  LDA input
  AND #$02
  BEQ +++
  AND inputDelayed
  BNE +++
  DEX
  BPL ++
  LDX #$07
	++
  TXA
  AND #$01
  BEQ +
		LDA #$02
	+
  STA abilityWallJump
  TXA
  AND #$02
  STA abilityDash
  TXA
  AND #$04
  BEQ +
		LDA #$03
	+
  STA inventoryItem
  JSR PracticeMenuAbilityDraw
  JSR SFXPlaySwoosh
	+++
  LDX #$00
  RTS

	
.ORG $19C0
PracticeMenuAbilityDraw:
  LDX #$00
  LDA #$22
  STA PpuAddr_2006
  LDA #$97
  STA PpuAddr_2006
  LDA abilityWallJump
  BNE +
  LDA #$90
  STA PpuData_2007
  LDA #$91
  STA PpuData_2007
  JMP ++
	+
  LDA #$83
  STA PpuData_2007
  LDA #$84
  STA PpuData_2007
	++
  STX PpuData_2007
  LDA abilityDash
  BNE +
  LDA #$90
  STA PpuData_2007
  LDA #$91
  STA PpuData_2007
  JMP ++
	+
  LDA #$87
  STA PpuData_2007
  LDA #$88
  STA PpuData_2007
	++
  STX PpuData_2007
  LDA inventoryItem
  BNE +
  LDA #$90
  STA PpuData_2007
  LDA #$91
  STA PpuData_2007
  JMP ++
	+
  LDA #$8B
  STA PpuData_2007
  LDA #$8C
  STA PpuData_2007
	++
  LDA #$22
  STA PpuAddr_2006
  LDA #$B7
  STA PpuAddr_2006
  LDA abilityWallJump
  BNE +
  LDA #$A0
  STA PpuData_2007
  LDA #$A1
  STA PpuData_2007
  JMP ++
	+
  LDA #$85
  STA PpuData_2007
  LDA #$86
  STA PpuData_2007
	++
  STX PpuData_2007
  LDA abilityDash
  BNE +
  LDA #$A0
  STA PpuData_2007
  LDA #$A1
  STA PpuData_2007
  JMP ++
	+
  LDA #$89
  STA PpuData_2007
  LDA #$8A
  STA PpuData_2007
	++
  STX PpuData_2007
  LDA inventoryItem
  BNE +
  LDA #$A0
  STA PpuData_2007
  LDA #$A1
  STA PpuData_2007
  JMP ++
	+
  LDA #$8D
  STA PpuData_2007
  LDA #$8E
  STA PpuData_2007
	++
  RTS

	
.ORG $1AA0
PracticeMenuSelectDraw:
  LDA #$22
  STA PpuAddr_2006
  LDA #$CD
  STA PpuAddr_2006
  LDA practiceFlags
  AND #$08
  BNE +
		LDA #$57
		STA PpuData_2007
		LDA #$61
		STA PpuData_2007
		LDA #$72
		STA PpuData_2007
		LDA #$70
		STA PpuData_2007
		LDA #$73
		STA PpuData_2007
		RTS
	+
  LDA #$58
  STA PpuData_2007
  LDA #$52
  STA PpuData_2007
  LDA #$61
  STA PpuData_2007
  LDA #$79
  STA PpuData_2007
  LDA #$73
  STA PpuData_2007
  RTS
	
	
.ORG $1B00
PracticeMenuSelectChange:
; BUG: There is a known issue where this gets stuck on warp instead of select sometimes, emi saw it, CH saw it, can't reproduce reliably...  - CH
; BUG2: Ok, it seems as if you warp to a different world before you set the xray settings, SOMETIMES, it gets stuck on select warp, not sure, will investigate further - CH
  LDA input
  AND #$01
  BEQ +
  AND inputDelayed
  BNE +
  JMP ++
	+
  LDA input
  AND #$02
  BEQ +
  AND inputDelayed
  BNE +
	++
  LDA practiceFlags
  EOR #$08
  STA practiceFlags
  JSR PracticeMenuSelectDraw
  JSR SFXPlaySwoosh
	+
  LDX #$00
  RTS
	
	
.BANK $1F SLOT "$E000"


.ORG $08FF
RespawnFastInject:
	JSR $FCC0
	NOP
	NOP


.ORG $1CC0
RespawnFastCheck:
  TAY
  LDA practiceFlags
  AND #$01
  BNE +
		LDA #$FF
		STA deathTimer
		TYA
		RTS
	+
	LDA #$E1
  STA deathTimer
  TYA
	RTS