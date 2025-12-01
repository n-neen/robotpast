
boot: {
    sei
    clc
    xce             ;enable native mode
    jml setbank     ;set bank
    setbank:
    
    sep #$20
    lda #$01
    sta $420d       ;enable fastrom
    rep #$30
    
    ldx #$1fff
    txs             ;set initial stack pointer
    lda #$0000
    tcd             ;clear dp register
    
    ldy #$0000      ;lmaoooo
    ldx #$0000
    
    
    ;fall through
}

init: {

    .clear7e: {
        pea $7e7e
        plb : plb
        
        ldx #$1ffe
        
        -
        stz $0000,x
        stz $1000,x
        stz $2000,x
        stz $3000,x
        stz $4000,x
        stz $5000,x
        stz $6000,x
        stz $7000,x
        stz $8000,x
        stz $9000,x
        stz $a000,x
        stz $b000,x
        stz $c000,x
        stz $d000,x
        stz $e000,x
        stz $f000,x
        stz $8000,x
        
        dex : dex
        bpl -
    }

    .clear7f: {
        pea $7f7f
        plb : plb
        
        ldx #$1ffe
        
        -
        stz $0000,x
        stz $1000,x
        stz $2000,x
        stz $3000,x
        stz $4000,x
        stz $5000,x
        stz $6000,x
        stz $7000,x
        stz $8000,x
        stz $9000,x
        stz $a000,x
        stz $b000,x
        stz $c000,x
        stz $d000,x
        stz $e000,x
        stz $f000,x
        stz $8000,x
        
        dex : dex
        bpl -
    }
    
    .registers: {
        
        phk
        plb                 ;set db
        
        sep #$30
        lda #$8f
        sta $2100           ;enable forced blank
        lda #$01
        sta $4200           ;enable joypad autoread
        rep #$30
        
        
        ldx #$000a
-       stz $4200,x         ;clear registers $4200-$420b
        dex : dex
        bne - 
        
        ldx #$0082          ;clear registers $2101-2183
--      stz $2101,x
        dex : dex
        bne --
        
        sep #$20
        
        lda #$80            ;enable nmi
        sta $4200
        
        sta !screenbrightness
        sta $2100
        
        rep #$20
    }
    
    jsr screenoff
    
    .vram: {   
        ;clear vram
        jsl dma_clearvram
        jsl dma_clearcgram
        
        sep #$20
        lda #$ff
        sta !bg1xscroll
        sta !bg1xscroll
        sta !bg2xscroll
        sta !bg2xscroll
        sta !bg3xscroll
        sta !bg3xscroll
        
        sta !bg1yscroll
        sta !bg1yscroll
        sta !bg2yscroll
        sta !bg2yscroll
        sta !bg3yscroll
        sta !bg3yscroll
        
        stz !bg4yscroll
        stz !bg4xscroll
        rep #$20
        
        
    }
    
    .ppu: {
        ;todo:
        
        ;set layer base tilemap and tiles via
        
            ;$2107  bg1 tilemap
            ;$2108  bg2
            ;$2109  bg3
            ;$210a  bg4
            
            ;$210b  bg1/2 tiles
            ;$210c  bg3/4 tiles
            
        sep #$20
        
        ;tile layer graphics base addresses
        
        lda.b #!bg1tileshifted|(!bg2tileshifted<<4)
        sta $210b
        
        lda.b #!bg3tileshifted|(!bg4tileshifted<<4)
        sta $210c
        
        ;tilemap base addresses
        
        lda.b #%00000011|(!bg1tilemapshifted<<2)
        sta $2107
        
        lda.b #%00000011|(!bg2tilemapshifted<<2)
        sta $2108
        
        lda.b #%00000011|(!bg3tilemapshifted<<2)
        sta $2109
        
        lda.b #%00000001|(!bg4tilemapshifted<<2)
        sta $210a
        
        lda.b #%00001111
        sta $212c
        
        rep #$20
    }
    
    stz $2105               ;drawing mode = 0
    
    stz !gamestate
    
    jsr enablenmi
    jsr waitfornmi
    jsr screenon
    
    ;fall through to main
}
