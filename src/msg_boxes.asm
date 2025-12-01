msgbox: {
    .list: {
        dw msgbox_def_blankrow          ;0
        dw msgbox_def_test1             ;1
        dw msgbox_def_test2             ;2
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
            db " ______________________________ "
            db "(         WHERE AM I?          )"
            db "(______________________________)"
            db !msgboxterminator
        }
    }
}