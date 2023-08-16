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
.16BIT
.BACKGROUND "CM_1_0_noheader.nes"

.INCLUDE "NES_labels.asm"
.INCLUDE "src\ram_labels.asm"

; Cartridge Ram Vars
.BANK 0 SLOT "RAM_CART"

.ORG $10 aRamValueCart:

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
    JMP $1fff

.ORG $1F20

InputViewer:
    LDA #$80
    STA PpuControl_2000
    LDX #$20
    LDY #$03
    LDA #$08
    JSR InputPPUWrite
    LDY #$04
    LDA #$40
    JSR InputPPUWrite
    LDY #$05
    LDA #$80
    JSR InputPPUWrite
    LDY #$22
    LDA #$02
    JSR InputPPUWrite
    LDY #$23
    LDA #$04
    JSR InputPPUWrite
    LDY #$24
    LDA #$01
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

.ORG $1FBB
SelectWarp:
    LDY #$00
    LDA SpawnTypeUsed
    BNE InputPPUWrite
    LDA WarpWorldLast
    BEQ InputPPUWrite
    STA WorldNumber
    INC IsInMap
    LDA WarpIDLast
    STA $02
    JMP MapWarp
    RTS
