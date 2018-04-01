BIOS_10:
    ; params(video_mode)
    .video_mode:
        push bp
        mov bp, sp

        mov ah, 00h
        mov al, [bp+4]
        int 10h

        mov sp, bp
        pop bp
        
        mov ax, 0
        ret 4

    ; params(cursor_shape)        
    .text_mode_cursor_shape:
        push bp ; new stack frame
        mov bp, sp 

        mov ah, 01h
        mov cx, [bp+4]
        int 10h

        mov sp, bp 
        pop bp ; delete new stack frame
        
        mov ax, 0
        ret 4
    ; params(page_num, row, col);        
    .set_cursor_pos:
        push bp ; new stack frame
        mov bp, sp

        mov ah, 03h
        mov bh, [bp+4]
        mov cx, [bp+8]
        mov dx, [bp+12]
        int 10h

        mov sp, bp 
        pop bp ; delete new stack frame

        mov ax, 0
        ret 12
    .get_cursor_pos:
        mov ah, 04h
        int 10h
        ret
    ; params(page_num);        
    .set_page:
        push bp ; new stack frame
        mov bp, sp

        mov ah, 05h
        mov al, [bp+4]
        int 10h

        mov sp, bp 
        pop bp ; delete new stack frame
        mov ax, 0
        ret 4
    .cls:
        push bp
        mov bp, sp
        mov ax, 0600h
        mov bx, 0fh
        int 10h
        
        mov sp, bp
        pop bp
        ret
    .move_cursor:
        push bp
        mov bp, sp

        call BIOS_10.get_cursor_pos
        mov ah, 02h
        mov bh, 0h
        add dl, [bp+4]
        int 10h
        
        mov bp, sp
        pop bp
        ret 4