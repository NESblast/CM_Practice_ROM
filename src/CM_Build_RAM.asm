; NES Ram Vars
.BANK 0 SLOT "RAM_NES"


var0 = $00
addr_temp = $00
var1 = $01
var2 = $02
roomID_temp = $02
var3 = $03
addr03_temp = $03
var4 = $04
var5 = $05
var6 = $06
var7 = $07
addr0A_temp = $0A


marioControllable = $0E		          ;If this value is equal to 8, the player can control Mario.
marioAirborne	 = $20	        ;0 = standing on ground, 1 = jumping, 2 = falling

mapCursorX = $46
mapCursorY = $47

marioSpeedX = $50	                ;The horizontal speed that Mario is trying to go. This does not account for any external speed changes (moving platforms, slopes, etc.)

marioPageX = $65	                ;The horizontal screen page that Mario is currently on.
marioPixelX = $7A		                ;The horizontal pixel that Mario is at.
marioSpeedY = $8F	                ;The vertical speed that Mario is trying to go, positive down.
marioPixelY = $B9		                ;The vertical pixel that Mario is at. Higher value = lower on the screen.
input = $E2    
inputDelayed = $E3    

minimapOffset = $0119 ;Calculated by the minimap updater

mapCursorPosY = $0230
mapCursorPosX = $0233

marioAccelX = $03C0	            ;Essentially Mario’s acceleration value. When it is high, he will accelerate quicker, and when it is low, he will decelerate quicker.
marioAccelY	 = $03EB	            ;Mario’s vertical acceleration.
marioSubpixelX	 = $03C1	            ;The horizontal subpixel that Mario is at. Though there is no visible difference, a higher value means further to the right.
marioSubpixelY = $03D6	              ;Mario’s vertical subpixel

mapIsIn = $04BD 

deathTimer = $04C2  

marioSpeedBoostBonus = $052B	      ;If this value is 16, then speed boost is active
marioSpeedBoostTimer = $052C		      ;In order for the speed boost to activate, this timer must count up to 96.
marioDashTimer  = $0545	             ;A dash will last until this timer is complete
marioDashReadyTimer = $0546	        ;When a dash is initiated, the game will freeze until this timer is complete.

worldNumber = $057F   

marioGrounded = $070C		        ;A moon will not be counted until Mario is on solid ground. If this is equal to 1, Mario can collect a moon.
marioDreamBlock = $070F		      ;7D = inside dream block, 7E = exiting dream block

PPUMaskVar = $0743
roomID = $074D   
roomIDTemp = $074E   
spawnTypeUsed = $0751   
spawnXHigh = $0753   
spawnX = $0758   
spawnYHigh = $0759   
spawnY = $075A   
roomOffset = $075B   
spawnType = $075C   

wallJumpLeniencyTimer = $079C	  ;If the timer is at 2 or higher, Mario can wall jump.
wallKickTimer = $079D		        ;After a wall kick, Mario will be forced away from the wall until this timer is complete

isOnMapMenu = $07FA
worldNumber_temp = $07FB
warpWorldLast = $07FC
warpIDLast = $07FD

coldBootOffset = <$07FE ;Constant
compatibilityID	= $07FF ;0=all compatible, 1=ExRAM not supported, 2=joypad reading not compatible

PPUIORoutine = $1C07 ;If non-zero and in cutscene, IRQ type is altered.
PPUIOStep = $1C08 ;Coefficient, usually downcounting


; Cartridge Ram Vars
.BANK 0 SLOT "RAM_CART"

practiceMenuScreenSet = $6EFE
practiceMenuScreenDrawn = $6EFF

practiceMenuScreenAt = $6F7E
practiceMenuCursorPos = $6F7F

practiceFlags = $6FFD
practiceMenuChecksum_hi = $6FFE
practiceMenuChecksum_lo = $6FFF

attributeMap = $7600 ;Attribute (palette) map
areaParserBuffer_Offset = $7700
areaParserMetatileBuffer = $7701 ;This would replace the usual metatile buffer for the area parser.

practiceMenuInitialized = $77EC
spawnTilePrint = $77ED
frameTimer_hi	= $77EE
frameTimer_lo	= $77EF

musicQueue = $7803
square1SoundQueue = $7804

minimapFlags = $7A00
minimapTiles = $7B00

mapDrawFlags = $7C07
mapDrawRowCounter = $7C08

maxDashesCount = $7F03

coinCount_hi = $7F06
coinCount_lo = $7F07
moonCount = $7F0E
spawnSwitchStatus = $7F16
marioAbilityXray = $7F23
marioAbilityDash = $7F2A
marioAbilityWallJump = $7F2F
inventoryItem = $7FFA
