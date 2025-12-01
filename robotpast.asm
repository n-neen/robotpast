hirom

;===========================================================================================
;===========================================================================================
;===  
;===         _______              __                    __             
;===        / ___  /             / /                ___/ /__             
;===       / /  / /  _______    / /       _______  /__  ___/                  
;===      / /  /_/  / ___  /   / /____   / ___  /    / /                             
;===     / /       / /  / /   / ___  /  / /  / /    / /                          
;===    / /       / /  / /   / /  / /  / /  / /    / /                       
;===   / /       / /__/ /   / /__/ /  / /__/ /    / /        
;===  /_/       /______/   /______/  /______/    /_/
;===                                                    
;===        ________                         __                            
;===       / ____  /                     ___/ /__      
;===      / /___/ /  _______   _______  /__  ___/                      
;===     / ______/  / ___  /  / _____/    / /            
;===    / /        / /__/ /  / /____     / /                               
;===   / /        / ___  /   ____  /    / /                      
;===  /_/        /_/  /_/  /______/    /_/                    
;=== 
;===                                                                
;===========================================================================================
;===========================================================================================


incsrc "./src/defines.asm"

org $c00000
    incsrc "./src/msg_boxes.asm"
    print "end $c0: ", pc

org $808000
    incsrc "./src/boot.asm"
    incsrc "./src/main.asm"
    incsrc "./src/loading.asm"
    incsrc "./src/gameplay.asm"
    incsrc "./src/msg.asm"
    print "end $80: ", pc
    
org $c10000
    incsrc "./data/inc/c1.asm"      ;title screen graphics, palette, and tilemaps
    print "end $c1: ", pc
    
org $c20000
    ;
    print "end $c2: ", pc
    
org $c30000
    ;
    print "end $c3: ", pc
    
org $c40000
    ;
    print "end $c4: ", pc
    
org $c50000
    ;
    print "end $c5: ", pc
    
org $c60000
    ;
    print "end $c6: ", pc
    
org $c70000
    ;
    print "end $c7: ", pc

;===========================================================================================
;==================================               ==========================================
;==================================  H E A D E R  ==========================================
;==================================               ==========================================
;===========================================================================================


org $80ffc0

header: {
                                        ;game header
    db "robot past           "          ;cartridge name
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