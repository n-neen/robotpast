msgbox: {
    
    
    .scripts: {
        ;first byte is height to draw at
        ;subsequent bytes are messages to display
        ;terminated by $ff

        ..1: db $07, $01, $02, $03, $04, $00, $ff
    }
    
    
    .list: {
        dw msgbox_def_blank             ;0
        dw msgbox_def_intro1            ;1
        dw msgbox_def_intro2            ;2
        dw msgbox_def_intro3            ;3
        dw msgbox_def_intro4            ;4
        dw msgbox_def_test1             ;5
        dw msgbox_def_test2             ;6
    }
    
              ;"A message is 32 characters long."
    .def: {
        ..blank: {
            db " "
            db !msgboxterminator
        }
        
        ..intro1: {
            db "               *                "
            db " AT SOME DISTANT PLACE AND TIME "
            db " GONE ARE SORROW, PAIN AND MIND "
            db " WHEN OUR SAVIOUR COMES AT LAST "
            db "  WE WILL RETURN TO ROBOT PAST  "
            db "               *                "
            db !msgboxterminator
        }
        
        ..intro2: {
            db "          2                     "
            db "           2                    "
            db "            2                   "
            db "             2                  "
            db "              2                 "
            db !msgboxterminator
        }
        
        ..intro3: {
            db "   3    3    3    3    3    3   "
            db "    3    3    3    3    3    3  "
            db "     3    3    3    3    3    3 "
            db "      3    3    3    3    3    3"
            db "3      3    3    3    3    3    "
            db !msgboxterminator
        }
        
        ..intro4: {
            db "4    4    4    4    4    4    4 "
            db " 4    4    4    4    4    4    4"
            db "  4    4    4    4    4    4    "
            db "   4    4    4    4    4    4   "
            db "    4    4    4    4    4    4  "
            db !msgboxterminator
        }
        
        ..test1: {
            db "            asdf                "
            db "                                "
            db "                                "
            db "                                "
            db "                                "
            db !msgboxterminator
        }
        
        ..test2: {
            db "                                "
            db "            qweretyuiopp        "
            db "                                "
            db "                                "
            db "                                "
            db !msgboxterminator
        }
    }
}