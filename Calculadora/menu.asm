.model small
.stack 64
.data
    mensaje_inicio db "Los valores ingresados deben ser de dos digitos", 10, 13, "$"
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
    valor1 db 0   
    valor2 db 0  
    diez db 10   

.code
    inicio proc
        mov ax, @data
        mov ds, ax
        
        mov dx, offset mensaje_inicio
        mov ah, 09h
        int 21h
        
        call solicitar_valores
        
    principal:
        mov dx, offset menu
        mov ah, 09h
        int 21h
        
        mov dx, offset mensaje_inicial
        mov ah, 09h
        int 21h
        
        mov ah, 01h
        int 21h
        sub al, '0'
        
        cmp al, 1
        jb opcion_invalida
        cmp al, 6
        ja opcion_invalida
        
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
        xor ax, ax 
        mov al, [valor1]
        add al, [valor2]
        
        mov dx, offset mensaje_suma
        mov ah, 09h
        int 21h
        
        xor ah, ah
        
        call mostrar_resultado
        jmp principal
        
    opcion_resta:
        xor ax, ax 
        mov al, [valor1]
        sub al, [valor2]
        
        mov dx, offset mensaje_resta
        mov ah, 09h
        int 21h
        
        call mostrar_resultado
        jmp principal
        
    opcion_multiplicacion:
        xor ax, ax   
        mov al, [valor1]
        xor bx, bx   
        mov bl, [valor2]
        mul bx         
        
        mov bx, ax
        
        mov dx, offset mensaje_mult
        mov ah, 09h
        int 21h
        
        mov ax, bx
        
        call mostrar_resultado
        jmp principal
        
    opcion_division:
        xor ax, ax   
        mov al, [valor1]
        div byte ptr [valor2]
        
        mov dx, offset mensaje_div
        mov ah, 09h
        int 21h
        
        call mostrar_resultado
        
        jmp principal
        
    opcion_nuevos_valores:
        call solicitar_valores
        jmp principal
        
    solicitar_valores:
        ; Solicitar valor1
        mov dx, offset mensaje_valor1
        mov ah, 09h
        int 21h
        
        mov ah, 01h
        int 21h
        sub al, '0'
        
        mov bl, 10
        mul bl
        mov bl, al  
        
        mov ah, 01h
        int 21h
        sub al, '0'
        
        add bl, al
        
        mov [valor1], bl
        
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
        
        mov ah, 01h
        int 21h
        sub al, '0'
        
        mov bl, 10
        mul bl
        mov bl, al   
        
        mov ah, 01h
        int 21h
        sub al, '0'
        
        add bl, al
        
        mov [valor2], bl
        
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

    mostrar_resultado:      
        test ax, ax
        jnz no_es_cero
        
        mov dl, '0'
        mov ah, 02h
        int 21h
        jmp fin_mostrar
        
    no_es_cero:
        mov bx, ax
        mov cx, 0     
        mov ax, bx      
        
    convertir_digitos:
        xor dx, dx    
        mov bx, 10
        div bx         
        
        push dx
        inc cx   
        
        test ax, ax
        jnz convertir_digitos
        
    mostrar_digitos:
        pop dx
        add dl, '0' 
        mov ah, 02h
        int 21h
        loop mostrar_digitos
        
    fin_mostrar:
        mov dl, 13
        mov ah, 02h
        int 21h
        mov dl, 10
        mov ah, 02h
        int 21h
        
        ret
    
    inicio endp
end inicio