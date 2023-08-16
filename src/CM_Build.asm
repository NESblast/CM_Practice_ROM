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

; NES Ram Vars
.BANK 0 SLOT "RAM_NES"

.ORG $00E	PlayerState:	          ;If this value is equal to 8, the player can control Mario.
.ORG $020	AirborneState:	        ;0 = standing on ground, 1 = jumping, 2 = falling

.ORG $E2   Input:
.ORG $E3   DelayedInput:

.ORG $050	XSpeed:	                ;The horizontal speed that Mario is trying to go. This does not account for any external speed changes (moving platforms, slopes, etc.)
.ORG $08F	YSpeed:	                ;The vertical speed that Mario is trying to go, positive down.
.ORG $3C0	XSubspeed:	            ;Essentially Mario’s acceleration value. When it is high, he will accelerate quicker, and when it is low, he will decelerate quicker.
.ORG $3EB	YSubspeed:	            ;Mario’s vertical acceleration.
.ORG $065	XPage:	                ;The horizontal screen page that Mario is currently on.
.ORG $07A	XPixel:	                ;The horizontal pixel that Mario is at.
.ORG $0B9	YPixel:	                ;The vertical pixel that Mario is at. Higher value = lower on the screen.
.ORG $3C1	XSubpixel:	            ;The horizontal subpixel that Mario is at. Though there is no visible difference, a higher value means further to the right.
.ORG $3D6	YSubpixel:              ;Mario’s vertical subpixel

.ORG $52B	SpeedBoostBonus:	      ;If this value is 16, then speed boost is active
.ORG $52C	SpeedBoostTimer:	      ;In order for the speed boost to activate, this timer must count up to 96.
.ORG $545	DashTimer:              ;A dash will last until this timer is complete
.ORG $546	DashReadyTimer:	        ;When a dash is initiated, the game will freeze until this timer is complete.

.ORG $70C	GroundedStatus:	        ;A moon will not be counted until Mario is on solid ground. If this is equal to 1, Mario can collect a moon.
.ORG $70F	DreamBlockStatus:	      ;7D = inside dream block, 7E = exiting dream block

.ORG $74D   RoomID:
.ORG $74E   RoomIDTemp:
.ORG $751   SpawnTypeUsed:
.ORG $753   SpawnXHigh:
.ORG $758   SpawnX:
.ORG $759   SpawnYHigh:
.ORG $75A   SpawnY:
.ORG $75B   RoomOffset:
.ORG $75C   SpawnType:

.ORG $79C	WallJumpLeniencyTimer:  ;If the timer is at 2 or higher, Mario can wall jump.
.ORG $79D	WallKickTimer:	        ;After a wall kick, Mario will be forced away from the wall until this timer is complete

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



