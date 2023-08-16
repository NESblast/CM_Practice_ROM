; NES Ram Vars
.BANK 0 SLOT "RAM_NES"

.ORG $00E	PlayerState:	          ;If this value is equal to 8, the player can control Mario.
.ORG $020	AirborneState:	        ;0 = standing on ground, 1 = jumping, 2 = falling

.ORG $E2    Input:
.ORG $E3    DelayedInput:

.ORG $050	XSpeed:	                ;The horizontal speed that Mario is trying to go. This does not account for any external speed changes (moving platforms, slopes, etc.)
.ORG $08F	YSpeed:	                ;The vertical speed that Mario is trying to go, positive down.
.ORG $065	XPage:	                ;The horizontal screen page that Mario is currently on.
.ORG $07A	XPixel:	                ;The horizontal pixel that Mario is at.
.ORG $0B9	YPixel:	                ;The vertical pixel that Mario is at. Higher value = lower on the screen.

.16BIT
.ORG $3C0	XSubspeed:	            ;Essentially Mario’s acceleration value. When it is high, he will accelerate quicker, and when it is low, he will decelerate quicker.
.ORG $3EB	YSubspeed:	            ;Mario’s vertical acceleration.
.ORG $3C1	XSubpixel:	            ;The horizontal subpixel that Mario is at. Though there is no visible difference, a higher value means further to the right.
.ORG $3D6	YSubpixel:              ;Mario’s vertical subpixel

.ORG $4BD   IsInMap:

.ORG $52B	SpeedBoostBonus:	      ;If this value is 16, then speed boost is active
.ORG $52C	SpeedBoostTimer:	      ;In order for the speed boost to activate, this timer must count up to 96.
.ORG $545	DashTimer:              ;A dash will last until this timer is complete
.ORG $546	DashReadyTimer:	        ;When a dash is initiated, the game will freeze until this timer is complete.

.ORG $57F   WorldNumber:

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

.ORG $7FC   WarpWorldLast:
.ORG $7FD   WarpIDLast:

.ORG $7804 Square1SoundQueue