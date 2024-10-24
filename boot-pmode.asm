BITS 16                     ; Instruct NASM that this is 16 bit (real mode) code
org 0x7c00                  ; Set the origin to 0x7c00 which is where BIOS loads the bootloader

start:
    ; Initialize the Global Descriptor Table (GDT)
    cli                     ; Disable all interrupts during mode switch
    lgdt [gdt_descriptor]   ; Load the GDT descriptor into the CPU

    ; Enable protected mode
    mov eax, cr0            ; Load CR0 register into EAX
    or  eax, 0x1            ; Set the PE (Protection Enable) bit
    mov cr0, eax            ; Write back to CR0 to enable protected mode

    ; Far jump to reload CS and enter protected mode
    jmp 0x08:_start         ; Jump to code segment (0x08 (1 x 8) is the GDT code segment selector)

BITS 32                     ; Instruct NASM that this is 32 bit (protected mode) code

_start:
    ; Setup segment registers for protected mode
    mov ax, 0x10            ; Data segment selector (0x10 (2 x 8) is the GDT data segment selector)
    mov ds, ax              ; Load DS
    mov es, ax              ; Load ES
    mov fs, ax              ; Load FS
    mov gs, ax              ; Load GS
    mov ss, ax              ; Load SS
    mov esp, 0x90000        ; Set up the stack (grows down from 0x90000)

    mov edi, 0xb8000        ; Set EDI to the video memory segment (0xb8000)
    mov ecx, 2000           ; 80 characters wide and 25 characters tall

clearscreen:
    mov byte [edi], 0x20    ; Write character (space character) to video memory at [EDI]
    inc edi                 ; Move to next byte (the attribute)

    mov byte [edi], 0x07    ; Write attribute (light gray on black) to video memory at [EDI]
    inc edi                 ; Move to the next byte (the character)

    dec ecx                 ; Decrement ECX
    jnz clearscreen         ; Jump to 'clearscreen' if CX is not zero

    mov edi, 0xb8000        ; Set EDI to the video memory segment (0xb8000)
    lea esi, [message]      ; Load the effective address of 'message' into ESI

printchar:
    mov al, [esi]           ; Load the next byte from [ESI] into AL
    cmp al, 0               ; Compare the byte with 0 (the null terminator)
    je end                  ; If the byte is 0 jump to 'end'

    mov [edi], al           ; Write character to video memory at [EDI]
    inc edi                 ; Move to next byte (the attribute)

    mov byte [edi], 0x07    ; Attribute byte (light gray on black)
    inc edi                 ; Move to the next byte (the character)

    inc esi                 ; Move to the next character

    jmp printchar           ; Repeat for the next character

end:
    hlt                     ; Halt the CPU

message db 'Hello World', 0 ; The 'Hello World' message followed by a null terminator (0)

; Global Descriptor Table (GDT)
gdt_start:
    ; Null descriptor (mandatory, but unused) (8 bytes)
    dd 0x00000000           ; 4 bytes of 0
    dd 0x00000000           ; 4 bytes of 0

    ; Code segment descriptor (8 bytes)
    dw 0xffff               ; Limit (lower 16 bits, max size 0xffff)
    dw 0x0000               ; Base (lower 16 bits, base address 0x00000000)
    db 0x00                 ; Base (next 8 bits)
    db 10011010b            ; Access byte (code segment, executable, readable)
    db 11001111b            ; Granularity (4KB blocks, 32 bit mode)
    db 0x00                 ; Base (upper 8 bits)

    ; Data segment descriptor (8 bytes)
    dw 0xffff               ; Limit (lower 16 bits, max size 0xffff)
    dw 0x0000               ; Base (lower 16 bits, base address 0x00000000)
    db 0x00                 ; Base (next 8 bits)
    db 10010010b            ; Access byte (data segment, readable / writeable)
    db 11001111b            ; Granularity (4KB blocks, 32 bit mode)
    db 0x00                 ; Base (upper 8 bits)
gdt_end:

; Global Descriptor Table (GDT) descriptor to pass to the LGDT instruction
gdt_descriptor:
    dw gdt_end-gdt_start-1  ; GDT size (size - 1)
    dd gdt_start            ; GDT base address

; Boot sector padding and signature
    times 510-($-$$) db 0   ; Pad the boot sector to 510 bytes (ensuring the total size is 512 bytes)
    dw 0xAA55               ; Boot sector signature (0xAA55), required for a valid bootable sector
