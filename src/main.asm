
main: {
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
    }
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
    
    sep #$20
    {
        lda #%00001001          ;main screen
        sta $212c
        
        lda #%00000110          ;sub screen
        sta $212d
        
        lda #%10110111          ;color math layers
        sta $2131
        
        lda #%00000011
        sta $2130
    }
    rep #$20
    
    jsr screenon
    
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
            ;jsr game_pause
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
            ;
        ..noup:
    }
    
    .dn: {                                      ;
        bit !kdn
        beq ..nodn
            ;
        ..nodn:
    }
    
    .lf: {                                      ;
        bit !klf
        beq ..nolf
            ldx #!kscrollmodeleft
            stx !scrollmode
        ..nolf:
    }
    
    .rt: {                                      ;
        bit !krt
        beq ..nort
            ldx #!kscrollmoderight
            stx !scrollmode
        ..nort:
    }                                           ;dpad end
    
    .a: {
        bit !ka
        beq ..noa
            stz !scrollmode
            stz !cameraspeed1
            stz !cameraspeed2
            stz !cameraspeed3
            stz !cameraspeed4
            
            stz !camerasubspeed1
            stz !camerasubspeed2
            stz !camerasubspeed3
            stz !camerasubspeed4
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
            jsr speed_down
        ..nol:
    }
    
    .r: {
        bit !kr
        beq ..nor
            jsr speed_up
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
        adc #$0200
        sta !camerasubspeed1
        lda !cameraspeed1
        adc #$0000
        sta !cameraspeed1
        
        lda !camerasubspeed2
        clc
        adc #$0100
        sta !camerasubspeed2
        lda !cameraspeed2
        adc #$0000
        sta !cameraspeed2
        
        lda !camerasubspeed3
        clc
        adc #$0020
        sta !camerasubspeed3
        lda !cameraspeed3
        adc #$0000
        sta !cameraspeed3
        
        lda !camerasubspeed4
        clc
        adc #$0004
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
        sbc #$0200
        sta !camerasubspeed1
        lda !cameraspeed1
        sbc #$0000
        sta !cameraspeed1
        
        lda !camerasubspeed2
        sec
        sbc #$0100
        sta !camerasubspeed2
        lda !cameraspeed2
        sbc #$0000
        sta !cameraspeed2
        
        lda !camerasubspeed3
        sec
        sbc #$0020
        sta !camerasubspeed3
        lda !cameraspeed3
        sbc #$0000
        sta !cameraspeed3
        
        lda !camerasubspeed4
        sec
        sbc #$0004
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
        lda !bg1xsubpixel
        sec
        sbc !camerasubspeed1
        sta !bg1xsubpixel
        lda !bg1xscroll
        sbc !cameraspeed1
        sta !bg1xscroll
        
        lda !bg2xsubpixel
        sec
        sbc !camerasubspeed2
        sta !bg2xsubpixel
        lda !bg2xscroll
        sbc !cameraspeed2
        sta !bg2xscroll
        
        lda !bg3xsubpixel
        sec
        sbc !camerasubspeed3
        sta !bg3xsubpixel
        lda !bg3xscroll
        sbc !cameraspeed3
        sta !bg3xscroll
        
        lda !bg4xsubpixel
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


newgame: {
    ;setup for gameplay
    rts
}


gameplayvector: {
    ;jsl gameplay
    ;in another module
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