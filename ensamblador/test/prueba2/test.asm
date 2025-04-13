section .data
    input_file db 'input.txt', 0      ; Nombre del archivo de entrada
    output_file db 'output.txt', 0    ; Nombre del archivo de salida
    buffer db 3                         ; Buffer para almacenar el número leído (máximo 3 caracteres + 1 para el null)
    msg db 'Error al abrir el archivo', 0 ; Mensaje de error
    out_of_range_msg db 'Número fuera de rango (0-255)', 0 ; Mensaje de error para rango

section .bss
    file_descriptor resb 4             ; Descriptor de archivo para el archivo de entrada
    output_descriptor resb 4            ; Descriptor de archivo para el archivo de salida
    number resb 1                       ; Buffer para almacenar el número convertido

section .text
    global _start

_start:
    ; Abrir el archivo de entrada
    mov eax, 5                          ; syscall: sys_open
    mov ebx, input_file                 ; nombre del archivo
    mov ecx, 0                          ; O_RDONLY
    int 0x80                            ; llamada al sistema
    mov [file_descriptor], eax          ; guardar el descriptor de archivo

    ; Comprobar si hubo un error al abrir el archivo
    cmp eax, 0
    jl .error_open_input                ; Si el valor es negativo, hubo un error

    ; Leer el número como texto
    mov eax, 3                          ; syscall: sys_read
    mov ebx, [file_descriptor]          ; descriptor de archivo
    mov ecx, buffer                     ; buffer donde se almacenará el número
    mov edx, 3                          ; leer hasta 3 bytes
    int 0x80                            ; llamada al sistema

    ; Convertir el texto a un número
    mov ecx, buffer                     ; puntero al buffer
    xor eax, eax                        ; limpiar EAX (acumulador para el número)
    xor ebx, ebx                        ; limpiar EBX (multiplicador)

.convert_loop:
    movzx edx, byte [ecx]              ; cargar el siguiente carácter
    cmp edx, 10                         ; comprobar si es un salto de línea (newline)
    je .done_converting                 ; si es un salto de línea, terminar
    sub edx, '0'                        ; convertir de ASCII a número
    imul eax, eax, 10                   ; multiplicar el número acumulado por 10
    add eax, edx                        ; añadir el nuevo dígito
    inc ecx                             ; mover al siguiente carácter
    jmp .convert_loop                   ; repetir el bucle

.done_converting:
    ; Comprobar si el número está en el rango de 0 a 255
    cmp eax, 255
    jg .error_out_of_range              ; si es mayor que 255, error

    ; Almacenar el número en el buffer
    mov [number], al                   ; almacenar el número como un byte

    ; Abrir el archivo de salida
    mov eax, 5                          ; syscall: sys_open
    mov ebx, output_file                ; nombre del archivo
    mov ecx, 1                          ; O_WRONLY
    mov edx, 0                          ; O_CREAT | O_TRUNC
    int 0x80                            ; llamada al sistema
    mov [output_descriptor], eax        ; guardar el descriptor de archivo

    ; Comprobar si hubo un error al abrir el archivo de salida
    cmp eax, 0
    jl .error_open_output               ; Si el valor es negativo, hubo un error

    ; Escribir el byte leído en el archivo de salida
    mov eax, 4                          ; syscall: sys_write
    mov ebx, [output_descriptor]        ; descriptor de archivo
    mov ecx, number                     ; buffer que contiene el número
    mov edx, 1                          ; escribir 1 byte
    int 0x80                            ; llamada al sistema

    ; Cerrar los descriptores de archivo
    mov eax, 6                          ; syscall: sys_close
    mov ebx, [file_descriptor]          ; cerrar archivo de entrada
    int 0x80                            ; llamada al sistema

    mov eax, 6                          ; syscall: sys_close
    mov ebx, [output_descriptor]        ; cerrar archivo de salida
    int 0x80                            ; llamada al sistema

    ; Salir del programa
    mov eax, 1                          ; syscall: sys_exit
    xor ebx, ebx                        ; código de salida 0
    int 0x
