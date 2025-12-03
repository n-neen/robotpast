game: {
    .play: {
        ;todo
        
        ;handle player
        ;handle enemies
        ;scroll, load level
        
        ;call messagebox scripts
        
        ;bug: goes right from 1 to 4
        
        
        ldx.w #msgbox_scripts_1
        jsl msg_runscript
        
        ;lda #$0001
        ;ldx #$0003
        ;jsl msg_call
        
        ;lda #$0002
        ;ldx #$0003
        ;jsl msg_call
        
        ;lda #$0003
        ;ldx #$0003
        ;jsl msg_call
        
        ;lda #$0004
        ;ldx #$0003
        ;jsl msg_call
        
        
        rtl
    }
}