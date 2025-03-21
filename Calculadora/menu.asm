.model small
.stack 64
.data
    mensaje_inicial db "Ingrese un numero (1-6): ", 10, 13, "$"
    mensaje_invalido db "Opcion invalida. Intente nuevamente.", 10, 13, "$"
    mensaje_suma db "El resultado de la suma es: $"
    mensaje_resta db "El resultado de la resta es: $"
    mensaje_mult db "El resultado de la multiplicacion es: $"
    mensaje_div db "El resultado de la division es: $"
    mensaje_nuevos db "Ingrese nuevo valor 1: $"
    mensaje_nuevos2 db "Ingrese nuevo valor 2: $"
    menu db 10, 13, "Menu:", 10, 13
         db "1. Suma", 10, 13
         db "2. Resta", 10, 13
         db "3. Multiplicacion", 10, 13
         db "4. Division", 10, 13
         db "5. Solicitar nuevo numero", 10, 13
         db "6. Salir", 10, 13, "$"
    valor1 db 25   
    valor2 db 10 
    diez db 10  

.code
inicio proc
    mov ax, @data
    mov ds, ax
    
principal:
    ; Mostrar menú
    mov dx, offset menu
    mov ah, 09h
    int 21h
    
    ; Solicitar opción
    mov dx, offset mensaje_inicial
    mov ah, 09h
    int 21h
    
    ; Leer opción del usuario
    mov ah, 01h
    int 21h
    sub al, '0'
    
    ; Verificar que la opción sea válida (1-6)
    cmp al, 1
    jb opcion_invalida
    cmp al, 6
    ja opcion_invalida
    
    ; Comparar para saltar a la opción correcta
    cmp al, 1
    je opcion1
    cmp al, 2
    je opcion2
    cmp al, 3
    je opcion3
    cmp al, 4
    je opcion4
    cmp al, 5
    je opcion5
    cmp al, 6
    je salir
    
opcion_invalida:
    mov dx, offset mensaje_invalido
    mov ah, 09h
    int 21h
    jmp principal
    
opcion1:
    ; Realizar la suma: valor1 + valor2
    mov al, [valor1]
    add al, [valor2]
    
    mov dx, offset mensaje_suma
    mov ah, 09h
    int 21h
    
    call mostrar_resultado
    jmp principal
    
opcion2:
    ; Realizar la resta: valor1 - valor2
    mov al, [valor1]
    sub al, [valor2]
    
    mov dx, offset mensaje_resta
    mov ah, 09h
    int 21h
    
    call mostrar_resultado
    jmp principal
    
opcion3:
    ; Realizar la multiplicación: valor1 * valor2
    mov al, [valor1]
    mul byte ptr [valor2]
    
    mov dx, offset mensaje_mult
    mov ah, 09h
    int 21h
    
    call mostrar_resultado
    jmp principal
    
opcion4:
    ; Realizar la división: valor1 / valor2
    xor ah, ah
    mov al, [valor1]
    div byte ptr [valor2]
    
    mov dx, offset mensaje_div
    mov ah, 09h
    int 21h
    
    call mostrar_resultado
    
    jmp principal
    
opcion5:
    ; Solicitar nuevo valor1
    mov dx, offset mensaje_nuevos
    mov ah, 09h
    int 21h
    
    ; Leer primer dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
    
    ; Multiplicar por 10
    mul byte ptr [diez]
    mov bl, al
    
    ; Leer segundo dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    
    ; Sumar ambos dígitos
    add bl, al
    mov [valor1], bl
    
    ; Solicitar nuevo valor2
    mov dx, offset mensaje_nuevos2
    mov ah, 09h
    int 21h
    
    ; Leer primer dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
    
    ; Multiplicar por 10
    mul byte ptr [diez]
    mov bl, al
    
    ; Leer segundo dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    
    ; Sumar ambos dígitos
    add bl, al
    mov [valor2], bl
    
    jmp principal
    
salir:
    mov ax, 4c00h
    int 21h

; Procedimiento para mostrar un resultado numérico
mostrar_resultado:
    xor ah, ah
    mov bl, 100
    div bl
    
    cmp al, 0
    je sin_centenas
    
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
sin_centenas:
    mov al, ah
    xor ah, ah
    mov bl, 10
    div bl
    
    cmp al, 0
    jne mostrar_decenas
    
    mov dl, [valor1]
    cmp dl, 100
    jge mostrar_decenas
    jmp sin_decenas
    
mostrar_decenas:
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
sin_decenas:
    mov al, ah
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
    ret
    
inicio endp
end inicio