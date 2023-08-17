; NES Ram Vars
.BANK 0 SLOT "RAM_NES"

PlayerState = $00E		          ;If this value is equal to 8, the player can control Mario.
AirborneState	 = $020	        ;0 = standing on ground, 1 = jumping, 2 = falling

Input = $E2    
DelayedInput = $E3    

XSpeed = $050	                ;The horizontal speed that Mario is trying to go. This does not account for any external speed changes (moving platforms, slopes, etc.)
YSpeed = $08F	                ;The vertical speed that Mario is trying to go, positive down.
XPage = $065	                ;The horizontal screen page that Mario is currently on.
XPixel = $07A		                ;The horizontal pixel that Mario is at.
YPixel = $0B9		                ;The vertical pixel that Mario is at. Higher value = lower on the screen.

XSubspeed = $3C0	            ;Essentially Mario’s acceleration value. When it is high, he will accelerate quicker, and when it is low, he will decelerate quicker.
YSubspeed	 = $3EB	            ;Mario’s vertical acceleration.
XSubpixel	 = $3C1	            ;The horizontal subpixel that Mario is at. Though there is no visible difference, a higher value means further to the right.
YSubpixel = $3D6	              ;Mario’s vertical subpixel

IsInMap = $4BD   

SpeedBoostBonus	 = $52B	      ;If this value is 16, then speed boost is active
SpeedBoostTimer = $52C		      ;In order for the speed boost to activate, this timer must count up to 96.
DashTimer  = $545	             ;A dash will last until this timer is complete
DashReadyTimer = $546	        ;When a dash is initiated, the game will freeze until this timer is complete.

WorldNumber = $57F   

GroundedStatus = $70C		        ;A moon will not be counted until Mario is on solid ground. If this is equal to 1, Mario can collect a moon.
DreamBlockStatus = $70F		      ;7D = inside dream block, 7E = exiting dream block

RoomID = $74D   
RoomIDTemp = $74E   
SpawnTypeUsed = $751   
SpawnXHigh = $753   
SpawnX = $758   
SpawnYHigh = $759   
SpawnY = $75A   
RoomOffset = $75B   
SpawnType = $75C   

WallJumpLeniencyTimer = $79C	  ;If the timer is at 2 or higher, Mario can wall jump.
WallKickTimer = $79D		        ;After a wall kick, Mario will be forced away from the wall until this timer is complete

IsOnMapMenu = $07FA
WarpWorldLast = $7FC
WarpIDLast = $7FD
MenuSelector = $07F9

; Cartridge Ram Vars
.BANK 0 SLOT "RAM_CART"

Square1SoundQueue = $1804

