.MEMORYMAP 
SLOTSIZE			$2000
DEFAULTSLOT		0
SLOT 0		$8000		"$8000"
SLOT 1		$A000		"$A000"
SLOT 2		$C000		; Don't Use!!! SFX!!!
SLOT 3		$E000		"$E000"
SLOT 4		$0000		"RAM_NES"
SLOT 5		$6000		"RAM_CART"
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


.ORG $030F
PauseMenuEntry0_b0:

.ORG $0314
PauseEntryInject:
  JSR BtnStartPressed


.ORG $0357
PauseExitHandle:	
	JSR $918C


.ORG $04A6
PauseMapCursorHandle:
	JMP $9181
  LDY #$00
	
	
.ORG $0519
PauseEntryHandle1_b0:
	CMP #$00
	BEQ $0053
	STX $07FD
	
WarpMapHandle:
	LDA #$8C
	STA BANK_PRG_A000_5115
	LDA worldNumber_temp
	STA warpWorldLast
	ASL A
	ASL A
	CLC
	ADC #$A2
	STA $03
  JMP WarpTableCopyData
	; JSR WarpMapTableGetByte
  ; STX roomOffset
	; STA roomID
	; JSR WarpMapTableGetByte
  ; STX spawnXHigh
  ; ASL
  ; ASL
  ; ASL
  ; STA spawnX
	; JSR WarpMapTableGetByte
	; STX spawnYHigh
  ; ASL
  ; ASL
  ; ASL
  ; STA spawnY
	; JSR WarpMapTableGetByte
  ; STX spawnSwitchStatus
	; STA spawnType
	; STA spawnTypeUsed
	; LDA #$0E
	; STA $0E
	; STY $0765
	; JMP WarpMapReset
	
; Save RAM in $6E00-$6FFF
.ORG $0F47
SaveIn_6E00_6FFF:
	LDX #$6D
	
.ORG $1112
HUDColorFixXY:
	.DB $8D
	
	
.ORG $111D
HUDDisplayVanilla:


.ORG $113C
HUDStarBarDontDrawEnd:
	LDX #$0F ; $10 goes all the way, clear out one tile


.ORG $1129
  JMP BankSwitchHUD
	
	
.ORG $1180
_insert_b00_03:
	RTS
	LDA isOnMapMenu
	BNE +
		JMP $84A9
	+
	RTS
	NOP ; might need these... dont ask
	NOP ; might need these... dont ask
	LDA #$00
	STA isOnMapMenu
	LDA $7C07
	RTS
	LDX #$01
	STX practiceFlags
	LDX minimapOffset
	RTS
	

.ORG $11CA
_insert_b00_04:
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
MiniMapHandle:
	TAX
	AND #$0F
	STA $07FE
	TXA
	AND #$F0
	ASL A
	ORA $07FE
	STA $7B00,Y
	RTS
	

.ORG $16FD
MapTileUpdate:
				
				
.ORG $17D0
BtnStartPressed:
  LDA worldNumber
  STA worldNumber_temp
  LDA mapIsIn
  AND #%00000001
  BEQ +
		LDA worldNumber
		JSR MapTileUpdate
		LDA mapIsIn
	+
  RTS
	NOP
	NOP
	NOP


.ORG $192E
FrameTimerResetInject:
	JMP FrameTimerReset
	

.ORG $1F30
BankSwitchHUD:
	LDA #$82
	STA BANK_PRG_A000_5115
	JMP InputViewer
	
BankSwitchReturnHUD:
	LDA #$88
	STA BANK_PRG_A000_5115
	JMP PPUReturn

BankSwitchReturnWarp:
	LDA #$88
	STA BANK_PRG_A000_5115
	JMP WarpMapHandle
	
WarpMapReset:
  LDA worldNumber_temp
  STA worldNumber
  JMP PauseMenuEntry0_b0
	
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

FrameTimerReset:
  STA $36 ; Replaced
  LDA #$00
  STA frameTimer_hi
  STA frameTimer_lo
  RTS	

.BANK $02 SLOT "$A000"

.ORG $1300


InputViewer:
  LDA #$80
  STA PpuControl_2000
  LDX #$20
  LDY #$03
  LDA #$08
  STX PpuAddr_2006
  STY PpuAddr_2006
  AND input
  BEQ +
  TYA
  ADC #$10
  STA PpuData_2007
  BNE ++
	+
  STY PpuData_2007
  ++
  INY
  LDA #$40
  AND input
  BEQ +
  TYA
  ADC #$10
  STA PpuData_2007
  BNE ++
	+
  STY PpuData_2007
  ++
  INY
  LDA #$80
  AND input
  BEQ +
  TYA
  ADC #$10
  STA PpuData_2007
  BNE ++
	+
  STY PpuData_2007
  ++
  LDY #$22
  LDA #$02
  STX PpuAddr_2006
  STY PpuAddr_2006
  AND input
  BEQ +
  TYA
  ADC #$10
  STA PpuData_2007
  BNE ++
	+
  STY PpuData_2007
  ++
  INY
  LDA #$04
  AND input
  BEQ +
  TYA
  ADC #$10
  STA PpuData_2007
  BNE ++
	+
  STY PpuData_2007
  ++
  INY
  LDA #$01
  AND input
  BEQ +
  TYA
  ADC #$10
  STA PpuData_2007
  BNE ++
	+
  STY PpuData_2007
  ++
	
SpawnPointActivatePrint:
  LDA spawnTilePrint
  STA PpuData_2007
  LDA #$02
  STA spawnTilePrint
	
BtnSelectCheck:
	LDA #$20
	AND input
	BEQ HUDDraw
	LDA practiceFlags
	AND #PRAC_btnSelect
	BNE HUDDraw
	
WarpSelect:
  LDY #$00
  LDA spawnTypeUsed
  BNE HUDDraw
  LDA warpWorldLast
  BEQ HUDDraw
	STY PPUMaskVar ; fix'd
  STA worldNumber
  INC mapIsIn
  LDA warpIDLast
  STA roomID_temp
  JMP BankSwitchReturnWarp

HUDDraw:
  STX PpuAddr_2006
  LDY #$52
  STY PpuAddr_2006
  LDA #$9E
  STA PpuData_2007
  LDA marioSpeedX
	BPL +	
		SEC
		SBC #$01
		EOR #$FF
	+
  STA PpuData_2007
  LDA #$9F
  STA PpuData_2007
  LDA marioSpeedY
	BPL +
		SEC
		SBC #$01
		EOR #$FF
	+
  STA PpuData_2007
	
	; Moon count
	LDA #$20
	STA PpuAddr_2006
	LDA #$14
	STA PpuAddr_2006
	LDX #$6A
  LDA moonCount
  CMP #$64
  BCC +
  INX
  SBC #$64
	+
  STX PpuData_2007
  STA PpuData_2007
	
  LDY #$24
  JMP BankSwitchReturnHUD
	

.BANK $03 SLOT "$A000"


.ORG $0C21
_insert_b03_00:
	JSR MoonCollectDashHandle_b04
	
	
.ORG $0CD3
ItemMessageSkip:
	JSR MoonCollectMessageSkip_b03
	
	
.ORG $0D05
ItemExplanationSkip:
	JSR ItemSkipExplanation
	

.ORG $0D88
MoonCollectIncInject_b3_00:
	JSR MoonCollectIncHandle_7F0B
	

.ORG $1641
_insert_b03_02:
	JSR MoonCollectDashMeter
	JMP $B64C
	NOP
	NOP
	NOP
	NOP
	NOP
	
.ORG $1671
MoonCollectSuperMessageSkip:
	JSR MoonCollectMessageSkip_b03

	
.ORG $1E00
MoonCollectDashMeter:
	LDA practiceFlags
	AND #PRAC_moonCollect
	BEQ +
		LDA #$10
		STA $06E0
		ORA $7F20,Y
		STA $7F20,Y
	+
	RTS

	
MoonCollectIncHandle_7F0B:
	PHA
	LDA practiceFlags
	AND #PRAC_moonCollect
	BEQ +
		INC $7F0B ; i don't know what this does?
	+
	PLA
	RTS
	
MoonCollectMessageSkip_b03:
	PHA
	LDA practiceFlags
	AND #PRAC_messageShow
	BEQ +
		PLA
		JMP $F6E8	
	+
	PLA
	RTS
	
ItemSkipExplanation:
	PHA
	LDA practiceFlags
	AND #PRAC_messageShow
	BEQ +
		PLA
		JMP $F729
	+
	PLA
	RTS
	

.BANK $04 SLOT "$8000"

.ORG $1823
MoonCollectIncInject_b4_00:
	JSR MoonCollectIncHandle
	
	
.ORG $112C
RoomAddressStoreChange_CH:
.DB $04,$02


.ORG $1828
MoonCollectMessage01_Inject:
	JMP MoonCollectMessage01
MoonCollectMessage01_Return:
	
.ORG $1845
MoonCollectMessageMaxDash:
	NOP
	NOP
	NOP
	NOP
	JSR MoonCollectHandle_B04
	
.ORG $1862
MoonCollectDashMessageSkip_Inject:
	JMP MoonCollectDashMessageSkip
	
.ORG $1880
MoonCollectDashHandle_b04:
	TAY
	LDA practiceFlags
	AND #PRAC_moonCollect
	BEQ +
		TYA
		STA $7F20,X
	+
	RTS


.ORG $18A0
MoonCollectHandle_B04:
	LDA practiceFlags
	AND #PRAC_moonCollect
	BEQ +
		LDA $7F0D
		CLC
		ADC $9876,Y
	RTS
	+
	LDA $7F0D
	RTS

.ORG $1F00
MoonCollectIncHandle:
	PHA
	LDA practiceFlags
	AND #PRAC_moonCollect
	BEQ +
		INC moonCount
	+
	PLA
	RTS
	
MoonCollectMessage01:
	LDA practiceFlags
	AND #PRAC_moonsAndMessages
	CMP #PRAC_moonsAndMessages
	BEQ ++
		LDA moonCount
		LSR
		BEQ +
			LDA moonCount
			JMP MoonCollectMessage01_Return
		+
		LDA #$10 ; Play SFX
		STA square1SoundQueue ; And bounce
		RTS ; Later!
	++
	LDA moonCount
	JMP MoonCollectMessage01_Return
	
	
MoonCollectDashMessageSkip:
	PHA
	LDA practiceFlags
	AND #PRAC_messageShow
	BEQ +
		PLA
		JMP $F6E8
	+
	PLA
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
MoonCollectInject:
	JSR MoonCollectHandle_B09
	NOP
	NOP
	NOP
	NOP
	NOP
	
	
.ORG $1FE0
MoonCollectHandle_B09:
	LDA practiceFlags
	AND #PRAC_moonCollect
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
.ORG $1E00
WarpTableCopyData:
  LDA (roomID_temp),Y ;Byte 1 (Room)
  TAX
  LSR
  LSR
  LSR 
  LSR 
  LSR  
  AND #$07
  STA roomOffset
  TXA
  AND #$1F
  STA roomID
  INC $03
  LDA (roomID_temp),Y ;Byte 2 (X Position)
  TAX
  LSR
  LSR
  LSR 
  LSR 
  LSR  
  AND #$07
  STA spawnXHigh
  TXA
  ASL
  ASL
  ASL
  AND #$F8
  STA spawnX
  INC $03
  LDA (roomID_temp),Y ;Byte 3 (Y Position)
  TAX
  LSR
  LSR
  LSR 
  LSR 
  LSR  
  AND #$07
  STA spawnYHigh
  TXA
  ASL
  ASL
  ASL
  AND #$F8
  STA spawnY
  INC $03
  LDA (roomID_temp),Y ;Byte 4 (Status/Type)
  TAX
  LSR
  LSR
  LSR 
  LSR 
  LSR  
  AND #$07
  STA spawnSwitchStatus
  TXA
  AND #$1F
  STA spawnType
  STA spawnTypeUsed
	LDA #$0E
	STA $0E
	STY $0765
	JMP WarpMapReset

.BANK $0D SLOT "$A000"


.ORG $0EB2
MapDraw_Insert0_CH:
	JMP MapDraw_Insert6_CH
	CLC
	JMP MapDraw_Insert7_CH
	NOP
	
	
.ORG $0ECE
MapDraw_Insert1_CH:
	CPY #$60
	
	
.ORG $0EE3
MapDraw_Insert2_CH:
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
MapDraw_Insert3_CH:
	JMP MapDrawIgnoreMenuRows
	
	
.ORG $0FD6
MapDraw_Insert4_CH:
	JMP MapDrawLoadEndDrawXY


.ORG $166B
MapDraw_Insert5_CH:
	LDA #$08
  STA PpuMask_2001


.ORG $1760
MapDraw_Insert6_CH:
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
	LDA #$22
  STA PpuAddr_2006
  LDA #$6A
  STA PpuAddr_2006
	LDX #$0C
	LDA isOnMapMenu
	BNE ++
	LDY #$00
	-
		LDA PracticeMenuTeaserText, y
		STA PpuData_2007
		INY
		DEX
	BNE -
	
	LDA #$22
  STA PpuAddr_2006
  LDA #$AC
  STA PpuAddr_2006
	LDX #$08
	-
		LDA PracticeMenuTeaserText, y
		STA PpuData_2007
		INY
		DEX
	BNE -
	++
  INC mapDrawFlags
  RTS


.ORG $1880
MapDraw_Insert7_CH:
	ASL A
	TAY
	LDA $B89E,Y
	STA $2006
	INY
	LDA $B89E,Y
	STA $2006
	JMP $AEC7


.ORG $18A0
.DB $21,$00,$21,$60, $21,$C0,$22,$20
.DB $22,$80,$22,$E0, $22,$E0,$00,$00


.ORG $1900
PracticeMenuTeaserText:
.DB "Press Select"
.DB "For Menu"


.BANK $0E SLOT "$A000"

.ORG $0B04
_insert_b0E_00:
.DB $67,$20,$72 ; A text fix? huh?

.ORG $1B04
_insert_b0e_01:
.DB $C9,$00,$EA ; A text fix? huh?

.BANK $10 SLOT "$A000"
.ORG $0000
.INCBIN "src\bank10_mappositions1.bin"

.BANK $11 SLOT "$A000"
.ORG $0000
.INCBIN "src\bank11_mappositions2.bin"

.BANK $12 SLOT "$A000"
.ORG $0000
.INCBIN "src\bank12_mappositions3.bin"

.BANK $13 SLOT "$A000"
.ORG $0000
.INCBIN "src\bank13_mappositions4.bin"

; Title Screen Version
.BANK $1D SLOT "$A000"


.ORG $020B
.DB "PRACTICE ROM v1.2"
.DB $00,$00,$00,$00, $00,$00,$00,$00
.DB $00,$00


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
		PLA
		PHA
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
  LDY practiceMenuCursorPos

  LDA PracticeMenuSettings_lo,Y
  STA addr03_temp+1
  LDA PracticeMenuSettings_hi,Y
  STA addr03_temp
	
	LDA input
	EOR inputDelayed
	AND input
	TAY

  JMP (addr03_temp)	
	
	
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

PracticeMenuMapWorldChange:
  LDX worldNumber_temp
  AND #BTN_Right
  BEQ +
  INX
  CPX #$05  ;Value that overflows to world 1
  BNE ++
  LDX #$01
  JMP ++
+
  TYA
  AND #BTN_Left
	BEQ +++
  DEX
  BNE ++
  LDX #$04  ;Value that world 1 underflows to
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
  LDA #SFX_StompNOI
  STA square1SoundQueue
+++
  RTS
	NOP
	
PracticeMenuToggle:
  LDA #SFX_EnemySmack
  STA square1SoundQueue
  LDA isOnMapMenu
  BEQ +
		JSR PracticeMenuTextStaticDraw
	+
  JMP PracticeMenuDrawAll
	

.ORG $13A0
PracticeMenuSettings_lo:
.DB >PracticeMenuMapWorldChange
.DB >PracticeMenuMaxDashesChange
.DB >PracticeMenuMoonsChange
.DB >PracticeMenuMessagesChange
.DB >PracticeMenuSelectChange
.DB >PracticeMenuDeathChange
.DB >PracticeMenuAbilitiesChange
;	.DB $93,$2C,$97,$60, $97,$94,$00,$00
;	.DB $9B,$00,$00,$00, $97,$E0,$99,$40
;	.DB $00,$00,$00,$00, $00,$00,$00,$00
;	.DB $00,$00,$A0,$00, $8C,$43,$07,$60
	
.ORG $13D0
PracticeMenuSettings_hi:
.DB <PracticeMenuMapWorldChange
.DB <PracticeMenuMaxDashesChange
.DB <PracticeMenuMoonsChange
.DB <PracticeMenuMessagesChange
.DB <PracticeMenuSelectChange
.DB <PracticeMenuDeathChange
.DB <PracticeMenuAbilitiesChange
	
	
.ORG $14AD
MapTilesChange:
  CLC
  ADC #$9F
  STA $07
  AND #$1F
  LDY #$00
	STY PPUMaskVar ; Flicker fix on switch. Good enough - CH
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
  LDA ($04),Y
  DEY
  STY $03
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
;  ORA $00
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
;	ORA $00
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
.DB "Moons"
.DB "Messages"
.DB "Select"
.DB "Death"
.DB "Powerups"


.ORG $15C0
PracticeMenuRoutine:
  LDA input
	EOR inputDelayed
	AND input
	TAY
  AND #BTN_Up
  BEQ +++

; play stomp SFX
  LDX #SFX_StompSQ
  STX square1SoundQueue

  DEC practiceMenuCursorPos
  BPL ++
  LDA #$06
  STA practiceMenuCursorPos
  JMP ++
	+++
  TYA
  AND #BTN_Down
  BEQ ++

; play stomp SFX
  LDX #SFX_StompSQ
  STX square1SoundQueue

  LDX practiceMenuCursorPos
  INX
  CPX #$07
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
  CPY #$06
  BNE +
  SBC #$30
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
PracticeMenuTextStaticDraw:
	; i hardcoded these instead, for speed, should be enough room for a few of them, can redo temp address if need be. -CH
  ;LDA #<PracticeMenuTexts
  ;STA addr0A_temp
  ;LDA #>PracticeMenuTexts
  ;STA addr0A_temp+1
  LDA #$22
  STA PpuAddr_2006
  LDA #$46
  STA PpuAddr_2006
  LDX #$05 ; World
	-
	; LDA (addr0A_temp), y
  LDA PracticeMenuTexts, y
  STA PpuData_2007
  INY
  DEX
  BNE -
  LDA #$22
  STA PpuAddr_2006
  LDA #$65
  STA PpuAddr_2006
  LDX #$06 ; Dashes
	-
  LDA PracticeMenuTexts, y
  STA PpuData_2007
  INY
  DEX
  BNE -
	LDA #$00
	LDX #$03 ; Clear message
	-
		STA PpuData_2007
		STA PpuData_2007
		STA PpuData_2007
		STA PpuData_2007
		DEX
	BNE -
  LDA #$22
  STA PpuAddr_2006
  LDA #$86
  STA PpuAddr_2006
  LDX #$05 ; Moons
	-
  LDA PracticeMenuTexts, y
  STA PpuData_2007
  INY
  DEX
  BNE -
  LDA #$22
  STA PpuAddr_2006
  LDA #$A3
  STA PpuAddr_2006
  LDX #$04 ; Messages
	-
  LDA PracticeMenuTexts, y
  STA PpuData_2007
  INY
	LDA PracticeMenuTexts, y
  STA PpuData_2007
  INY
  DEX
  BNE -
	LDA #$00
	LDX #$03 ; Clear message
	-
		STA PpuData_2007
		STA PpuData_2007
		STA PpuData_2007
		STA PpuData_2007
		DEX
	BNE -
  LDA #$22
  STA PpuAddr_2006
  LDA #$C5
  STA PpuAddr_2006
  LDX #$06 ; Select
	-
  LDA PracticeMenuTexts, y
  STA PpuData_2007
  INY
  DEX
  BNE -
  LDA #$22
  STA PpuAddr_2006
  LDA #$E6
  STA PpuAddr_2006
  LDX #$05 ; Death
	-
  LDA PracticeMenuTexts, y
  STA PpuData_2007
  INY
  DEX
  BNE -
  LDA #$22
  STA PpuAddr_2006
  LDA #$57
  STA PpuAddr_2006
  LDX #$04 ; Powerups
	-
	LDA PracticeMenuTexts, y
  STA PpuData_2007
  INY
  LDA PracticeMenuTexts, y
  STA PpuData_2007
  INY
  DEX
  BNE -
  RTS
  NOP
  NOP


PracticeMenuMaxDashesChange:
  LDX maxDashesCount
  AND #BTN_Right
  BEQ +
  INX
  CPX #$08
  BNE ++
  LDX #$01
  JMP ++
+ ; check if pressing left
  TYA ;input
  AND #BTN_Left
  BEQ +++
  DEX
  CPX #$00
  BNE ++
  LDX #$07
++
  STX maxDashesCount
  JSR PracticeMenuDashesDraw
  LDA #SFX_StompNOI
  STA square1SoundQueue
+++: ; end
  LDX #$00
  RTS

PracticeMenuMoonsChange:
	AND #BTN_Right
	BEQ +
		-
		LDA #%00000010
		EOR practiceFlags
		STA practiceFlags
		LDA #SFX_StompNOI
		STA square1SoundQueue
		JMP PracticeMenuMoonsDraw
		RTS
	+
	TYA ;input
	AND #BTN_Left
	BNE -
	RTS
	
PracticeMenuMessagesChange:
	AND #BTN_Right
	BEQ +
		-
		LDA #%00100000
		EOR practiceFlags
		STA practiceFlags
		LDA #SFX_StompNOI
		STA square1SoundQueue
		JMP PracticeMenuMessagesDraw
		RTS
	+
	TYA ;input
	AND #BTN_Left
	BNE -
	RTS
	
	
PracticeMenuDeathChange:
  AND #BTN_Right
  BEQ +
		-
		LDA practiceFlags
		EOR #PRAC_respawnQuick
		STA practiceFlags
		LDA #SFX_StompNOI
		STA square1SoundQueue
		JMP PracticeMenuDeathDraw
	+
  TYA ;input
  AND #BTN_Left
	BNE -
  RTS


PracticeMenuMoonsText:
.DB "Respawn "
.DB "Collect "


PracticeMenuMoonsDraw:
  LDA #$22
  STA PpuAddr_2006
  LDA #$8D
  STA PpuAddr_2006
  LDA practiceFlags
	AND #PRAC_moonCollect
	ASL
	ASL
	TAY
	LDX #$08
	-
		LDA PracticeMenuMoonsText, y
		STA PpuData_2007
		INY
		DEX
	BNE -
	
  RTS

	
PracticeMenuWorldDraw:
  LDA #$22
  STA PpuAddr_2006
  LDA #$4D
  STA PpuAddr_2006
  LDA worldNumber_temp
  ADC #$30
  STA PpuData_2007
  RTS
	
	
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
	
	
PracticeMenuMessagesDraw:
	LDA #$22
  STA PpuAddr_2006
  LDA #$AD
  STA PpuAddr_2006
  LDA practiceFlags
  AND #%00100000
  BEQ +
		LDA #$59 ; Yes
		STA PpuData_2007
		LDA #$65
		STA PpuData_2007
		LDA #$73
		STA PpuData_2007
		RTS
	+
  LDA #$4E ; No_
  STA PpuData_2007
  LDA #$6F
  STA PpuData_2007
	LDA #$00
  STA PpuData_2007
  RTS
	
	
PracticeMenuDeathText:
.DB "Normal"
.DB $00,$00
.DB "Fast"
.DB $00,$00,$00,$00

PracticeMenuDeathDraw:
  LDA #$22
  STA PpuAddr_2006
  LDA #$ED
  STA PpuAddr_2006
  LDA practiceFlags
	AND #PRAC_respawnQuick
	ASL
	ASL
	ASL
	TAY
	LDX #$08
	-
		LDA PracticeMenuDeathText, y
		STA PpuData_2007
		INY
		DEX
	BNE -
  RTS
	
	
PracticeMenuDrawAll:
  JSR PracticeMenuWorldDraw
  JSR PracticeMenuDashesDraw
  JSR PracticeMenuMoonsDraw
  JSR PracticeMenuSelectDraw
	JSR PracticeMenuMessagesDraw
  JSR PracticeMenuDeathDraw
  JSR PracticeMenuAbilityDraw
  JMP $8B51
	
	
PracticeMenuAbilitiesChange:
  LDA #$00
  LDX marioAbilityWallJump
  BEQ +
		ORA #$01
	+
  LDX marioAbilityDash
  BEQ +
		ORA #$02
	+
  LDX inventoryItem
  BEQ +
		ORA #$04
	+
  TAX
  TYA ;input
  AND #BTN_Left
  BEQ +
  INX
  CPX #$08
  BNE ++
  LDX #$00
  JMP ++
	+
  TYA ;input
  AND #BTN_Right
  BEQ +++
  DEX
  BPL ++
  LDX #$07
	++
  TXA
  AND #$01
  BEQ +
		LDA #$02
	+
  STA marioAbilityWallJump
  TXA
  AND #$02
  STA marioAbilityDash
  TXA
  AND #$04
  BEQ +
		LDA #$03
	+
  STA inventoryItem
  JSR PracticeMenuAbilityDraw
  LDA #SFX_StompNOI
  STA square1SoundQueue
	+++
  LDX #$00
  RTS

	
PracticeMenuAbilityDraw:
  LDX #$00
  LDA #$22
  STA PpuAddr_2006
  LDA #$97
  STA PpuAddr_2006
  LDA marioAbilityWallJump
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
  LDA marioAbilityDash
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
  LDA marioAbilityWallJump
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
  LDA marioAbilityDash
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
	
	
PracticeMenuSelectChange:
  LDA input
	EOR inputDelayed
	AND input
	TAX
  AND #BTN_Right
  BEQ +
  BNE ++
	+
  TXA
  AND #BTN_Left
  BEQ +
	++
  LDA practiceFlags
  EOR #$08
  STA practiceFlags
  JSR PracticeMenuSelectDraw
  LDA #SFX_StompNOI
  STA square1SoundQueue
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