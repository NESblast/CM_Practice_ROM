; NES Ram Vars
.BANK 0 SLOT "RAM_NES"

Temp_Var1 = $00
TempAddr = $00
Temp_Var2 = $01
Temp_Var3 = $02
TempRoomID = $02
Temp_Var4 = $03
Temp_Var5 = $04
Temp_Var6 = $05
Temp_Var7 = $06
Temp_Var8 = $07


PlayerState = $0E		          ;If this value is equal to 8, the player can control Mario.
AirborneState	 = $20	        ;0 = standing on ground, 1 = jumping, 2 = falling

MapCursorX = $46
MapCursorY = $47

XSpeed = $50	                ;The horizontal speed that Mario is trying to go. This does not account for any external speed changes (moving platforms, slopes, etc.)

XPage = $65	                ;The horizontal screen page that Mario is currently on.
XPixel = $7A		                ;The horizontal pixel that Mario is at.
YSpeed = $8F	                ;The vertical speed that Mario is trying to go, positive down.
YPixel = $B9		                ;The vertical pixel that Mario is at. Higher value = lower on the screen.
Input = $E2    
DelayedInput = $E3    

MinimapOffset = $0119 ;Calculated by the minimap updater

XSubspeed = $03C0	            ;Essentially Mario’s acceleration value. When it is high, he will accelerate quicker, and when it is low, he will decelerate quicker.
YSubspeed	 = $03EB	            ;Mario’s vertical acceleration.
XSubpixel	 = $03C1	            ;The horizontal subpixel that Mario is at. Though there is no visible difference, a higher value means further to the right.
YSubpixel = $03D6	              ;Mario’s vertical subpixel

IsInMap = $04BD   

SpeedBoostBonus	 = $052B	      ;If this value is 16, then speed boost is active
SpeedBoostTimer = $052C		      ;In order for the speed boost to activate, this timer must count up to 96.
DashTimer  = $0545	             ;A dash will last until this timer is complete
DashReadyTimer = $0546	        ;When a dash is initiated, the game will freeze until this timer is complete.

WorldNumber = $057F   

GroundedStatus = $070C		        ;A moon will not be counted until Mario is on solid ground. If this is equal to 1, Mario can collect a moon.
DreamBlockStatus = $070F		      ;7D = inside dream block, 7E = exiting dream block

PPUMaskVar = $0743
RoomID = $074D   
RoomIDTemp = $074E   
SpawnTypeUsed = $0751   
SpawnXHigh = $0753   
SpawnX = $0758   
SpawnYHigh = $0759   
SpawnY = $075A   
RoomOffset = $075B   
SpawnType = $075C   

WallJumpLeniencyTimer = $079C	  ;If the timer is at 2 or higher, Mario can wall jump.
WallKickTimer = $079D		        ;After a wall kick, Mario will be forced away from the wall until this timer is complete

PracticeFlags = $07F8
MenuSelector = $07F9
IsOnMapMenu = $07FA
TempWorldNumber = $07FB
WarpWorldLast = $07FC
WarpIDLast = $07FD

ColdBootOffset = <$07FE ;Constant
CompatibilityID	= $07FF ;0=all compatible, 1=ExRAM not supported, 2=joypad reading not compatible

PPUIORoutine = $1C07 ;If non-zero and in cutscene, IRQ type is altered.
PPUIOStep = $1C08 ;Coefficient, usually downcounting

; Cartridge Ram Vars
.BANK 0 SLOT "RAM_CART"

Square1SoundQueue = $7804

MinimapFlags = $7A00
MinimapTiles = $7B00

MaxDashesCount = $7F03
SpawnSwitchStatus = $7F16