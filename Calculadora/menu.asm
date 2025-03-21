.model small
.stack 64
.data
    mensaje_bienvenida db " Los valores ingresados deben ser de dos dígitos", 10, 13, "$"
    mensaje_inicial db "Ingrese un numero (1-6): $"
    mensaje_invalido db "Intente nuevamente.$"
    mensaje_suma db "El resultado de la suma es: $"
    mensaje_resta db "El resultado de la resta es: $"
    mensaje_mult db "El resultado de la multiplicacion es: $"
    mensaje_div db "El resultado de la division es: $"
    mensaje_valor1 db "Ingrese valor 1: $"
    mensaje_valor2 db "Ingrese valor 2: $"
    menu db 10, 13, "Menu:", 10, 13
         db "1. Suma", 10, 13
         db "2. Resta", 10, 13
         db "3. Multiplicacion", 10, 13
         db "4. Division", 10, 13
         db "5. Solicitar nuevo numero", 10, 13
         db "6. Salir", 10, 13, "$"
    valor1 db 0     ; Valor 1, ahora se inicializa en 0
    valor2 db 0     ; Valor 2, ahora se inicializa en 0
    diez db 10      ; Constante para conversiones

.code
inicio proc
    mov ax, @data
    mov ds, ax
    
    ; Mostrar mensaje de bienvenida
    mov dx, offset mensaje_bienvenida
    mov ah, 09h
    int 21h
    
    ; Solicitar primer valor al inicio
    call solicitar_valores
    
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
    sub al, '0'    ; Convertir de ASCII a número
    
    ; Verificar que la opción sea válida (1-6)
    cmp al, 1
    jb opcion_invalida
    cmp al, 6
    ja opcion_invalida
    
    ; Comparar para saltar a la opción correcta
    cmp al, 1
    je opcion_suma
    cmp al, 2
    je opcion_resta
    cmp al, 3
    je opcion_multiplicacion
    cmp al, 4
    je opcion_division
    cmp al, 5
    je opcion_nuevos_valores
    cmp al, 6
    je salir
    
opcion_invalida:
    mov dx, offset mensaje_invalido
    mov ah, 09h
    int 21h
    jmp principal
    
opcion_suma:
    ; Realizar la suma: valor1 + valor2
    xor ax, ax      ; Limpiar AX por seguridad
    mov al, [valor1]
    add al, [valor2]
    
    ; Mostrar mensaje
    mov dx, offset mensaje_suma
    mov ah, 09h
    int 21h
    
    ; Convertir resultado a ASCII y mostrar
    call mostrar_resultado
    jmp principal
    
opcion_resta:
    ; Realizar la resta: valor1 - valor2
    xor ax, ax      ; Limpiar AX por seguridad
    mov al, [valor1]
    sub al, [valor2]
    
    ; Mostrar mensaje
    mov dx, offset mensaje_resta
    mov ah, 09h
    int 21h
    
    ; Convertir resultado a ASCII y mostrar
    call mostrar_resultado
    jmp principal
    
opcion_multiplicacion:
    ; Realizar la multiplicación: valor1 * valor2
    xor ax, ax      ; Limpiar AX por seguridad
    mov al, [valor1]
    mul byte ptr [valor2]
    
    ; Mostrar mensaje
    mov dx, offset mensaje_mult
    mov ah, 09h
    int 21h
    
    ; Convertir resultado a ASCII y mostrar
    call mostrar_resultado
    jmp principal
    
opcion_division:
    ; Realizar la división: valor1 / valor2
    xor ax, ax      ; Limpiar AX por seguridad
    mov al, [valor1]
    div byte ptr [valor2]
    
    ; Mostrar mensaje (solo el cociente)
    mov dx, offset mensaje_div
    mov ah, 09h
    int 21h
    
    ; Mostrar solo el cociente (resultado en AL)
    call mostrar_resultado
    
    jmp principal
    
opcion_nuevos_valores:
    ; Solicitar nuevos valores
    call solicitar_valores
    jmp principal
    
solicitar_valores:
    ; Procedimiento para solicitar ambos valores
    
    ; Solicitar valor1
    mov dx, offset mensaje_valor1
    mov ah, 09h
    int 21h
    
    ; Leer el valor (asumiendo que será de dos dígitos)
    ; Primer dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    
    ; Multiplicar por 10
    mov bl, 10
    mul bl
    mov bl, al      ; Guardar el resultado en BL
    
    ; Segundo dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    
    ; Sumar al valor actual
    add bl, al
    
    ; Guardar el nuevo valor1
    mov [valor1], bl
    
    ; Salto de línea
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h
    
    ; Solicitar valor2
    mov dx, offset mensaje_valor2
    mov ah, 09h
    int 21h
    
    ; Leer el valor (asumiendo que será de dos dígitos)
    ; Primer dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    
    ; Multiplicar por 10
    mov bl, 10
    mul bl
    mov bl, al      ; Guardar el resultado en BL
    
    ; Segundo dígito
    mov ah, 01h
    int 21h
    sub al, '0'
    
    ; Sumar al valor actual
    add bl, al
    
    ; Guardar el nuevo valor2
    mov [valor2], bl
    
    ; Salto de línea
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h
    
    ret
    
salir:
    mov ax, 4C00h
    int 21h

; Procedimiento para mostrar un resultado numérico
mostrar_resultado:
    ; Guardar el resultado en BX para preservarlo
    mov bx, ax
    
    ; Convertir el número en AX a ASCII y mostrarlo
    ; Primero dividimos por 100 para obtener centenas
    mov ax, bx      ; Recuperar valor original
    xor dx, dx      ; Limpiar DX para división
    mov cx, 100
    div cx          ; AX = cociente (centenas), DX = residuo
    
    ; Mostrar dígito de centenas (si es mayor que 0)
    cmp ax, 0
    je sin_centenas
    
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
sin_centenas:
    ; Ahora trabajamos con el residuo para obtener decenas
    mov ax, dx
    xor dx, dx
    mov cx, 10
    div cx          ; AX = cociente (decenas), DX = residuo (unidades)
    
    ; Verificar si debemos mostrar las decenas
    ; (si hay centenas o si las decenas no son cero)
    cmp bx, 100
    jae mostrar_decenas
    
    cmp ax, 0
    je sin_decenas
    
mostrar_decenas:
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
sin_decenas:
    ; Finalmente, mostrar las unidades (siempre)
    mov al, dl
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
    ; Agregar salto de línea
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h
    
    ret
    
inicio endp
end inicio