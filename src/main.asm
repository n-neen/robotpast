
main: {
    jsr colormathhandler
    
    lda !gamestate
    asl
    tax
    jsr (main_statetable,x)
    
    jsr waitfornmi
    
    jmp main
    
    .statetable: {
        dw splashsetup          ;0
        dw splash               ;1
        dw newgame              ;2
        dw gameplayvector       ;3
        dw messageboxsetup      ;4
        dw messagebox           ;5
    }
}

colormathhandler: {
    lda !colormathmode
    asl
    tax
    
    sep #$20
    jsr (colormathhandler_statetable,x)
    rep #$20
    
    rts
    
    .statetable: {
        dw colormathhandler_titlescreen      ;$0
        dw colormathhandler_messagebox       ;$1
    }
    
    .titlescreen: {
        
        lda #%00001001          ;main screen
        sta !mainscreen
        
        lda #%00000110          ;sub screen
        sta !subscreen
        
        lda #%10110111          ;color math layers
        sta !colormathlayers
        
        lda #%00000011          ;enable color math
        sta !colormathenable
        
        rts
    }
    
    .messagebox: {
        
        lda #%00001000          ;main screen
        sta !mainscreen
    
        lda #%00000111          ;sub screen
        sta !subscreen
        
        lda #%10110111          ;color math layers
        sta !colormathlayers
        
        lda #%00000011          ;enable color math
        sta !colormathenable
        
        rts
    }
}


messagebox: {
    
    jsl msg_boxwait
    
    rts
}


messageboxsetup: {
    jsr screenoff
    
    sep #$20
    lda.b #%00000000|(!bg4tilemapshifted<<2)        ;bg4 tilemap = 1x1
    sta $210a
    
    stz !bg4xscroll
    stz !bg4yscroll
    
    rep #$20
    
    lda #$0001
    sta !colormathmode
    
    lda !messageboxindex
    jsl msg_boxwrite
    
    lda !kstatemessagebox
    sta !gamestate
    
    jsr screenon
    
    rts
}


newgame: {
    ;setup for gameplay
    
    ;initialize player
    ;load level
    ;load enemies
    
    lda !gamestate
    sta !returnstate
    
    lda #$0001
    ldx #$0003
    jsl msg_call
    
    ;lda !kstategameplay
    ;sta !gamestate
    
    rts
}


gameplayvector: {
    ;see gameplay.asm
    jsl game_play
    rts
}


splashsetup: {
    jsr screenoff
    
    jsl tilemaptest1            ;load test assets
    jsl tilemaptest2
    jsl tilemaptest3
    jsl tilemaptest4
    
    jsl gfxtest
    jsl gfxtest4
    jsl paltest
    
    stz !colormathmode
    
    jsr waitfornmi
    jsr screenon
    
    stz !scrollmode
    
    lda !kstatenewgame              ;set next state (newgame)
    sta !startbuttondestmode        ;for when start button is pressed
    
    lda !kstatesplash
    sta !gamestate
    
    rts
}

getinput: {
    phx
    php
    
    rep #$30
    
    ;use x for general stores here to preserve A
    lda !controller
    
    .st: {
        bit !kst
        beq ..nost
            ldx !startbuttondestmode
            stx !gamestate
        ..nost:
    }
    
    .sl: {
        bit !ksl
        beq ..nosl
            ;
        ..nosl:
    }
    
    .up: {                                      ;dpad start
        bit !kup
        beq ..noup
            dec !bg1yscroll
            dec !bg1yscroll
            
            dec !bg2yscroll
        ..noup:
    }
    
    .dn: {                                      ;
        bit !kdn
        beq ..nodn
            inc !bg1yscroll
            inc !bg1yscroll
            
            inc !bg2yscroll
        ..nodn:
    }
    
    .lf: {                                      ;
        bit !klf
        beq ..nolf
            ;ldx #!kscrollmodeleft
            ;stx !scrollmode
        ..nolf:
    }
    
    .rt: {                                      ;
        bit !krt
        beq ..nort
            ;ldx #!kscrollmoderight
            ;stx !scrollmode
        ..nort:
    }                                           ;dpad end
    
    .a: {
        bit !ka
        beq ..noa
            ;stz !scrollmode
            ;stz !cameraspeed1
            ;stz !cameraspeed2
            ;stz !cameraspeed3
            ;stz !cameraspeed4
            
            ;stz !camerasubspeed1
            ;stz !camerasubspeed2
            ;stz !camerasubspeed3
            ;stz !camerasubspeed4
        ..noa:
    }
    
    .x: {
        bit !kx
        beq ..nox
            ;
        ..nox:
    }
    
    .b: {
        bit !kb
        beq ..nob
            ;
        ..nob:
    }
    
    .y: {
        bit !ky
        beq ..noy
            ;
        ..noy:
    }
    
    .l: {
        bit !kl
        beq ..nol
            ;jsr speed_down
        ..nol:
    }
    
    .r: {
        bit !kr
        beq ..nor
            ;jsr speed_up
        ..nor:
    }
    
    plp
    plx
    rtl
}

speed: {
    .up: {
        pha
        php
        
        lda !camerasubspeed1
        clc
        adc !kscrollconstant1
        sta !camerasubspeed1
        lda !cameraspeed1
        adc #$0000
        sta !cameraspeed1
        
        lda !camerasubspeed2
        clc
        adc !kscrollconstant2
        sta !camerasubspeed2
        lda !cameraspeed2
        adc #$0000
        sta !cameraspeed2
        
        lda !camerasubspeed3
        clc
        adc !kscrollconstant3
        sta !camerasubspeed3
        lda !cameraspeed3
        adc #$0000
        sta !cameraspeed3
        
        lda !camerasubspeed4
        clc
        adc !kscrollconstant4
        sta !camerasubspeed4
        lda !cameraspeed4
        adc #$0000
        sta !cameraspeed4
        
        plp
        pla
        rts
    }
    
    .down: {
        pha
        php
        
        lda !camerasubspeed1
        sec
        sbc !kscrollconstant1
        sta !camerasubspeed1
        lda !cameraspeed1
        sbc #$0000
        sta !cameraspeed1
        
        lda !camerasubspeed2
        sec
        sbc !kscrollconstant1
        sta !camerasubspeed2
        lda !cameraspeed2
        sbc #$0000
        sta !cameraspeed2
        
        lda !camerasubspeed3
        sec
        sbc !kscrollconstant3
        sta !camerasubspeed3
        lda !cameraspeed3
        sbc #$0000
        sta !cameraspeed3
        
        lda !camerasubspeed4
        sec
        sbc !kscrollconstant4
        sta !camerasubspeed4
        lda !cameraspeed4
        sbc #$0000
        sta !cameraspeed4
        
        plp
        pla
        rts
    }
}


splash: {
    jsl getinput
    
    
    jsr splash_scrollhandle
    jsr cameraspeedclamp
    rts
    
    .scrollhandle: {
        lda !scrollmode
        asl
        tax
        jsr (splash_scrollhandle_table,x)
        
        rts
        
        ..table: {
            dw splash_nonescroll        ;0
            dw splash_scrollleft        ;1
            dw splash_scrollright       ;2
        }
    }
    
    .nonescroll: {
        lda !scrolltimer
        inc
        sta !scrolltimer
        cmp !kscrolltimer
        bmi +
        
        lda #!kscrollmoderight
        sta !scrollmode
        stz !scrolltimer
        
        +
        rts
    }
    
    
    
    .scrollleft: {
        lda !bg1xsubpixel
        clc
        adc !camerasubspeed1
        sta !bg1xsubpixel
        lda !bg1xscroll
        adc !cameraspeed1
        sta !bg1xscroll
        
        lda !bg2xsubpixel
        clc
        adc !camerasubspeed2
        sta !bg2xsubpixel
        lda !bg2xscroll
        adc !cameraspeed2
        sta !bg2xscroll
        
        lda !bg3xsubpixel
        clc
        adc !camerasubspeed3
        sta !bg3xsubpixel
        lda !bg3xscroll
        adc !cameraspeed3
        sta !bg3xscroll
        
        lda !bg4xsubpixel
        clc
        adc !camerasubspeed4
        sta !bg4xsubpixel
        lda !bg4xscroll
        adc !cameraspeed4
        sta !bg4xscroll
        
        rts
    }
    
    .scrollright: {
        lda !scrolltimer
        cmp !kscrollautoaccelmax
        bpl +
        inc
        sta !scrolltimer
        jsr speed_up
        +
        
        lda !bg1xsubpixel       ;bg1 subspeed +constant, carry to bg1 pixel scroll
        sec
        sbc !camerasubspeed1
        sta !bg1xsubpixel
        lda !bg1xscroll
        sbc !cameraspeed1
        sta !bg1xscroll
        
        lda !bg2xsubpixel       ;bg2 subspeed +constant, carry to bg1 pixel scroll
        sec
        sbc !camerasubspeed2
        sta !bg2xsubpixel
        lda !bg2xscroll
        sbc !cameraspeed2
        sta !bg2xscroll
        
        lda !bg3xsubpixel       ;bg3 subspeed +constant, carry to bg1 pixel scroll
        sec
        sbc !camerasubspeed3
        sta !bg3xsubpixel
        lda !bg3xscroll
        sbc !cameraspeed3
        sta !bg3xscroll
        
        lda !bg4xsubpixel       ;bg4 subspeed +constant, carry to bg1 pixel scroll
        sec
        sbc !camerasubspeed4
        sta !bg4xsubpixel
        lda !bg4xscroll
        sbc !cameraspeed4
        sta !bg4xscroll
        
        rts
    }
}

cameraspeedclamp: {
    lda !cameraspeed1
    bmi +
    -
    lda !cameraspeed2
    bmi ++
    --
    lda !cameraspeed3
    bmi +++
    ---
    lda !cameraspeed4
    bmi ++++
    
    rts
    
    +
    stz !cameraspeed1
    bra -
    
    ++
    stz !cameraspeed2
    bra --
    
    +++
    stz !cameraspeed3
    bra ---
    
    ++++
    stz !cameraspeed4
    rts
}


errhandle: {
    rti
}


;===========================================================================================
;===================================                   =====================================
;===================================    N    M    I    =====================================
;===================================                   =====================================
;===========================================================================================


nmi: {
    phb
    pha
    phx
    phy
    
    phk
    plb
    
    sep #$10
    ldx $4210
    ldx !nmiflag
    rep #$10
    beq .lag
    
    ;nmi stuf goez here
    jsr readcontroller
    jsr updatescrolls
    
    lda !messageboxuploadflag
    beq +
    jsl msg_uploadtilemap
    stz !messageboxuploadflag
    +
    
    sep #$20
    lda !screenbrightness
    sta $2100
    rep #$20
    
    stz !nmiflag
    
    .return
    ply
    plx
    pla
    plb
    inc !nmicounter
    rti
    
    .lag
    inc !lagcounter
    bra .return
}

updatescrolls: {
    php
    sep #$20
    
    lda !bg1xscroll
    sta $210d
    lda !bg1xscroll+1
    sta $210d
    
    lda !bg2xscroll
    sta $210f
    lda !bg2xscroll+1
    sta $210f
    
    lda !bg3xscroll
    sta $2111
    lda !bg3xscroll+1
    sta $2111
    
    lda !bg4xscroll
    sta $2113
    lda !bg4xscroll+1
    sta $2113
    
    
    lda !bg1yscroll
    sta $210e
    lda !bg1yscroll+1
    sta $210e
    
    lda !bg2yscroll
    sta $2110
    lda !bg2yscroll+1
    sta $2110
    
    lda !bg3yscroll
    sta $2112
    lda !bg3yscroll+1
    sta $2112
    
    lda !bg4yscroll
    sta $2114
    lda !bg4yscroll+1
    sta $2114
    
    lda !mainscreen
    sta $212c
    
    lda !subscreen
    sta $212d
    
    lda !colormathlayers
    sta $2131
    
    lda !colormathenable
    sta $2130
    
    plp
    rts
}


readcontroller: {
    php
    sep #$20
    lda #$81            ;enable controller read
    sta $4200
    waitforread:
    lda $4212
    bit #$01
    bne waitforread
    rep #$20
    
    lda $4218           ;store to wram
    sta !controller
    plp
    rts
}

controllerarray: {
    .handletimer: {
        lda !controllertimer
        cmp !kcontrollerpressedbuttonsarraylength       ;currently 8
        bpl +
        inc
        sta !controllertimer
        rts
        
        +
        stz !controllertimer
        rts
    }
    
    
    .updatebuttons: {
        lda !controllertimer
        asl
        tax
        
        lda !controller
        sta !controllerpressedbuttonsarray,x
        
        rts
    }
}


waitfornmi: {
    php
    sep #$20
    lda #$01
    sta !nmiflag
    rep #$20
    
    ;lda !showcpuflag
    ;beq +
    ;jsr debug_showcpu
    ;+
    
    .waitloop: {
        lda !nmiflag
    } : bne .waitloop
    plp
    rts
}


screenon: {         ;turn screen brightness on and disable forced blank
    pha
    sep #$20
    lda !screenbrightness
    and #$7f
    ora #$0f
    sta $2100
    sta !screenbrightness
    rep #$20
    pla
    rts
}


screenoff: {        ;enable forced blank
    pha
    sep #$20
    lda !screenbrightness
    ora #$80
    sta $2100
    sta !screenbrightness
    rep #$20
    pla
    rts
}


disablenmi: {
    sep #$20
    stz $4200
    rep #$20
    rts
}


enablenmi: {
    sep #$20
    lda #$80
    sta $4200
    rep #$20
    rts
}



irq: {
    rti
}