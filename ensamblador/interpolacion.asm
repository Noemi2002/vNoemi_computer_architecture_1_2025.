section .data
    input_file db 'input.txt', 0
    output_file db 'output.txt', 0
    input_format db "%d %d %d %d", 0
    output_format db "%d %d %d %d", 10, "%d %d %d %d", 10, "%d %d %d %d", 10, "%d %d %d %d", 0
    
    ; Variables para almacenar los valores de entrada
    i11 dd 0
    i12 dd 0
    i21 dd 0
    i22 dd 0
    
    ; Matriz de salida 4x4
    output_matrix times 16 dd 0

section .text
    global _start
    extern fopen, fclose, fscanf, fprintf, exit

_start:
    ; Abrir archivo de entrada
    mov eax, 5              ; sys_open
    mov ebx, input_file
    mov ecx, 0              ; O_RDONLY
    int 0x80
    
    cmp eax, 0
    jl exit_error           ; Si hay error al abrir
    
    mov ebx, eax            ; Guardar file descriptor
    
    ; Leer los 4 valores del archivo
    mov eax, 3              ; sys_read
    mov ecx, buffer
    mov edx, 32             ; Tamaño suficiente para 4 números
    int 0x80
    
    ; Cerrar archivo de entrada
    mov eax, 6              ; sys_close
    int 0x80
    
    ; Parsear los valores leídos
    push i22
    push i21
    push i12
    push i11
    push input_format
    push buffer
    call sscanf
    add esp, 24
    
    ; Calcular los valores interpolados
    
    ; Primera fila (original + interpolaciones horizontales)
    mov eax, [i11]
    mov [output_matrix + 0], eax
    
    ; Calcular a = (4-2)/(4-1)*i11 + (2-1)/(4-1)*i12 = (2/3)*i11 + (1/3)*i12
    mov eax, [i11]
    mov ebx, 2
    imul eax, ebx           ; 2*i11
    mov ecx, eax            ; Guardar temporal
    
    mov eax, [i12]
    mov ebx, 1
    imul eax, ebx           ; 1*i12
    
    add eax, ecx            ; 2*i11 + 1*i12
    mov ebx, 3
    cdq
    idiv ebx                ; (2*i11 + i12)/3
    
    mov [output_matrix + 4], eax  ; a
    
    ; Calcular b = (4-3)/(4-1)*i11 + (3-1)/(4-1)*i12 = (1/3)*i11 + (2/3)*i12
    mov eax, [i11]
    mov ebx, 1
    imul eax, ebx           ; 1*i11
    mov ecx, eax            ; Guardar temporal
    
    mov eax, [i12]
    mov ebx, 2
    imul eax, ebx           ; 2*i12
    
    add eax, ecx            ; 1*i11 + 2*i12
    mov ebx, 3
    cdq
    idiv ebx                ; (i11 + 2*i12)/3
    
    mov [output_matrix + 8], eax  ; b
    
    mov eax, [i12]
    mov [output_matrix + 12], eax
    
    ; Segunda fila (interpolaciones verticales + interpolaciones diagonales)
    ; Calcular c = (4-2)/(4-1)*i11 + (2-1)/(4-1)*i21 = (2/3)*i11 + (1/3)*i21
    mov eax, [i11]
    mov ebx, 2
    imul eax, ebx
    mov ecx, eax
    
    mov eax, [i21]
    mov ebx, 1
    imul eax, ebx
    
    add eax, ecx
    mov ebx, 3
    cdq
    idiv ebx
    mov [output_matrix + 16], eax  ; c
    
    ; Calcular d (interpolación diagonal)
    ; d = promedio de los 4 valores alrededor
    mov eax, [i11]
    add eax, [i12]
    add eax, [i21]
    add eax, [i22]
    mov ebx, 4
    cdq
    idiv ebx
    mov [output_matrix + 20], eax  ; d
    
    ; Calcular e (interpolación diagonal)
    ; Similar a d pero con diferentes pesos
    mov eax, [i11]
    mov ebx, 1
    imul eax, ebx
    mov ecx, eax
    
    mov eax, [i12]
    mov ebx, 2
    imul eax, ebx
    add ecx, eax
    
    mov eax, [i21]
    mov ebx, 2
    imul eax, ebx
    add ecx, eax
    
    mov eax, [i22]
    mov ebx, 1
    imul eax, ebx
    add ecx, eax
    
    mov eax, ecx
    mov ebx, 6
    cdq
    idiv ebx
    mov [output_matrix + 24], eax  ; e
    
    ; Calcular f = (4-2)/(4-1)*i12 + (2-1)/(4-1)*i22 = (2/3)*i12 + (1/3)*i22
    mov eax, [i12]
    mov ebx, 2
    imul eax, ebx
    mov ecx, eax
    
    mov eax, [i22]
    mov ebx, 1
    imul eax, ebx
    
    add eax, ecx
    mov ebx, 3
    cdq
    idiv ebx
    mov [output_matrix + 28], eax  ; f
    
    ; Tercera fila (interpolaciones verticales + diagonales)
    ; Calcular g = (4-3)/(4-1)*i11 + (3-1)/(4-1)*i21 = (1/3)*i11 + (2/3)*i21
    mov eax, [i11]
    mov ebx, 1
    imul eax, ebx
    mov ecx, eax
    
    mov eax, [i21]
    mov ebx, 2
    imul eax, ebx
    
    add eax, ecx
    mov ebx, 3
    cdq
    idiv ebx
    mov [output_matrix + 32], eax  ; g
    
    ; Calcular h (interpolación diagonal)
    ; Similar a d pero con diferentes pesos
    mov eax, [i11]
    mov ebx, 1
    imul eax, ebx
    mov ecx, eax
    
    mov eax, [i12]
    mov ebx, 1
    imul eax, ebx
    add ecx, eax
    
    mov eax, [i21]
    mov ebx, 2
    imul eax, ebx
    add ecx, eax
    
    mov eax, [i22]
    mov ebx, 2
    imul eax, ebx
    add ecx, eax
    
    mov eax, ecx
    mov ebx, 6
    cdq
    idiv ebx
    mov [output_matrix + 36], eax  ; h
    
    ; Calcular i (interpolación diagonal)
    ; Similar a e pero con diferentes pesos
    mov eax, [i11]
    mov ebx, 1
    imul eax, ebx
    mov ecx, eax
    
    mov eax, [i12]
    mov ebx, 2
    imul eax, ebx
    add ecx, eax
    
    mov eax, [i21]
    mov ebx, 1
    imul eax, ebx
    add ecx, eax
    
    mov eax, [i22]
    mov ebx, 2
    imul eax, ebx
    add ecx, eax
    
    mov eax, ecx
    mov ebx, 6
    cdq
    idiv ebx
    mov [output_matrix + 40], eax  ; i
    
    ; Calcular j = (4-3)/(4-1)*i12 + (3-1)/(4-1)*i22 = (1/3)*i12 + (2/3)*i22
    mov eax, [i12]
    mov ebx, 1
    imul eax, ebx
    mov ecx, eax
    
    mov eax, [i22]
    mov ebx, 2
    imul eax, ebx
    
    add eax, ecx
    mov ebx, 3
    cdq
    idiv ebx
    mov [output_matrix + 44], eax  ; j
    
    ; Cuarta fila (original + interpolaciones horizontales)
    mov eax, [i21]
    mov [output_matrix + 48], eax
    
    ; Calcular k = (4-2)/(4-1)*i21 + (2-1)/(4-1)*i22 = (2/3)*i21 + (1/3)*i22
    mov eax, [i21]
    mov ebx, 2
    imul eax, ebx
    mov ecx, eax
    
    mov eax, [i22]
    mov ebx, 1
    imul eax, ebx
    
    add eax, ecx
    mov ebx, 3
    cdq
    idiv ebx
    mov [output_matrix + 52], eax  ; k
    
    ; Calcular l = (4-3)/(4-1)*i21 + (3-1)/(4-1)*i22 = (1/3)*i21 + (2/3)*i22
    mov eax, [i21]
    mov ebx, 1
    imul eax, ebx
    mov ecx, eax
    
    mov eax, [i22]
    mov ebx, 2
    imul eax, ebx
    
    add eax, ecx
    mov ebx, 3
    cdq
    idiv ebx
    mov [output_matrix + 56], eax  ; l
    
    mov eax, [i22]
    mov [output_matrix + 60], eax
    
    ; Escribir resultados en output.txt
    mov eax, 5              ; sys_open
    mov ebx, output_file
    mov ecx, 0x241          ; O_WRONLY|O_CREAT|O_TRUNC, 644 permissions
    mov edx, 0644o
    int 0x80
    
    cmp eax, 0
    jl exit_error           ; Si hay error al abrir
    
    mov ebx, eax            ; Guardar file descriptor
    
    ; Escribir la matriz de salida
    push dword [output_matrix + 60]
    push dword [output_matrix + 56]
    push dword [output_matrix + 52]
    push dword [output_matrix + 48]
    push dword [output_matrix + 44]
    push dword [output_matrix + 40]
    push dword [output_matrix + 36]
    push dword [output_matrix + 32]
    push dword [output_matrix + 28]
    push dword [output_matrix + 24]
    push dword [output_matrix + 20]
    push dword [output_matrix + 16]
    push dword [output_matrix + 12]
    push dword [output_matrix + 8]
    push dword [output_matrix + 4]
    push dword [output_matrix + 0]
    push output_format
    call fprintf
    add esp, 68
    
    ; Cerrar archivo de salida
    mov eax, 6              ; sys_close
    int 0x80
    
    ; Salir correctamente
    mov eax, 1              ; sys_exit
    mov ebx, 0
    int 0x80
    
exit_error:
    mov eax, 1              ; sys_exit
    mov ebx, 1
    int 0x80

section .bss
    buffer resb 32
