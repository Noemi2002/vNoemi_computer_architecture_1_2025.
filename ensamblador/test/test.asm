; Data section - contains initialized data
section .data
    input_file db 'input.txt', 0       ; Input filename (null-terminated)
    output_file db 'output.txt', 0     ; Output filename (null-terminated)
    newline db 0xA                     ; Newline character (ASCII 10)
    buffer times 16 db 0               ; Buffer for reading/writing numbers (16 bytes)
    
; BSS section - contains uninitialized data
section .bss
    numbers resd 4                     ; Reserve space for 4 numbers (4 bytes each)
    result resd 1                      ; Reserve space for the sum result
    file_descriptor resd 1             ; Store file descriptor for open files
    
; Text section - contains executable code
section .text
    global _start                      ; Entry point for the program

_start:
    ; =============================================
    ; Open the input file for reading
    ; =============================================
    mov eax, 5                         ; System call number for sys_open
    mov ebx, input_file                ; Pointer to filename
    mov ecx, 0                         ; Flags (0 = O_RDONLY, read-only)
    int 0x80                           ; Call kernel
    mov [file_descriptor], eax         ; Save the returned file descriptor

    ; =============================================
    ; Read the 4 numbers from the input file
    ; =============================================
    mov ecx, 4                         ; Counter for 4 numbers
    mov edi, numbers                   ; Pointer to numbers array
read_loop:
    push ecx                           ; Save loop counter
    
    ; Read a line (number) from the file
    mov eax, 3                         ; System call number for sys_read
    mov ebx, [file_descriptor]         ; File descriptor
    mov ecx, buffer                    ; Buffer to read into
    mov edx, 16                        ; Maximum bytes to read
    int 0x80                           ; Call kernel
    
    ; Convert ASCII string to integer
    mov esi, buffer                    ; Point to the buffer containing ASCII number
    call atoi                          ; Call ASCII-to-integer conversion
    mov [edi], eax                     ; Store the converted number in array
    add edi, 4                         ; Move to next position in array (4 bytes per int)
    
    pop ecx                            ; Restore loop counter
    loop read_loop                     ; Decrement ECX and loop if not zero
    
    ; =============================================
    ; Close the input file
    ; =============================================
    mov eax, 6                         ; System call number for sys_close
    mov ebx, [file_descriptor]         ; File descriptor to close
    int 0x80                           ; Call kernel
    
    ; =============================================
    ; Calculate the sum of the 4 numbers
    ; =============================================
    mov eax, [numbers]                 ; Load first number
    add eax, [numbers+4]               ; Add second number (offset 4 bytes)
    add eax, [numbers+8]               ; Add third number (offset 8 bytes)
    add eax, [numbers+12]              ; Add fourth number (offset 12 bytes)
    mov [result], eax                  ; Store the final sum
    
    ; =============================================
    ; Open the output file for writing
    ; =============================================
    mov eax, 5                         ; System call number for sys_open
    mov ebx, output_file               ; Pointer to filename
    mov ecx, 0x241                     ; Flags: O_CREAT|O_WRONLY|O_TRUNC
                                       ; (Create if doesn't exist, write-only, truncate)
    mov edx, 0644o                     ; File permissions (rw-r--r--)
    int 0x80                           ; Call kernel
    mov [file_descriptor], eax         ; Save the returned file descriptor
    
    ; =============================================
    ; Write the result to output file 3 times
    ; =============================================
    mov ecx, 3                         ; Counter for 3 writes
write_loop:
    push ecx                           ; Save loop counter
    
    ; Convert the integer result to ASCII string
    mov eax, [result]                  ; Load the sum result
    mov edi, buffer                    ; Point to buffer for ASCII conversion
    call itoa                          ; Call integer-to-ASCII conversion
    
    ; Write the number string to file
    mov eax, 4                         ; System call number for sys_write
    mov ebx, [file_descriptor]         ; File descriptor
    mov ecx, buffer                    ; Pointer to string to write
    mov edx, edi                       ; Length of string (returned by itoa)
    sub edx, buffer                    ; Calculate length by subtracting pointers
    int 0x80                           ; Call kernel
    
    ; Write a newline after each number
    mov eax, 4                         ; sys_write
    mov ebx, [file_descriptor]         ; File descriptor
    mov ecx, newline                   ; Pointer to newline character
    mov edx, 1                         ; Length (1 byte)
    int 0x80                           ; Call kernel
    
    pop ecx                            ; Restore loop counter
    loop write_loop                    ; Decrement ECX and loop if not zero
    
    ; =============================================
    ; Close the output file
    ; =============================================
    mov eax, 6                         ; System call number for sys_close
    mov ebx, [file_descriptor]         ; File descriptor to close
    int 0x80                           ; Call kernel
    
    ; =============================================
    ; Exit the program
    ; =============================================
    mov eax, 1                         ; System call number for sys_exit
    mov ebx, 0                         ; Exit status (0 = success)
    int 0x80                           ; Call kernel

; =============================================
; Function: atoi (ASCII to integer conversion)
; Input: ESI = pointer to ASCII string
; Output: EAX = integer value
; =============================================
atoi:
    xor eax, eax                       ; Clear EAX (will hold result)
    xor ecx, ecx                       ; Clear ECX (general purpose)
atoi_loop:
    movzx edx, byte [esi]              ; Load next byte, zero-extend to EDX
    cmp dl, 0xA                        ; Check for newline character
    je atoi_done                       ; If newline, we're done
    cmp dl, 0                          ; Check for null terminator
    je atoi_done                       ; If null, we're done
    sub dl, '0'                        ; Convert ASCII digit to numeric value
    imul eax, 10                       ; Multiply current result by 10
    add eax, edx                       ; Add the new digit
    inc esi                            ; Move to next character
    jmp atoi_loop                      ; Repeat
atoi_done:
    ret                                ; Return with result in EAX

; =============================================
; Function: itoa (integer to ASCII conversion)
; Input: EAX = integer value, EDI = pointer to buffer
; Output: EDI = pointer to end of string, EDX = length
; =============================================
itoa:
    push ebx                           ; Save EBX (will be modified)
    push ecx                           ; Save ECX (will be used as counter)
    mov ebx, 10                        ; Divisor (base 10)
    xor ecx, ecx                       ; Digit counter (initialize to 0)
    
    ; Special case: handle zero input
    test eax, eax                      ; Check if input is zero
    jnz itoa_nonzero                   ; If not zero, proceed normally
    mov byte [edi], '0'                ; Store ASCII '0'
    inc edi                            ; Move pointer forward
    inc ecx                            ; Increment digit count
    jmp itoa_done                      ; Skip the normal conversion
    
itoa_nonzero:
    ; Extract digits from number and push them to stack
itoa_extract:
    xor edx, edx                       ; Clear EDX for division
    div ebx                            ; Divide EAX by 10, result in EAX, remainder in EDX
    add dl, '0'                        ; Convert remainder to ASCII
    push edx                           ; Push digit to stack
    inc ecx                            ; Increment digit count
    test eax, eax                      ; Check if quotient is zero
    jnz itoa_extract                   ; If not zero, continue
    
    ; Pop digits from stack to buffer (reverses order)
itoa_store:
    pop edx                            ; Get digit from stack
    mov [edi], dl                      ; Store ASCII digit in buffer
    inc edi                            ; Move pointer forward
    loop itoa_store                    ; Repeat for all digits
    
itoa_done:
    mov edx, edi                       ; Calculate string length
    sub edx, buffer                    ; by subtracting buffer start from current position
    pop ecx                            ; Restore ECX
    pop ebx                            ; Restore EBX
    ret                                ; Return
