; Graphics Replacements

.BANK $26 SLOT "$8000"


.ORG $0000
.INCBIN "chr\mapCoors.chr"


.ORG $0800
.INCBIN "chr\fontRiYAN.chr"


; Oi one stray pixel are yeh? ya bloodie kitten me?!
.ORG $1653
.DB $00


.ORG $1600
.INCBIN "chr\hudIcons.chr"


.ORG $1800
.INCBIN "chr\mapHeader.chr"


.BANK $27 SLOT "$8000"


.ORG $0800
.INCBIN "chr\icons.chr"


.ORG $1000
.INCBIN "chr\input.chr"