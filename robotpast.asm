hirom

incsrc "./src/defines.asm"

org $c00000
    ;

org $808000
    incsrc "./src/boot.asm"
    incsrc "./src/main.asm"
    incsrc "./src/loading.asm"
    
org $c10000
    incsrc "./data/inc/c1.asm"
    
org $c20000
org $c30000
org $c40000
org $c50000
org $c60000
org $c70000


;===========================================================================================
;==================================               ==========================================
;==================================  H E A D E R  ==========================================
;==================================               ==========================================
;===========================================================================================


org $80ffc0

header: {
                                        ;game header
    db "newgame              "          ;cartridge name
    db $31                              ;fastrom, hirom
    db $02                              ;rom + ram + sram
    db $09                              ;rom size = 512k
    db $00                              ;sram size 0
    db $00                              ;country code
    db $ff                              ;developer code
    db $00                              ;rom version
    dw $FFFF                            ;checksum complement
    dw $FFFF                            ;checksum
    
    ;interrupt vectors
    
    ;native mode
    dw errhandle, errhandle, errhandle, errhandle, errhandle, nmi, errhandle, irq
    
    ;emulation mode
    dw errhandle, errhandle, errhandle, errhandle, errhandle, errhandle, boot, errhandle
}