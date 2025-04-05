section .data
    input_file  db 'input.txt', 0
    output_file db 'output.txt', 0
    newline     db 10
    digit_buffer times 11 db 0
    
    ; Valores de ejemplo (10, 20, 30, 40)
    matrix_2x2  dd 10, 20, 30, 40
    matrix_4x4  dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

section .text
    global _start

_start:
    ; --- Interpolar fila 0 ---
    mov eax, [matrix_2x2]      ; I00 = 10
    mov [matrix_4x4], eax
    mov ebx, [matrix_2x2 + 4]  ; I01 = 20
    mov ecx, 1                 ; paso 1/3
    call interpolate_linear
    mov [matrix_4x4 + 4], eax  ; Debería ser 13 (10 + (20-10)*1/3)
    mov ecx, 2                 ; paso 2/3
    call interpolate_linear
    mov [matrix_4x4 + 8], eax  ; Debería ser 17 (10 + (20-10)*2/3)
    mov eax, [matrix_2x2 + 4]
    mov [matrix_4x4 + 12], eax ; I03 = 20

    ; --- Interpolar fila 3 ---
    mov eax, [matrix_2x2 + 8]  ; I30 = 30
    mov [matrix_4x4 + 48], eax
    mov ebx, [matrix_2x2 + 12] ; I31 = 40
    mov ecx, 1
    call interpolate_linear
    mov [matrix_4x4 + 52], eax ; 33
    mov ecx, 2
    call interpolate_linear
    mov [matrix_4x4 + 56], eax ; 37
    mov eax, [matrix_2x2 + 12]
    mov [matrix_4x4 + 60], eax ; I33 = 40

    ; --- Interpolar columna 0 ---
    mov eax, [matrix_4x4]      ; I00 = 10
    mov ebx, [matrix_4x4 + 48] ; I30 = 30
    mov ecx, 1
    call interpolate_linear
    mov [matrix_4x4 + 16], eax ; 17
    mov ecx, 2
    call interpolate_linear
    mov [matrix_4x4 + 32], eax ; 23

    ; --- Interpolar columna 3 ---
    mov eax, [matrix_4x4 + 12] ; I03 = 20
    mov ebx, [matrix_4x4 + 60] ; I33 = 40
    mov ecx, 1
    call interpolate_linear
    mov [matrix_4x4 + 28], eax ; 27
    mov ecx, 2
    call interpolate_linear
    mov [matrix_4x4 + 44], eax ; 33

    ; --- Interpolar fila 1 ---
    mov eax, [matrix_4x4 + 16] ; I10 = 17
    mov ebx, [matrix_4x4 + 28] ; I13 = 27
    mov ecx, 1
    call interpolate_linear
    mov [matrix_4x4 + 20], eax ; 20
    mov ecx, 2
    call interpolate_linear
    mov [matrix_4x4 + 24], eax ; 24

    ; --- Interpolar fila 2 ---
    mov eax, [matrix_4x4 + 32] ; I20 = 23
    mov ebx, [matrix_4x4 + 44] ; I23 = 33
    mov ecx, 1
    call interpolate_linear
    mov [matrix_4x4 + 36], eax ; 26
    mov ecx, 2
    call interpolate_linear
    mov [matrix_4x4 + 40], eax ; 30

    ; --- Escribir resultados ---
    mov eax, 8                 ; sys_creat
    mov ebx, output_file
    mov ecx, 0644o
    int 0x80
    mov ebx, eax               ; File descriptor

    mov esi, matrix_4x4
    mov ecx, 16

write_loop:
    push ecx
    push ebx
    
    ; Convertir número a ASCII
    mov eax, [esi]
    lea edi, [digit_buffer + 10]
    mov byte [edi], 0
    
    mov ebx, 10
    test eax, eax
    jz write_zero

convert_loop:
    dec edi
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    test eax, eax
    jnz convert_loop
    jmp write_number

write_zero:
    dec edi
    mov byte [edi], '0'

write_number:
    lea ecx, [digit_buffer + 10]
    sub ecx, edi
    
    mov eax, 4
    mov ebx, [esp]
    mov edx, ecx
    mov ecx, edi
    int 0x80

    mov eax, 4
    mov ecx, newline
    mov edx, 1
    int 0x80

    add esi, 4
    pop ebx
    pop ecx
    loop write_loop

    mov eax, 6                 ; sys_close
    int 0x80

    mov eax, 1                 ; sys_exit
    xor ebx, ebx
    int 0x80

; --- Función de interpolación CORREGIDA ---
interpolate_linear:
    push edx
    push ecx
    push ebx

    ; Guardar valor inicial
    mov ebx, eax

    ; Calcular diferencia (final - inicial)
    sub eax, [esp + 8]         ; [esp+8] = valor inicial (eax original)
    neg eax                    ; eax = (final - inicial)

    ; Multiplicar por paso (ecx)
    imul eax, ecx

    ; Dividir por 3
    mov ecx, 3
    cdq
    idiv ecx

    ; Sumar al valor inicial
    add eax, ebx

    ; Redondear (si residuo ≥ 2, sumar 1)
    cmp edx, 2
    jge round_up
    jmp done

round_up:
    add eax, 1

done:
    pop ebx
    pop ecx
    pop edx
    ret
