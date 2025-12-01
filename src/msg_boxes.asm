msgbox: {
    .scripts: {
        ..1: db $00, $01, $02, $03, $04, $ff
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
            db " WILL RETURN TO  THE ROBOT PAST "
            db "               *                "
            db !msgboxterminator
        }
        
        ..test2: {
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db "X         WHERE AM I?    2     X"
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db !msgboxterminator
        }
        
        ..test3: {
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db "X         WHERE AM I?    3     X"
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db !msgboxterminator
        }
        
        ..test4: {
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db "X         WHERE AM I?    4     X"
            db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            db !msgboxterminator
        }
    }
}