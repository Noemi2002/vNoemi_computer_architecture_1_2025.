section .data
    input_file  db 'input.img', 0
    output_file db 'output.img', 0
    num1        db 0         ; Cada num es de 1 byte
    num2        db 0
    num3        db 0
    num4        db 0
    num5        db 0
    num6        db 0
    num7        db 0
    num8        db 0
    num9        db 0
    num10        db 0
    num11        db 0
    num12        db 0
    num13        db 0
    num14        db 0
    num15        db 0
    num16        db 0
    num17       db 33        ; Valor a multiplicar
    num18       db 66        ; Valor a multiplicar
    divisor     db 100       ; Valor para dividir

section .bss
    input_fd    resd 1       ; Descriptor
    output_fd   resd 1       ; Descriptor

section .text
    global _start

matriz:
    ; Valor a
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

; -------------------------------------------------------------   
   
   ; Valor b
    movzx ax, byte [num1]
    mov bl, [num17]
    mul bl
    mov cx, ax

    movzx ax, byte [num2]
    mov bl, [num18]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num6], al
    
; -------------------------------------------------------------
   
   ; Valor c
    movzx ax, byte [num1]
    mov bl, [num18]
    mul bl
    mov cx, ax

    movzx ax, byte [num3]
    mov bl, [num17]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num7], al
        
; -------------------------------------------------------------
   
   ; Valor g
    movzx ax, byte [num1]
    mov bl, [num17]
    mul bl
    mov cx, ax

    movzx ax, byte [num3]
    mov bl, [num18]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num8], al

; -------------------------------------------------------------
   
   ; Valor k
    movzx ax, byte [num3]
    mov bl, [num18]
    mul bl
    mov cx, ax

    movzx ax, byte [num4]
    mov bl, [num17]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num9], al
    
; -------------------------------------------------------------
   
   ; Valor l
    movzx ax, byte [num3]
    mov bl, [num17]
    mul bl
    mov cx, ax

    movzx ax, byte [num4]
    mov bl, [num18]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num10], al
   
; -------------------------------------------------------------
   
   ; Valor f
    movzx ax, byte [num2]
    mov bl, [num18]
    mul bl
    mov cx, ax

    movzx ax, byte [num4]
    mov bl, [num17]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num11], al
   
; -------------------------------------------------------------
   
   ; Valor j
    movzx ax, byte [num2]
    mov bl, [num17]
    mul bl
    mov cx, ax

    movzx ax, byte [num4]
    mov bl, [num18]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num12], al
   
; -------------------------------------------------------------
   
   ; Valor d
    movzx ax, byte [num7]
    mov bl, [num18]
    mul bl
    mov cx, ax

    movzx ax, byte [num11]
    mov bl, [num17]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num13], al
   
; -------------------------------------------------------------
   
   ; Valor e
    movzx ax, byte [num7]
    mov bl, [num17]
    mul bl
    mov cx, ax

    movzx ax, byte [num11]
    mov bl, [num18]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num14], al

; -------------------------------------------------------------
   
   ; Valor h
    movzx ax, byte [num8]
    mov bl, [num18]
    mul bl
    mov cx, ax

    movzx ax, byte [num12]
    mov bl, [num17]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num15], al

; -------------------------------------------------------------
   
   ; Valor i
    movzx ax, byte [num8]
    mov bl, [num17]
    mul bl
    mov cx, ax

    movzx ax, byte [num12]
    mov bl, [num18]
    mul bl

    add ax, cx
    
    ; Dividir por 100
    mov bl, [divisor]
    div bl
    
    mov [num16], al
   
    ret ; Devolverse a la otra función

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

    ; Calcular los nuevos valores y llenar la matriz
    call matriz

    ; Escribir todos los valores, de num1 - num16
    mov eax, 4               ; sys_write
    mov ebx, [output_fd]
    mov ecx, num1
    mov edx, 16              
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
