BITS 16                     ; Instruct NASM that this is 16 bit (real mode) code
org 0x7c00                  ; Set the origin to 0x7c00 which is where BIOS loads the bootloader

start:
    mov si, message         ; Load the address of the 'message' string into the SI register

printchar:
    lodsb                   ; Load the next byte from [SI] into AL, and increment SI
    cmp al, 0               ; Compare the byte in AL with 0 (the null terminator)
    je end                  ; If the byte is 0 jump to 'end'
    mov ah, 0x0e            ; BIOS write character in TTY (teletype) mode
    int 0x10                ; BIOS video service nterrupt
    jmp printchar           ; Jump back to 'printchar' and print next character

end:
    hlt                     ; Halt the CPU

message db 'Hello World', 0 ; The 'Hello World' message followed by a null terminator (0)

times 510-($-$$) db 0       ; Pad the boot sector to 510 bytes (ensuring the total size is 512 bytes)
dw 0xAA55                   ; Boot sector signature (0xAA55), required for a valid bootable sector
