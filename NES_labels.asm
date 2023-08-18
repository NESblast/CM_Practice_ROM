; Registers
PpuControl_2000 = $2000
PPU_MASK = $2001	
PPU_STATUS = $2002
OAM_ADDR = $2003
OAM_DATA = $2004
PPU_SCROLL = $2005
PpuAddr_2006 = $2006
PpuData_2007 = $2007

SQUARE0_R0 = $4000
SQUARE0_R1 = $4001
SQUARE0_R2 = $4002
SQUARE0_R3 = $4003

SQUARE1_R0 = $4004
SQUARE1_R1 = $4005
SQUARE1_R2 = $4006
SQUARE1_R3 = $4007

TRIANGLE_R0 = $4008
;TRIANGLE_R1 = $4009 ; unused
TRIANGLE_R2 = $400A
TRIANGLE_R3 = $400B

NOISE_R0 = $400C
;NOISE_R1 = $400D ; unused
NOISE_R2 = $400E
NOISE_R3 = $400F

OAM_DMA = $4014
APU_CTRL = $4015
P1_PORT =	$4016
P2_PORT = $4017

;---IMPORTANT MAPPER-RELATED REGS---
;PRGMode  = $5100
;CHRMode  = $5101 ;Just init these on startup.
;RAMProtect1 = $5102 ;Init value = #$2
;RAMProtect2 = $5103 ;Init value = #$1

MMC5ExtendedRAMMode = $5104 ;0: Nametable; 1: Attribute; 2: Extra RAM
MMC5Mirroring = $5105
MMC5FillModeTile = $5106
MMC5FillModeColour = $5107

RAMPort  = $5113 ; Basically **** *BBB where B is the bank number. Here the bank range is 0-3.
PRGPort0 = $5114
PRGPort1 = $5115
PRGPort2 = $5116
PRGPort3 = $5117

CHRPort0 = $5120
CHRPort1 = $5121
CHRPort2 = $5122
CHRPort3 = $5123
;NOTE HERE: Originally, the game was meant to use VRC7 thus there are only 8 CHR banks.
;However MMC5 has 8 for sprites and 4 for BG. Here, CHRPort4-CHRPort7 still mean the BG banks, but SPCHRPort4-SPCHRPort7 mean the additional sprite banks.
CHRPort4 = $5128
CHRPort5 = $5129
CHRPort6 = $512A
CHRPort7 = $512B
BGCHRPort0 = $5128
BGCHRPort1 = $5129
BGCHRPort2 = $512A
BGCHRPort3 = $512B

SPCHRPort0 = $5120
SPCHRPort1 = $5121
SPCHRPort2 = $5122
SPCHRPort3 = $5123
SPCHRPort4 = $5124
SPCHRPort5 = $5125
SPCHRPort6 = $5126
SPCHRPort7 = $5127

CHRUpperBank = $5128

IRQCounter = $5203 ; All 8 bits specify the scanline
IRQLatch = $5203   ; NOTE: This name is PREFERRED over the name IRQCounter, due to another variable named IRQCount
IRQStatus = $5204  ; Write: High bit = enable; Read: Acknowledge

MMC5Multiplier1 = $5205
MMC5Multiplier2 = $5206

AreaParser_MetatileBuffer = $7701 ;This would replace the usual metatile buffer for the area parser.
APBuffer_Offset = $7700
AttributeMap = $7600 ;Attribute (palette) map