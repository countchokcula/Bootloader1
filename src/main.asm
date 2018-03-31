bits 16
[org 0x7c00]

; Note: CamelCase are jmp labels
; and underscored labels are subroutines
CursorRight equ 1
CursorLeft equ -1
jmp DEFAULT_VIDEO_BIOS


%include "include/Interrupts/BIOS_10.asm"

DEFAULT_VIDEO_BIOS:
    mov bp, 0x8000
    mov sp, bp

    .VideoMode:
        push 0 
        call BIOS_10.video_mode
        
    .SetPage:
        push 0607h
        call BIOS_10.text_mode_cursor_shape

        times 3 push 0 ; passes in as func(0,0,0);
        call BIOS_10.set_cursor_pos
        
        push 0
        call BIOS_10.set_page
        jmp _main
    
    .cls:
        mov ax, 0600h
        mov bh, 0fh ;0f black n white
        mov cx, 0h
        int 10h
        jmp DEFAULT_VIDEO_BIOS.SetPage

;STDIN:
    ;.delete_char:
   ;     push cursorLeft
   ;     call STD.move_cursor
        
    ;    ret
STDOUT:
    .put_char:
        push bp
        mov bp, sp

        mov ah, 09h
        mov al, [bp+4]
        mov bx, 000fh
        mov cx, 1
        int 10h
        
        push CursorRight
        call BIOS_10.move_cursor

        mov sp, bp
        pop sp
        ret 4

    .print:
        mov ax, ds
        mov es, ax
        mov bp, di ;mov string from di
        mov cx, bx ; get len from bx
        
        mov ax, 1300h
        mov bx, 000fh
        int 10h
        mov bp, sp
        ret
BIOS_13:
    .disk_error:
        
        mov di, DISK_ERROR_MSG
        mov bx, len1
        call  STDOUT.print

       
        ret 
    .read_sector:
        mov ax, 0201h
        mov cx, 0001h
        mov dx, 0000h
        mov bx, 0xa000
        mov es, bx
        mov bx, 0x1000
        int 13h

        jc error
        cmp al, 0xa
        jne error
        ;if (carry || al != no_of_sectors) BIOS_13.disk_error() else return;
        jmp end
        error:
            call BIOS_13.disk_error
        end:
        ret
        
    
_main:
    
    call BIOS_13.disk_error
    
    
    jmp $

DISK_ERROR_MSG db "Disk read error!", 0
len1 equ $-DISK_ERROR_MSG

msg db "Hello this is Jalen's bootloader",0
len2 equ $-msg
; cursor properties
default_cursor_pos times 3 db 0
times 510-($-$$) db 0 
dw 0xaa55