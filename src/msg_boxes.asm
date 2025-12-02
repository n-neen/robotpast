msgbox: {
    .scripts: {
            ;first byte is height to draw at; terminated by $ff
        ..1: db $05, $01, $02, $03, $04, $03, $02, $01, $00, $ff
    }
    
    
    .list: {
        dw msgbox_def_blankrow          ;0
        dw msgbox_def_test1             ;1
        dw msgbox_def_test2             ;2
        dw msgbox_def_test3             ;3
        dw msgbox_def_test4             ;4
    }
    
              ;"A message is 32 characters long."
    .def: {
        ..blankrow: {
            db "                                "
            db !msgboxterminator
        }
        
        ..test1: {
            db "               *                "
            db " AT SOME DISTANT PLACE AND TIME "
            db " GONE ARE SORROW, PAIN AND MIND "
            db " WHEN OUR SAVIOUR COMES AT LAST "
            db "  WE WILL RETURN TO ROBOT PAST  "
            db "               *                "
            db !msgboxterminator
        }
        
        ..test2: {
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db "X    THIS IS A TEST MESSAGE    X"
            db "X    THIS IS A      MESSAGE    X"
            db "X    THIS IS A TEST            X"
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db !msgboxterminator
        }
        
        ..test3: {
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db "X         WHERE    I?    3     X"
            db "X         WHERE AM?      3     X"
            db "X         WHERE?         3     X"
            db "X               AM I?    3     X"
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db !msgboxterminator
        }
        
        ..test4: {
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db "X         THIS IS        4     X"
            db "X ANOTHER BIG MESSAGE    4     X"
            db "X         WHERE AM I?    4     X"
            db "X         WHERE AM I?    4     X"
            db "X         WHERE AM I?    4     X"
            db "X   TEST OF THE MESSAGE BOX    X"
            db "X         WHERE AM I?    4     X"
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db !msgboxterminator
        }
    }
}