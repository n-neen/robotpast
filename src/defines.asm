;defines

!gamestate          = $40
!nmiflag            = $42
!nmicounter         = $44
!lagcounter         = $46
!screenbrightness   = $48
!controller         = $4a

!controllertimer                = $5e
!controllerpressedbuttonsarray  = $60
;length is !kcontrollerpressedbuttonsarraylength*2 (see constants in this file)

!dmaargstart    =                   $80                     ;start of dma arguments
!dmasrcptr      =                   !dmaargstart+0          ;2
!dmasrcbank     =                   !dmaargstart+2          ;2
!dmabankshort   #=                  !dmasrcbank>>8
!dmasize        =                   !dmaargstart+4          ;2
!dmabaseaddr    =                   !dmaargstart+6          ;2
!dmaloadindex   =                   !dmaargstart+8          ;2


!scrollstart        =       $a0

!bg1xscroll         =       !scrollstart+0
!bg2xscroll         =       !scrollstart+2
!bg3xscroll         =       !scrollstart+4
!bg4xscroll         =       !scrollstart+6

!bg1yscroll         =       !scrollstart+8
!bg2yscroll         =       !scrollstart+10
!bg3yscroll         =       !scrollstart+12
!bg4yscroll         =       !scrollstart+14

!bg1xsubpixel       =       !scrollstart+16
!bg2xsubpixel       =       !scrollstart+18
!bg3xsubpixel       =       !scrollstart+20
!bg4xsubpixel       =       !scrollstart+22

!bg1ysubpixel       =       !scrollstart+24
!bg2ysubpixel       =       !scrollstart+26
!bg3ysubpixel       =       !scrollstart+28
!bg4ysubpixel       =       !scrollstart+30

!scrollmode         =       !scrollstart+32

!camerasubspeed1    =       !scrollstart+34
!camerasubspeed2    =       !scrollstart+36
!camerasubspeed3    =       !scrollstart+38
!camerasubspeed4    =       !scrollstart+40

!cameraspeed1       =       !scrollstart+42
!cameraspeed2       =       !scrollstart+44
!cameraspeed3       =       !scrollstart+46
!cameraspeed4       =       !scrollstart+48

!scrolltimer        =       !scrollstart+50 ;timer for how long to wait on title before autoscroll

;===========================================================================================
;======================================== constants ========================================
;===========================================================================================

;constants for module banks

!testbankshort       =      (test&$7f0000)>>16

;game states

!kstatesplashsetup      =       #$0000
!kstatesplash           =       #$0001
!kstatenewgame          =       #$0002
!kstategameplay         =       #$0003

!kcontrollerpressedbuttonsarraylength       = #$0008


;scroll modes
!kscrollmodeleft        =       $0001
!kscrollmoderight       =       $0002

;scroll speed constants
!kscrollconstant1       =       #$0100/4
!kscrollconstant2       =       #$0080/4
!kscrollconstant3       =       #$0020/3
!kscrollconstant4       =       #$0002/2

!kscrollautoaccelmax    =       #$0300  ;how long to accelerate (frames)
!kscrolltimer           =       #$0380  ;how long to wait before accelerating

;vram constants
;before shifting into the format needed to actually use
;with the ppu registers

!bg1tiles           =       $0000
!bg2tiles           =       $0000
!bg3tiles           =       $0000
!bg4tiles           =       $2000

!bg1tilemap         =       $3000
!bg2tilemap         =       $4000
!bg3tilemap         =       $5000
!bg4tilemap         =       $2800

!spritegfx          =       $6000


;shifted for ppu register use:

!bg1tileshifted     =       !bg1tiles>>12
!bg2tileshifted     =       !bg2tiles>>12
!bg3tileshifted     =       !bg3tiles>>12
!bg4tileshifted     =       !bg4tiles>>12

!bg1tilemapshifted  =       !bg1tilemap>>10
!bg2tilemapshifted  =       !bg2tilemap>>10
!bg3tilemapshifted  =       !bg3tilemap>>10
!bg4tilemapshifted  =       !bg4tilemap>>10

!spritegfxshifted   =       !spritegfx>>12


;controller bit constants
!kb                         =       #$8000
!ky                         =       #$4000
!ksl                        =       #$2000
!kst                        =       #$1000
!kup                        =       #$0800
!kdn                        =       #$0400
!klf                        =       #$0200
!krt                        =       #$0100
!ka                         =       #$0080
!kx                         =       #$0040
!kl                         =       #$0020
!kr                         =       #$0010
