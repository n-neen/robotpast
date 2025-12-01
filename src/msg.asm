msg: {
    ;high level calls will do:
    ;   lda index
    ;   sta !messageboxindex
    ;   lda !kstatemessageboxsetup
    ;   sta !gamestate
    ;maybe we wrap that to make it cleaner
    
    ;lda index
    ;jsl msg_call
    
    .call: {
        ;argument: a = message box index
        ;          x = starting row
        sta !messageboxindex
        
        txa
        asl #5
        sta !messageboxstartingposition
        
        lda !kstatemessageboxsetup
        sta !gamestate
        rtl
    }
    
    .runscript: {
        ;call from gameplay
        
        ;arguments:
        ;x = script pointer
        
        phb
        phy
        
        pea.w !msgboxbankshort<<8       ;this is a hirom bank!
        plb : plb                       ;no fast ram!
        
        lda !kstategameplay
        sta.l $7e0000|!returnstate
        
        -
        lda $0000,x
        and #$00ff
        cmp #$00ff
        beq +
        phx
        ldx #$0000
        jsl msg_call
        plx
        inx
        bra -
        
        +
        ply
        plb
        rtl
    }
    
    
    .clearbuffer: {
        phb
        
        pea.w !msgtilemapbufferbank
        plb : plb
        
        ldx #!msgtilemapbuffersize
        
        -
        stz !msgtilemapbuffershort,x
        dex : dex
        bpl -
        
        plb
        rtl
    }
    
    
    .boxwait: {
        ;wait for user to read and press a button
        
        ;while (not button) do:
            ;nothing i guess
        
        lda !controller
        beq +
        
        lda !returnstate
        sta !gamestate
        
        +
        rtl
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
        rtl
    }
    
}