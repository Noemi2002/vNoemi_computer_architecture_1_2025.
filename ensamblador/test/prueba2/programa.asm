section .data
    input_file  db 'input.bin', 0    ; Archivo de entrada (binary)
    output_file db 'output.bin', 0   ; Archivo de salida (binary)
    numSuma     db 1                 ; Valor a sumar (constante)
    num1        db 0                 ; Variables para los 4 bytes
    num2        db 0
    num3        db 0
    num4        db 0

section .bss
    input_fd    resd 1               ; File descriptor entrada
    output_fd   resd 1               ; File descriptor salida

section .text
    global _start

_start:
    ; Abrir archivo de entrada
    mov eax, 5                      ; sys_open
    mov ebx, input_file
    mov ecx, 0                      ; O_RDONLY
    int 0x80
    mov [input_fd], eax

    ; Crear/abrir archivo de salida
    mov eax, 5                      ; sys_open
    mov ebx, output_file
    mov ecx, 0x41                   ; O_WRONLY | O_CREAT
    mov edx, 0o644                  ; Permisos
    int 0x80
    mov [output_fd], eax

    ; Leer 4 bytes
    mov eax, 3                      ; sys_read
    mov ebx, [input_fd]
    mov ecx, num1
    mov edx, 4
    int 0x80

    ; Sumar numSuma a cada byte (forma alternativa)
    mov al, [numSuma]               ; Cargar valor a sumar (1)
    add [num1], al                  ; num1 += numSuma
    add [num2], al                  ; num2 += numSuma
    add [num3], al                  ; num3 += numSuma
    add [num4], al                  ; num4 += numSuma

    ; Escribir resultados
    mov eax, 4                      ; sys_write
    mov ebx, [output_fd]
    mov ecx, num1
    mov edx, 4
    int 0x80

    ; Cerrar archivos
    mov eax, 6                      ; sys_close
    mov ebx, [input_fd]
    int 0x80
    mov eax, 6
    mov ebx, [output_fd]
    int 0x80

    ; Salir
    mov eax, 1
    mov ebx, 0
    int 0x80
