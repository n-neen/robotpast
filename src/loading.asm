gfxtest: {
    lda.w #!testbankshort
    sta !dmasrcbank
    
    lda.w #$0000
    sta !dmabaseaddr
    
    lda.w #test_gfx
    sta !dmasrcptr
    
    lda.w #$4000
    sta !dmasize
    
    jsl dma_vramtransfur
    rtl
}


gfxtest4: {
    lda.w #!testbankshort
    sta !dmasrcbank
    
    lda.w #!bg4tiles
    sta !dmabaseaddr
    
    lda.w #test_gfx4
    sta !dmasrcptr
    
    lda.w #$1000
    sta !dmasize
    
    jsl dma_vramtransfur
    rtl
}


paltest: {
    php
    sep #$10
    
    ldx.b #$00
    sta !dmabaseaddr
    
    lda.w #test_pal
    sta !dmasrcptr
    
    lda.w #!testbankshort
    sta !dmasrcbank    
    
    lda.w #$0200
    sta !dmasize
    
    jsl dma_cgramtransfur
    
    plp
    rtl
}

tilemaptest1: {                  ;2x2
    lda.w #!testbankshort
    sta !dmasrcbank
    
    lda.w #!bg1tilemap
    sta !dmabaseaddr
    
    lda.w #test_map_1
    sta !dmasrcptr
    
    lda.w #$2000
    sta !dmasize
    
    jsl dma_vramtransfur
    
    rtl
}

tilemaptest2: {                 ;2x2
    lda.w #!testbankshort
    sta !dmasrcbank
    
    lda.w #!bg2tilemap
    sta !dmabaseaddr
    
    lda.w #test_map_2
    sta !dmasrcptr
    
    lda.w #$2000
    sta !dmasize
    
    jsl dma_vramtransfur
    
    rtl
}

tilemaptest3: {                 ;2x2
    lda.w #!testbankshort
    sta !dmasrcbank
    
    lda.w #!bg3tilemap
    sta !dmabaseaddr
    
    lda.w #test_map_3
    sta !dmasrcptr
    
    lda.w #$2000
    sta !dmasize
    
    jsl dma_vramtransfur
    
    rtl
}


tilemaptest4: {                 ;2x1
    lda.w #!testbankshort
    sta !dmasrcbank
    
    lda.w #!bg4tilemap
    sta !dmabaseaddr
    
    lda.w #test_map_4
    sta !dmasrcptr
    
    lda.w #$1000
    sta !dmasize
    
    jsl dma_vramtransfur
    
    rtl
}


;===========================================================================================
;=================================== dma routines ==========================================
;===========================================================================================


dma: {
    .vramtransfur: {        ;for dma channel 0
                                                ;register width (bytes)
        !dma_control            =   $2115       ;1
        !dma_dest_baseaddr      =   $2116       ;2
        !dma_transfur_mode      =   $4300       ;1
        !dma_reg_destination    =   $4301       ;1
        !dma_source_address     =   $4302       ;2
        !dma_bank               =   $4304       ;1
        !dma_transfur_size      =   $4305       ;2
        !dma_enable             =   $430b       ;1
                            ;set to #%00000001 to enable transfer on channel 0
        phx
        phb
        php
        
        phk
        plb
        
        rep #$20
        sep #$10
                                    ;width  register
        ldx.b #$80                  ;1      dma control
        stx $2115
        
        lda !dmabaseaddr            ;2      dest base addr
        sta $2116
        
        ldx #$01                    ;1      transfur mode
        stx $4300
        
        ldx #$18                    ;1      register dest (vram port)
        stx $4301
        
        lda !dmasrcptr              ;2      source addr
        sta $4302
        
        ldx !dmasrcbank             ;1      source bank
        stx $4304
        
        lda !dmasize                ;2      transfur size
        sta $4305
        
        ldx #$01                    ;1      enable transfur on dma channel 0
        stx $420b
        
        plp
        plb
        plx
        rtl
    }
    
    .cgramtransfur: {
        phx
        phb
        php
        
        phk
        plb
        
        rep #$20
        sep #$10                    ;width  register
        
        ldx.b !dmabaseaddr          ;1      cgadd
        stx $2121
        
        ldx #$02                    ;1      transfur mode: write twice
        stx $4300
        
        ldx #$22                    ;1      register dest (cgram write)
        stx $4301
        
        lda !dmasrcptr              ;2      source addr
        sta $4302
        
        ldx !dmasrcbank             ;1      source bank
        stx $4304
        
        lda !dmasize                ;2      transfur size
        sta $4305
        
        ldx #$01                    ;1      enable transfur on dma channel 0
        stx $420b
        
        plp
        plb
        plx
        rtl
    }
    
    .clearvram: {
        phx
        phb
        php
        
        phk
        plb        
        
        rep #$20
        sep #$10                    ;width  register
        
        ldx.b #$80                  ;1      dma control
        stx $2115
        
        lda #$0000                  ;2      dest base addr
        sta $2116
        
        ldx #%00011001              ;1      transfur mode
        stx $4300
        
        ldx #$18                    ;1      register dest (vram port)
        stx $4301
        
        lda #..fillword             ;2      source addr
        sta $4302
        
        lda #$fffe                  ;2      transfur size
        sta $4305
        
        ldx.b #!dmabankshort        ;1      source bank
        stx $4304
        
        ldx #$01                    ;1      enable transfur on dma channel 0    
        stx $420b
        
        plp
        plb
        plx
        rtl    
        ..fillword: {
            dw $0000
        }
    }
    
    
    .clearcgram: {
        phx
        phb
        php
        
        phk
        plb
        
        rep #$20
        sep #$10                    ;width  register
        
        ldx.b #$00                  ;1      cgadd
        stx $2121

        ldx #%00011001              ;1      transfur mode: write twice
        stx $4300
        
        ldx #$22                    ;1      register dest (cgram write)
        stx $4301
        
        lda.w #..fillword           ;2      source addr
        sta $4302
        
        ldx.b #!dmabankshort        ;1      source bank
        stx $4304
        
        lda #$0400                  ;2      transfur size
        sta $4305
        
        ldx #$01                    ;1      enable transfur on dma channel 0
        stx $420b
        
        plp
        plb
        plx
        rtl  
        
        ..fillword: {
            dw $3800
        }
    }
}