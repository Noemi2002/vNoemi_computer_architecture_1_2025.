section .data
    input_file  db 'input.bin', 0
    output_file db 'output.bin', 0
    num1        db 0         ; 1 byte
    num2        db 0         ; 1 byte
    num3        db 0         ; 1 byte
    num4        db 0         ; 1 byte
    num5        db 0         ; 1 byte (resultado)
    num17       db 33        ; 1 byte
    num18       db 66        ; 1 byte
    divisor     db 100       ; 1 byte

section .bss
    input_fd    resd 1       ; Descriptor
    output_fd   resd 1       ; Descriptor

section .text
    global _start

cuadrado:
    ; Cargar valores (extender a 16 bits para multiplicar)
    movzx ax, byte [num1]    ; num1 -> AX
    mov bl, [num18]          ; num18 -> BL
    mul bl                   ; AX = AL * BL (66*num1)
    mov cx, ax               ; Guardar en CX

    movzx ax, byte [num2]    ; num2 -> AX
    mov bl, [num17]          ; num17 -> BL
    mul bl                   ; AX = AL * BL (33*num2)

    add ax, cx               ; AX = (66*num1 + 33*num2)
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl                   ; AL = AX / 100
    
    mov [num5], al           ; Guardar solo el byte bajo
    ret

_start:
    ; Abrir archivo de entrada
    mov eax, 5               ; sys_open
    mov ebx, input_file
    mov ecx, 0               ; O_RDONLY
    int 0x80
    mov [input_fd], eax

    ; Crear archivo de salida
    mov eax, 5               ; sys_open
    mov ebx, output_file
    mov ecx, 0x42            ; O_RDWR|O_CREAT
    mov edx, 0o644           ; Permisos
    int 0x80
    mov [output_fd], eax

    ; Leer los 4 bytes originales
    mov eax, 3               ; sys_read
    mov ebx, [input_fd]
    mov ecx, num1
    mov edx, 4
    int 0x80

    ; Calcular el nuevo valor
    call cuadrado

    ; Escribir TODOS los valores (5 bytes)
    mov eax, 4               ; sys_write
    mov ebx, [output_fd]
    mov ecx, num1            ; num1-num5 son contiguos
    mov edx, 5               ; 5 bytes a escribir
    int 0x80

    ; Cerrar archivos
    mov eax, 6               ; sys_close
    mov ebx, [input_fd]
    int 0x80
    mov eax, 6
    mov ebx, [output_fd]
    int 0x80

    ; Salir
    mov eax, 1               ; sys_exit
    mov ebx, 0
    int 0x80
