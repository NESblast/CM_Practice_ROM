; inputs
BTN_Right          = %00000001
BTN_Left           = %00000010
BTN_Down           = %00000100
BTN_Up             = %00001000
BTN_Start          = %00010000
BTN_Select         = %00100000
BTN_B              = %01000000
BTN_A              = %10000000

PRAC_respawnQuick     = %00000001
PRAC_moonCollect      = %00000010
PRAC_btnSelect        = %00001000
PRAC_messageShow      = %00100000

PRAC_moonsAndMessages = PRAC_moonCollect + PRAC_messageShow


;sound effects constants
;SQ1
SFX_StompSQ				= 22
SFX_SmallOuchSQ			= 21
SFX_BigOuchSQ			= 19
SFX_PauseActivae		= 13
SFX_XRayActivate		= 15
SFX_SpeedBoosterSQ    = 17
SFX_SmallJump         = 12
SFX_Flagpole          = 7
SFX_Fireball          = 11
SFX_PipeDown_Injury   = 10
SFX_EnemySmack        = 9
SFX_EnemyStomp        = 8
SFX_Bump              = 7
SFX_BigJump           = 6
SFX_BombSQ			= 26
SFX_GetDiamondSQ			= 28
SFX_AlertSQ1		= 32

;SQ2
SFX_Alert			= 31
SFX_ZeldaEureka		= 25
SFX_Collectible			= 16
SFX_BowserFall        = 8
SFX_ExtraLife         = 5
SFX_PowerUpGrab       = 4
SFX_Blast             = 3
SFX_GrowVine          = 2
SFX_GrowPowerUp       = 1
SFX_CoinGrab          = 0

;TRI
SFX_Charge = 1

;NOI
SFX_StompNOI			= 23
SFX_BigOuchNOI			= 20
SFX_SpeedBoosterNOI		= 18
SFX_SyncSlot          = 6  ;Controlled by other SFX
SFX_FlapWings         = 5
SFX_GunnerShoot       = 4
SFX_TossProjectile    = 3
SFX_BowserFlame       = 2
SFX_BrickShatter      = 24
SFX_BombNOI			= 27
SFX_GetDiamondNOI			= 29
SFX_CelesteDash			= 30

; menu related consts
Menu_Rows = 8

; Registers
PpuControl_2000 = $2000
PpuMask_2001 = $2001	
PPuStatus_2002 = $2002
OAM_ADDR = $2003 ; fuck
OAM_DATA = $2004 ; these
PpuScroll = $2005
PpuAddr_2006 = $2006
PpuData_2007 = $2007

BANK_SRAM_6000_5113  = $5113 ; Basically **** *BBB where B is the bank number. Here the bank range is 0-3.
BANK_PRG_8000_5114 = $5114
BANK_PRG_A000_5115 = $5115
BANK_PRG_C000_5116 = $5116
BANK_PRG_E000_5117 = $5117

;CHRPort0 = $5120
;CHRPort1 = $5121
;CHRPort2 = $5122
;CHRPort3 = $5123