section .data
    input_file db 'input.txt', 0      ; Nombre del archivo de entrada
    output_file db 'output.txt', 0    ; Nombre del archivo de salida
    buffer db 0                         ; Buffer para almacenar el número leído
    msg db 'Error al abrir el archivo', 0 ; Mensaje de error

section .bss
    file_descriptor resb 4             ; Descriptor de archivo para el archivo de entrada
    output_descriptor resb 4            ; Descriptor de archivo para el archivo de salida

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

    ; Leer un byte del archivo
    mov eax, 3                          ; syscall: sys_read
    mov ebx, [file_descriptor]          ; descriptor de archivo
    mov ecx, buffer                     ; buffer donde se almacenará el número
    mov edx, 1                          ; leer 1 byte
    int 0x80                            ; llamada al sistema

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
    mov ecx, buffer                     ; buffer que contiene el número
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
    int 0x80                            ; llamada al sistema

.error_open_input:
    ; Manejo de error al abrir el archivo de entrada
    mov eax, 4                          ; syscall: sys_write
    mov ebx, 1                          ; escribir en stdout
    mov ecx, msg                        ; mensaje de error
    mov edx, 30                         ; longitud del mensaje
    int 0x80                            ; llamada al sistema
    jmp .exit                           ; salir

.error_open_output:
    ; Manejo de error al abrir el archivo de salida
    mov eax, 4                          ; syscall: sys_write
    mov ebx, 1                          ; escribir en stdout
    mov ecx, msg                        ; mensaje de error
    mov edx, 30                         ; longitud del mensaje
    int 0x80                            ; llamada al sistema

.exit:
    mov eax, 1                          ; syscall: sys_exit
    xor ebx, ebx                        ; código de salida 0
    int 0x80                            ; llamada al sistema
