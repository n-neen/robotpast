msg: {
    
    
    .call: {
        ;high level messagebox routine
        ;call from gameplay, or from within a script
        
        ;argument: a = message box index
        ;          x = starting row
        
        sta !messageboxindex
        
        txa
        asl #5
        sta !messageboxstartingposition
        
        ;scroll screen?
        
        jsr msg_setup
        jsr msg_wait
        jsl msg_clear
        
        rtl
    }
    
    
    .setup: {
        jsl waitfornmi_long
        jsl screenoff_long
        
        sep #$20
        {
            ;lda.b #%00000000|(!bg4tilemapshifted<<2)        ;bg4 tilemap = 1x1
            ;sta $210a
            
            lda #%00001000          ;main screen
            sta !mainscreen
            sta $212c
        
            lda #%00000111          ;sub screen
            sta !subscreen
            sta $212d
            
            lda #%10110111          ;color math layers
            sta !colormathlayers
            sta $2131
            
            lda #%00000011          ;enable color math
            sta !colormathenable
            sta $2130
            
            stz !bg4xscroll
            stz !bg4xscroll
            
            stz !bg4yscroll
            stz !bg4yscroll
        }
        rep #$20
        
        lda #$0001
        sta !colormathmode
        
        lda !messageboxindex
        jsr msg_boxwrite
        
        jsr screenon
        
        rts
    }
    
    
    .oldcall: {
        ;argument: a = message box index
        ;          x = starting row
        sta !messageboxindex
        
        txa
        asl #5
        sta !messageboxstartingposition
        
        ;lda !kstatemessageboxsetup
        ;sta !gamestate
        ;stz !messageboxtimer
        rtl
    }
    
    .runscript: {
        ;call from gameplay
        
        ;arguments:
        ;x = script pointer
        ;iterates through a list of message boxes
        ;see msg_boxes.asm for the lists
        
        !tempboxheight   =   $10
        
        phb
        phy
        
        pea.w !msgboxbankshort<<8       ;this is a hirom bank!
        plb : plb                       ;no fast ram!
        
        lda $0000,x
        and #$00ff
        sta !tempboxheight
        inx
        
        -
        lda $0000,x
        and #$00ff
        cmp #$00ff
        beq +
        phx
        ldx !tempboxheight
        jsl msg_call
        plx
        inx
        bra -
        
        +
        ply
        plb
        rtl
    }
    
    
    .clear: {
        
        phb
        phx
        
        pea.w !msgtilemapbufferbank<<8
        plb : plb
        
        ldx #!msgtilemapbuffersize
        
        lda #!kbg4blanktile
        -
        sta.w !msgtilemapbuffershort,x
        dex : dex
        bpl -
        
        
        ;using these variables for this is kind of a mistake
        ;todo: paste together another dma routine
        ;explicitly for clearing the buffer
        
        lda #$0001
        sta !messageboxuploadflag
        
        lda #!msgtilemapbuffersize/2
        sta !messageboxlength
        
        lda #$0000
        stz !messageboxstartingposition
        
        plx
        plb
        rtl
    }
    
    
    .scrollup: {
        -
        jsl waitfornmi_long
        lda !bg4yscroll
        dec
        dec
        dec
        dec
        dec
        dec
        sta !bg4yscroll
        bpl -
        
        rts
    }
    
    
    .scrolldown: {
        -
        jsl waitfornmi_long
        lda !bg4yscroll
        inc
        inc
        inc
        inc
        inc
        inc
        sta !bg4yscroll
        cmp #$00ff
        bmi -
        
        rts
    }
    
    
    .wait: {
        ;wait for user to read and press a button
        
        ;while (not button) do:
            ;nothing i guess
            
        ;jsr msg_scrollup
        
        ldx #!kmessageboxtimermax
            
        -
        jsl waitfornmi_long
        dex
        bpl -
        
        --
        jsl waitfornmi_long
        lda !controller
        beq --
        
        ;jsr msg_scrolldown
        
        rts
    }
    
    
    .uploadtilemap: {               ;1x1
        php
        rep #$30
        
        lda.w #!msgtilemapbufferbank
        sta !dmasrcbank
        
        lda !messageboxstartingposition
        sta $00
        
        lda.w #!bg4tilemap                      ;dma addr = bg4tilemap + (messageboxstart / 2)
        clc
        adc $00
        sta !dmabaseaddr
        
        lda !messageboxstartingposition         ;srcptr = messageboxstart + bufferstart
        clc
        adc.w #!msgtilemapbuffershort
        sta !dmasrcptr
        
        lda !messageboxlength                   ;dmasize = messageboxsize*2
        asl
        sta !dmasize
        
        jsl dma_vramtransfur
        
        plp
        rtl
    }
    
    
    .boxwrite: {
        php
        phb
        phx
        phy
        
        pea.w !msgboxbankshort<<8
        plb : plb
        
        stz !messageboxlength
        
        lda !messageboxindex
        asl
        tax
        lda msgbox_list,x
        tay
        ;y = ptr to box
        
        ldx !messageboxstartingposition
        
        sep #$20
        
        -
        lda $0000,y
        clc
        adc #$60            ;ascii is in second half of bg4 graphics but starts at $20. $80-20=60
        
        sta.l !msgtilemapbufferlong,x
        cmp.b #!msgboxterminator+$60
        beq ..exit
        
        iny
        inx : inx
        ;betwixt these inxs you could add a palette selection bitset
        bra -
        
        ..exit:
        rep #$20
        txa
        sec
        sbc !messageboxstartingposition
        lsr
        sta !messageboxlength
        
        lda #$0001
        sta !messageboxuploadflag
        
        ply
        plx
        plb
        plp
        rts
    }
    
}