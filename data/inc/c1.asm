;data




test: {
    
    .map: {
        ..1:
            incbin ./data/tilemaps/layer1_4.map
            incbin ./data/tilemaps/layer1_3.map
            incbin ./data/tilemaps/layer1_2.map
            incbin ./data/tilemaps/layer1_1.map
        
        ..2:
            incbin ./data/tilemaps/layer2_4.map
            incbin ./data/tilemaps/layer2_3.map
            incbin ./data/tilemaps/layer2_2.map
            incbin ./data/tilemaps/layer2_1.map
        
        ..3:
            incbin ./data/tilemaps/layer3_1.map
            incbin ./data/tilemaps/layer3_2.map
            incbin ./data/tilemaps/layer3_1.map
            incbin ./data/tilemaps/layer3_2.map
            
        ..4:
            incbin ./data/tilemaps/layer4_1.map
            incbin ./data/tilemaps/layer4_2.map
    }
    
    .gfx:
        incbin ./data/gfx/test7.chr
        
    .pal:
        incbin ./data/pal/test7.pal
        
    .gfx4:
        incbin ./data/gfx/bg4.chr
}
