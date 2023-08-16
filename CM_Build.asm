.MEMORYMAP 
SLOTSIZE   $2000
DEFAULTSLOT   0
SLOT 0      $8000   "$8000"
SLOT 1      $A000   "$A000"
SLOT 2      $C000
SLOT 3      $E000
SLOT 4 			$0000		"RAM_NES"
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
.BANK $00 SLOT "RAM_NES"

.ORG $10 aRamValueNES:


; Cartridge Ram Vars
.BANK $00 SLOT "RAM_CART"

.ORG $10 aRamValueCart:


.BANK $02 SLOT 1
.ORG $1F00

aLabel:
  LDA aRamValueNES
  STA $4100
  RTS
	
	
.BANK 4 SLOT 1
.ORG $1F00

aLabel2:
  LDA aRamValueNES
  STA $4100
	
  RTS
	
	
.BANK 6 SLOT 3

aLabel3456:

.DB "Hello, is it me you're looking for"


; Title Screen Version
.BANK $1D SLOT "$A000"
.ORG $020B
.db "PRACTICE ROM V1.03         "
