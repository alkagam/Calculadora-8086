;programa de una suma de 2 numero con una precision de 2 decimales 
;debera desarrollar un menu en en el que le pida al usario 
;a) dame el primer numero
;b) dame el siguiente numero
;desea continuar (si/no)  
;Con un rango de -99.99 a 99.99 si exede tendra que dicir "fuera de rango" 
;                                           Macros 
;----------------------------------------------------------------------------------------------------------------------
ini     macro           ;Inicia macro para ocupar segemnto de datos
        mov AX,data     ;Asigna la direccion de DATOS a AX
        mov DS,AX       ;y atraves de ax asigna la direccion de datos a ds
        endm            ;Termina macro para limpiar                  
                        
cls     macro           ;Inicia macro para limpiar pantalla
        mov AH,0FH      ;Funcion 0F (lee modo de video)
        int 10H         ;de la INT 10H a AH.
        mov AH,0        ;Funcion 0 (selecciona modo de video) de la INT 10H a AH
        int 10H         ;las 4 instrucciones limpian la pantalla.
        endm            ;Termina macro para limpiar pantalla
                        
fin     macro           ;Inicia macro para regresar el control a MS-DOS
        mov ah,4ch      ;Fucion 4ch (funcion de regresar el control a MS-DOS)
        int 21h         ;de la INT 21H a AH.
        endm            ;Termina macro para regresar el control a MS-DOS
                        
                        
print   macro string    ;Inicia macro para imprimir cadena de caracteres en pantalla
        lea DX,string   ;Asigna el contenido STRING al registro de memoria de DX 
        mov AH,09H      ;Funcion 09 (mensaje en pantalla) de la INT 21H a AH
        int 21H         ;Muestra mensaje en pantalla
        endm            ;Termina macro para cadena de caracteres en pantalla


gchar   macro           ;Inicia macro para guardar la entrada de datos
        mov AH,01H      ;Funcion 01 ( leer caracteres del teclado ) de la INT 21H a AH
        int 21H         ;guarda caracter ascii leido desde el teclado mostrando 
        endm            ;Termina macro para guardar caracter 

getchar macro           ;Inicia macro para guardar caracter 
        mov AH,07H      ;Funcion 07 (Imprimir un caracter en la pantalla y mantenerlo en la posicion del cursor  ) de la INT 21H a AH
        int 21h         ;Guarda caracter ascii leido desde el teclado sin mostrar 
        endm            ;Termina macro para guardar caracter 

printchar macro         ;Inicia macro para imprimir un solo caracter en pantalla
        mov AH,02H      ;Funcion 02 ( Mostrar un caracter en la pantalla sin mantenerlo en la posicion del cursor.) de la INT 21H a AH
        int 21H         ;de la INT 21H a AH
        endm            ;Termina macro para imprimir un solo caracter en pantalla

backspace macro         ;Inicia macro para borrar un caracter
        mov DL,08H      ;Asigna 08H (tecla borrar) a dl
        printchar       ;Invoca al macro "printchar"
        mov DL,20H      ;Asgina 20H (tecla espacio) a dl
        printchar       ;Invoca al macro "printchar"
        mov DL,08H      ;Asigna 08H (tecla borrar) a dl
        printchar       ;Invoca al macro "printchar"
        endm            ;Termina macro para borrar un caracter
                                                                
     
white macro                 ;Inicia macro para color blanco
        
        mov ax, 0600h       ;Asigna la funcion 06 a ah
        mov bh, 11111000B   ;Asigna los colores de fondo y letra en bh
        mov cx, 0000h       ;Asigna 0 a cx (posicion inicial)
        mov dh, 25          ;Asigna 25 a dh (fila final)
        mov dl, 80          ;Asigna 80 a dh (columna final)
        int 10h             ;con la int 10h asigna los colores seleccionados
endm                        ;Fin de la macro

blue macro                  ;Inicia macro para color azul
        mov ax, 0003h       ;Asigna el modo de video 03 de la 
        int 10h             ;Interrupcion 10h
        mov ax, 0600h       ;Asigna la funcion 06 a ah
        mov bh, 17h         ;Asigna los colores de fondo y letra en bh
        mov cx, 0000h       ;Asigna 0 a cx (posicion inicial)
        mov dh, 25          ;Asigna 25 a dh (fila final)
        mov dl, 80          ;Asigna 80 a dh (columna final)
        int 10h             ;con la int 10h asigna los colores seleccionados
endm                        ;Fin de la macro



;----------------------------------------------------------------------------------------------------------------------
 
;                                             Constante

;----------------------------------------------------------------------------------------------------------------------
                                  
endl  equ 10,13  ;Reemplaza todo endl en el codigo por 10,13 (salto de linea y retorno de carro)

;----------------------------------------------------------------------------------------------------------------------



        .model medium                                                       ;Inicio de memoria

        .stack 1000h                                                        ;Inicia segmento de pila

        .data                                                               ;inicia segmento de datos

mainHeader db 9,'MENU',endl                                                 ;Se define la variable mainHeader
           db 'Calculadora de: +,-,*,/',endl,'$'                            ;Se define la variable menu

menu       db '1) Suma',endl                                                ;Se define la variable suma
           db '2) Resta',endl
           db '3) Multiplicacion',endl  
           db '4) Division',endl                                            ;Se define la variable multiplicacion
           db endl,0A8H,'Que operacion desea hacer?: ','$'                  ;Mensaje de solicitud del usario para usar 1 suma y 2 salir

addHeader  db '1.Suma',endl,'$'                                             ;Se define la variable addHeader

sumHeader  db '2.Resta',endl,'$'                                            ;Se define la variable sumHeader

mulHeader  db '3.Multiplicacion',endl,'$'                                   ;Se define la variable mulHeader

divHeader  db '4.Division',endl,'$'                                         ;Se define la variable mulHeader

noZero     db 'Error! No se permite la division entre 0$'                   ;Se define la variable noCero

askNum1    db 'Deme el primer numero: ','$'                                 ;Se define la variable askNum1

askNum2    db endl,endl,'Ingrese el segundo numero: ','$'                   ;Se define la variable askNum2 

askNum3    db endl,endl,'Ingrese el segundo numero: -','$'                  ;Se define la variable askNum2

resultado  db endl,endl,'Resultado= ','$'                                   ;Se define la variable resultado

outOfRange db  'Error! Fuera de rango','$'                                  ;Se define la variable outOfRange

bye        db 9, 'Cerrando programa', endl, 9,'  Hasta Luego!$'             ;Se define la variable bye

continue   db endl,endl                                                     ;Se define la variable continue
           db endl,0A8H,'Desea continuar? ',endl, '1.Si   2.No $'           ;Mensaje de solicitud del usario para tecleaar enter 


number1    dw  0                ;Se define la variable number1
number2    dw  0                ;Se define la variable number2
tenTimes   dw  10               ;Se define la variable tenTimes
r1         dw  0               ;Se define la variable r2
;-----------------------------------------------------------------------------------------------------------  
;                                           Code 
;----------------------------------------------------------------------------------------------------------------------
    .code                       ;Inicia segmento de codigo

begin   proc far                ;Inicia proceso begin  
   ini                          ;Invoca al macro "ini"
   cls                          ;Invoca al macro "cls"
   mov ax, 0003h       ;Asigna el modo de video 03 de la 
   int 10h             ;Interrupcion 10h
;-----------------------------------------------------------------------------------------------------------
callmenu:                       ;Etiqueta "callmenu"
        cls                     ;Invoca al macro "cls" para limpiar la pantalla   
        white
   call showMenu                ;Llama al proceso "showMenu"
        gchar                   ;Invoca al macro "gchar"
       
option1:                        ;Etiqueta "option1"
   cmp  AL,'1'                  ;Compara si lo que esta en AL  igual a '1'
   jne  option2                 ;Salta a opcion2 si AL no es igual a '1'
   call addProc                 ;Si es igual llama al proceso "addProc"
   jmp  callmenu                ;Salta a la etiqueta "callmenu" si no es igual
                       
                       
option2:                        ;Etiqueta "option2"
   cmp  AL,'2'                  ;Compara si lo que esta en AL es igual a '2'
   jne  option3                 ;Salta a option3 cuando AL es igual a 2
   call subProc                 ;Si es igual llama al proceso "subProc" 
   jmp  callmenu                ;Salta a la etiqueta "callmenu" si no es igual a '1' o '2'
   

option3:                        ;Etiqueta "option 3"
   cmp  AL,'3'                  ;Compara si lo que esta en AL es igual a '3'
   jne  option4                 ;Salta a la etiqueta "mulProc" si es igual 
   call mulProc
   ;cls                          ;Invoca macro cls
   jmp  callmenu                ;Salta a la etiqueta "callmenu"si no es igual a ninguna de las anteriores

                                                 
option4:                       ;Etiqueta "option 4"
   cmp  AL,'4'                  ;Compara si lo que esta en AL es igual a '3'
   je   divProc                 ;Salta a la etiqueta "mulProc" si es igual 
   cls                          ;Invoca macro cls
   jmp  callmenu                ;Salta a la etiqueta "callmenu"si no es igual a ninguna de las anteriores

;---------------------------------------------------------------------------------------------------------

begin   endp                    ;finaliza el proceso begin

;---------------------------------------------------------------------------------------------------------

showMenu proc                   ;Inicia proceso "showMenu"
   print mainHeader             ;Invoca al macro "print" y envia como argumento a "mainHeader"
   print menu                   ;Invoca al macro "print" y envia como argumento a "menu"
   ret                          ;Retorna a la etiqueta que lo llamo
showMenu endp                   ;Termina proceso "showMenu"

;---------------------------------------------------------------------------------------------------------

contProc proc                   ;Inicia proceso "contProc"
    
    print continue              ;Invoca al macro "print" y envia como argumento a "continue"

  
        gchar                   ;Invoca al macro "gchar"
       
opS1:                           ;Etiqueta "opS1"
   cmp  AL,'1'                  ;Compara si lo que esta en AL  igual a '1'
   jne  opS2                    ;Salta a opcion2 si AL no es igual a '1'
   call   callmenu              ;Si es igual llama al proceso "callmenu"
                      
                       
opS2:                           ;Etiqueta "opS2"
   cmp  AL,'2'                  ;Compara si lo que esta en AL es igual a '2'
   je   exitS                   ;Salta a exit cuando AL es igual a 2
   cls                          ;Invoca al macro cls
   


exitS:                          ;Etiqueta "exitS"
  cls                           ;Invoca al macro "cls" para limpirza de pantalla
  print bye                     ;Ivoca la macro "print"y usa como argumento a "bye"    
  fin                           ;llama a la macro "fin" para regresar el control a MS-DOS
    
contProc endp                   ;Termina proceso "contProc"

;--------------------------------------------------------------------------------------------------------- 

addProc proc                    ;Inicia proceso "addProc"
        
        cls                     ;Invoca al macro "cls" para limpiar la pantalla
        white                   ;Invoca la macro "white"
   print addHeader              ;Invoca al macro "print" y envia como argumento a "addHeader"

   call inputNum                ;Llama al proceso "inputNum"    

                                ;//OPERACION DE SUMA 
                            
        mov ax,number1          ;Mueve el contenido de number1 a ax
        add ax,number2          ;Suma ax con el contenido de number2
        push ax                 ;Almacenamos el resultado de suma de ax
        print resultado         ;Invoca al macro "print" y envia como argumento a "resultado"
        pop ax                  ;Sacamos el resultado de la suma de ax
        call intTochar          ;Llama al proceso "intTochar"
       
        
                               
   ret                          ;Regresa a la etiqueta que lo llamo
  
addProc endp                    ;Termina proceso "addProc"

;----------------------------------------------------------------------------------------------------------


;---------------------------------------------------------------------------------------------------------
subProc proc                    ;Inicia proceso "subProc"
        
        cls                     ;Invoca al macro "cls" para limpiar la pantalla
        white                   ;Invoca la macro "white"
   print sumHeader              ;Invoca al macro "print" y envia como argumento a "addHeader"

   call inputNum2                ;Llama al proceso "inputNum"    

                                ;//OPERACION DE resta 
                            
        mov ax,number1          ;Mueve el contenido de number1 a ax
        sub ax,number2          ;restamos ax con el contenido de number2
        push ax                 ;Almacenamos el resultado de suma de ax
        print resultado         ;Invoca al macro "print" y envia como argumento a "resultado"
        pop ax                  ;Sacamos el resultado de la suma de ax
        call intTochar          ;Llama al proceso "intTochar"
       
        print continue          ;Invoca al macro "print" y envia como argumento a "continue"

  
        gchar                   ;Invoca al macro "gchar"
       
opR1:                           ;Etiqueta "option1"
   cmp  AL,'1'                  ;Compara si lo que esta en AL  igual a '1'
   jne  opS2                    ;Salta a opcion2 si AL no es igual a '1'
   call   callmenu              ;Si es igual llama al proceso "addProc"
                      
                       
opR2:                           ;Etiqueta "opR2"
   cmp  AL,'2'                  ;Compara si lo que esta en AL es igual a '2'
   je   exitS                   ;Salta a exit cuando AL es igual a 2
   cls                          ;Invoca al macro cls

exitR:                          ;Etiqueta "option2"
  fin                           ;macro fin

   cls                          ;Invoca al macro "cls"
   ret                          ;Regresa a la etiqueta que lo llamo
  
subProc endp                    ;Termina proceso "subProc"

;----------------------------------------------------------------------------------------------------------

mulProc proc                ;Inicia proceso "mulProc" 
        cls                 ;Invoca al macro cls
        white               ;Invoca la macro "white"
        print mulHeader     ;Invoca al macro "print" y envia como argumento a "mulHeader"

        call inputNum       ;Llama al proceso "inputNum"   

        ;//OPERACION DE MULTIPLICACION
        mov bl,0            ;Limpia bl
        mov ax,number1      ;Mueve el contenido de number1 en ax
        cwd                 ;Extiende a AX en DX
        idiv tenTimes       ;Divide entre 10 a AX
        cwd                 ;Extiende a AX en DX
        idiv tenTimes       ;Divide entre 10 a AX
        cwd                 ;Extiende a ax en dx
        imul number2        ;Multiplica ax por number2
      
        push ax             ;Guarda ax
        mov ax,number1      ;Copia el contenido de number1 en ax
        cwd                 ;Extiende ax en dx
        idiv tenTimes       ;Divide entre 10 a ax
        mov cl,dl           ;Copia a dl en cl
        cwd                 ;Exriende a ax en dx
        idiv tenTimes       ;Divide ax entre 10
        mov ch,dl           ;Copia a dl en ch

        mov al,ch           ;Copia ch en al
        cbw                 ;Extiende al en ax
        cwd                 ;Extiende ax en dx
        imul tenTimes       ;Divide entre 10 a ax
        add  al,cl          ;Suma cl a al
      


        mov  cx,ax          ;Mueve ax en cx
        mov  ax,number2     ;Copia el contenido de number2 en ax
        cwd                 ;Extiende ax en dx
        imul cx             ;Multiplica a cx por ax:dx
        cwd                 ;Extiende a ax en dx
        idiv tenTimes       ;Divide entre 10 a ax
        cwd                 ;Extiende a ax en dx
        idiv tenTimes       ;Divide entre 10 a ax

        mov cx,ax           ;Copia a ax en cx
        pop ax              ;Restaura ax
        add ax,cx           ;Suma cx a ax



        push ax             ;Guarda ax an la pila
        print resultado     ;Invoca al macro "print" y envia como argumento a "resultado"
        pop ax              ;Restaura ax

        call intTochar      ;Llama al proceso "intTochar"

        print continue      ;Invoca al macro "print" y envia como argumento a "continue"
        gchar               ;Invoca al macro "gchar"
        
               
opM1:                           ;Etiqueta "option1"
   cmp  AL,'1'                  ;Compara si lo que esta en AL  igual a '1'
   jne  opS2                    ;Salta a opcion2 si AL no es igual a '1'
   call   callmenu              ;Si es igual llama al proceso "addProc"
                      
                       
opM2:                           ;Etiqueta "opR2"
   cmp  AL,'2'                  ;Compara si lo que esta en AL es igual a '2'
   je   exitS                   ;Salta a exit cuando AL es igual a 2
   cls                          ;Invoca al macro cls

exitM:                          ;Etiqueta "option2"
  fin                           ;Macro fin

        cls                 ;Invoca al macro "cls"
        ret                 ;Regresa a la etiqueta que lo llamo

                            ;Regresa a la etiqueta que lo llamo
  
mulProc endp                ;Termina proceso "mulProc"

;----------------------------------------------------------------------------------------------------------
     
     divProc proc               ;Inicia proceso "divProc"
            cls
            white   
               
            print divHeader     ;Invoca al macro "print" y envia como argumento a "divHeader"

            call inputNum       ;Llama al proceso "inputNum"   
            
            test number2,0FFFFh ;Compara number2 con FFFFh

            jnz  noZeroDiv      ;Si no es cero salta a noZeroDiv


            print resultado     ;Invoca al macro "print" y envia como argumento a "resultado"


            
            print continue      ;Invoca al macro "print" y envia como argumento a "continue"
            gchar               ;Invoca al macro "gchar"
            cls                 ;Invoca al macro "cls"
            ret                 ;Regresa a la etiqueta que lo llamo

noZeroDiv:                  ;Etiqueta "noZeroDiv"
;OPERACION DE DIVISION
        mov ax,number1      ;Copia el contenido de number1 a ax
        cwd                 ;Extiende ax en dx
        idiv number2        ;Divide dx:ax por el contenido de number2
        push ax             ;Guarda ax en pila
        mov ax,dx           ;Copia a dx en ax
        imul tenTimes       ;Multiplica ax por 10
        cwd                 ;Extiende ax a dx
      
        idiv number2        ;Divide ax por el contenido de number2
        push ax             ;Guarda ax en pila
        mov ax,dx           ;Copia dx en ax
        imul tenTimes       ;Multiplica ax por 10
        cwd                 ;Extiende ax a dx
      
        idiv number2        ;divide ax por elcontenido de number2
        push ax             ;Guarda ax en pila
        mov ax,dx           ;Mueve el contenido de ax en dx
        imul tenTimes       ;Multiplica ax por 10
        cwd                 ;Extiende ax a dx


        mov cx,0            ;Limpia cx

        pop ax              ;Recupera de la pila ax
        add cx,ax           ;Suma ax a cx

        pop ax              ;Recupera de la pila ax
        imul tenTimes       ;Multiplica por 10 ax
        add cx,ax           ;Suma ax a cx

        pop ax              ;Recupera de la pila ax
        imul tenTimes       ;Multiplica por 10 ax
        imul tenTimes       ;Multiplica por 10 ax
        add cx,ax           ;Sima ax a cx

        mov ax,cx           ;Copia a cx en ax
       

        push ax             ;Guarda ax en pila
        print resultado     ;Invoca al macro "print" y envia como argumento a "resultado"
        pop ax              ;Recupera de la pila ax

        call intTochar      ;Llama al proceso "intTochar"

        
        
        print continue      ;Invoca al macro "print" y envia como argumento a "continue"
        gchar               ;Invoca al macro "gchar"
        
        
opD1:                           ;Etiqueta "option1"
   cmp  AL,'1'                  ;Compara si lo que esta en AL  igual a '1'
   jne  opS2                    ;Salta a opcion2 si AL no es igual a '1'
   call   callmenu              ;Si es igual llama al proceso "addProc"
                      
                       
opD2:                           ;Etiqueta "opR2"
   cmp  AL,'2'                  ;Compara si lo que esta en AL es igual a '2'
   je   exitS                   ;Salta a exit cuando AL es igual a 2
   cls                          ;Invoca al macro cls

exitD:                          ;Etiqueta "option2"
  fin                           ;Macro fin

            cls                 ;Invoca al macro "cls"
            ret                 ;Regresa a la etiqueta que lo llamo
        
divProc endp                ;Termina proceso "divProc"

;----------------------------------------------------------------------------------------------------------

inputNum proc               ;Inicia proceso "inputNum"
            print askNum1       ;Invoca al macro "print" y envia como argumento a "askNum1"
        call getdigit       ;Llama al proceso "getdigit"

        call toInt          ;Llama al proceso "toInt"
        mov number1,ax      ;copia ax en number1
              
        push bx             ;agrega bx a la pila

            print askNum2   ;Invoca al macro "print" y envia como argumento a "askNum2"
        call getdigit       ;Llama al proceso "getdigit"
              
        ;JUNTA EL FORMATO DE AMBOSNUMEROS
        pop dx              ;saca de la pila a dx
        cmp bh,dh           ;compara bh con dh
        jg  first           ;salta a first si es mayor
        mov bh,dh           ;copia dh en bh
first:                      ;Etiqueta "first"
              
        call toInt          ;Llama al proceso "toInt"
        mov number2,ax

            ret             ;Regresa a la etiqueta que lo llamo
inputNum endp               ;Termina proceso "inputNum"
 
 
 
inputNum2 proc               ;Inicia proceso "inputNum"
            print askNum1       ;Invoca al macro "print" y envia como argumento a "askNum1"
        call getdigit       ;Llama al proceso "getdigit"

        call toInt          ;Llama al proceso "toInt"
        mov number1,ax
              
        push bx

            print askNum3   ;Invoca al macro "print" y envia como argumento a "askNum2"
        call getdigit       ;Llama al proceso "getdigit"
              
        ;JUNTA EL FORMATO DE AMBOSNUMEROS
        pop dx
        cmp bh,dh
        jg  first
        mov bh,dh
first2:                      ;Etiqueta "first"
              
        call toInt          ;Llama al proceso "toInt"
        mov number2,ax

            ret             ;Regresa a la etiqueta que lo llamo
inputNum2 endp              ;Termina proceso "inputNum"
;--------------------------------------------------------------------------------------------------------------


toInt proc                  ;Inicia proceso "toInt"
        mov ax,0            ;Limpia ax
        mov dx,0            ;Limpia dx
        mov dl,ch           ;Copia ch a dl
        shr dl,4            ;Mueve los bits de dl 4 a la derecha
        add ax,dx           ;Suma dx a ax
        mul tenTimes        ;Multiplica por 10 ax
        mov dl,ch           ;Copia ch a dl
        shl dl,4            ;Mueve los bits de dl 4 a la izquierda
        shr dl,4            ;Mueve los bits de dl 4 a la derecha
        add ax,dx           ;Suma dx a ax
        mul tenTimes        ;Multiplica por 10 ax
        mov dl,cl           ;Copia cl a dl
        shr dl,4            ;Mueve los bits de fl 4 a la derecha
        add ax,dx           ;Suma dx a ax
        mul tenTimes        ;Multiplica por 10 ax
        mov dl,cl           ;Copia cl a dl
        shl dl,4            ;Mueve los bits de dl 4 a la izquierda
        shr dl,4            ;Mueve los bits de dl 4 a la derecha
        add ax,dx           ;Suma dx a ax
        test bl,1           ;Comprueba bl con 1
        jz toIntEnd         ;Si es zero salta a toIntEnd
        not ax              ;Niega a ax
        add ax,1            ;Suma 1 a ax
tointEnd:                   ;Etiqueta "tointEnd"
    
        ret                 ;Regresa a la etiqueta que lo llamo

toInt endp                  ;Termina proceso "toInt"


;-------------------------------------------------------------------------------------------------------------------------



intTochar proc          ;Inicia proceso "intTochar"
      
    cmp ax,0            ;Compara con 0 ax,
    jg  noNegat         ;Si es mayor salta a noNegat
    je  noNegat         ;Si es igual salta a noNegat
    not ax              ;Complemento de ax
    add ax,1            ;Suma 1 a ax
    push ax             ;Guarda ax en la pila
    mov dl,'-'          ;Mueve el caracter '-' a dl
    printchar           ;Invoca al macro "printchar"
    pop ax              ;Restaura ax
noNegat:                ;Etiqueta "noNegat"
    cmp ax,10000        ;Compara con 10000
    jl  okRange         ;Si es menor esta en el rango,
    print outOfRange    ;Invoca al macro "print" y envia como argumento a "outOfRange"
    ret                 ;Regresa al proceso que le llamo
             
okRange:                ;Etiqueta "okRange"
    mov cx, 4           ; Inicializa el contador del bucle
    
convertir:              ;Etiqueta "convertir" 
    xor dx, dx          ; Limpia dx
    div tenTimes        ; Divide ax entre 10
    or  dl, 030h        ; Convierte dl a ASCII
    push dx             ; Guarda el d?gito en la pila
    loop convertir      ; Repite hasta que cx sea 0


;---------------------------------------------------------------------------------
 
        ;Primer caracter puede ser cero , ese no se imprime
                        
        pop dx                    ;Restaura el primer caracter
        cmp dl,030h               ;Compara dl con 30h
        je  cerofirst             ;Salta a cerofirst si dl es igual a 030h
        printchar                 ;Invoca al macro "printchar"


cerofirst:                        ;Etiqueta "cerofirst"
        
        ;segundo caracter         
                        
        pop dx                    ;Restura el segundo caracter
        printchar                 ;Invoca al macro "printchar"

        mov cx, 02h               ;Mueve 02 a cx
        pop dx                    ;Saca de la pila a dx
        cmp dl, 30h               ;compara dl con 30h
        je  cleanStack            ;salta a cleanStack si es igual
        push dx                   ;Guarda el digito en la pila
        pop dx                    ;saca de la pila a dx
        mov ax, bx                ;asigna bx en ax
        pop bx                    ;saca de la pila a bx
        mov bh, dl                ;asigna bh en dl
        cmp bx, 3030h             ;compara bx con 3030h
        je noDecimal              ;salta a noDecimal si es igual 
        mov dl,'.'                ;Mueve el caracter '.' a dl
        printchar                 ;Invoca al macro "printchar"
        call decimalPrint         ;Llama a la etiqueta "decimalPrint"

cleanStack:                       ;Etiqueta "cleanStack"

        mov bl, dl                ;Mueve el valor de dl a bl
        pop dx                    ;Almacena a dx
        cmp dl, bl                ;Compara dl con bl
        je nostack                ;Salta a "nostack" si es igual
        shl dx, 8                 ;Realiza 8 movimientos a la izquierda en dx
        mov dl,'.'                ;Mueve el caracter '.' a dl
        printchar                 ;Invoca la macro "printchar"
        mov dl, bl                ;Mueve el valor de bl en dl
        printchar                 ;Invoca la macro "printchar"
        shr dx, 8                 ;Realiza 8 movimientos a la derecha en dx
        printchar                 ;Invoca la macro "printchar"
        call nostack              ;Llama a la etiqueta "nostack"

decimalPrint:                     ;Etiqueta "decimalPrint" 
        mov dl, bh                ;Mueve el valor de bh a dl
        cmp cl,1                  ;Compara cl con 1
        je secondDecPrint         ;Sata a SecondDecPrint si es igual
        printchar                 ;Invoca al macro "printchar"
        loop  decimalPrint        ;Imprime hasta que cx sea 0
       
secondDecPrint:                   ;Etiqueta "secondDecPrint"
        mov dl, bl                ;Mueve el valor de bl a dl
        cmp dl, 30h               ;Compara dl con 30h
        je nostack                ;Salta a la etiqueta nostack si es igual
        printchar                 ;Invoca la macro "printchar"
        loop secondDecPrint       ;Imprime hasta que cx sea 0

noDecimal:                        ;Etiqueta "noDecimal"
        mov bx, ax                ;asigna ax en bx  
        mov cl,2                  ;Mueve 2 a cl
        sub cl,bh                 ;Resta bh a cl
        test cl,0FFh              ;realiza una operacion logica "AND" bit a bit entre el registro CL y el valor hexadecimal FFh (255 en decimal).
        jz nostack                ;salta a nostack si cl es cero   

nostack:                          ;Etiqueta "nostack"

                                  ;Llama a correccion
        call contProc             ;Retorna al proceso que le llamo


intTOchar endp                    ;Termina proceso "intTochar"

;------------------------------------------------------------------------------------------------------------------
           
getdigit proc near                ;Inicia proceso "getdigit"
 
         mov bx,0                 ;Asigna 0 en el registro bx
         mov cx,0                 ;Asigna 0 en el registro cx       
         
         
         
initial_state:                    ;Inicio la equite "initial_state:" (la maquina de estado)

        getchar                   ;llama a la macro getchar

        cmp al,0Dh                ;Comprueba al de 0Dh (tecla enter) 
        jne  ne1                  ;Salta a n1 si al no es igual a 0Dh.
        ret                       ;retorna al procedimiento que le llamo

   ;/// un numero negativo///;   

ne1:                              ;Inicio ne1:

        cmp al,'-'                ;Comprueba al con '-' con por medio de una resta
        je  negative              ;Salta negative si al es menor que '-' (Marca el numero como negativo)
     
        
        cmp al,'.'                ;Comprueba '.' con Al, si es igual
        je  point_jump            ;Salta negative si al es menor que '.' (espera por un numero para guardarlo como decimal)

        
        ;Comprobacion del caracter ingresado, si es un decimal del 0 al 9
       
        cmp al,'0'                ;Comprueba AL con '0'
        jl  initial_state         ;Salta a initial_state si al es mayor que '0'
        
        cmp al,'9'                ;Comprueba AL con '9'
        jg  initial_state         ;Salta a initial_state si al es mayor que '9' 
        
        jmp interger              ;Salta a Interger 

interger:                         ;inicio interger (Guarda un digito)
        
        mov dl,al                 ;Mueve al a dl 
        printchar                 ;invoco la macro printchar (imprime un digito)

        
        ;----GUARDAR ENTERO----------
        ;Para dejar espacio en CH   
        
        shl ch,4                  ;mueve 4 bits a la izquierda
        sub al,30h                ;le resta 30 a al (convierte a bcd desempaquetado )
        add ch,al                 ;suma al en ch
        
        ;----------------------------

        test ch,0F0h              ;realiza la operecion test de ch a 0f0h
        jz  interger_get          ;saltamos a interger_get si ch es cero (estamos guardando el digito 1)
        
                                  ;Si no es cero, guardamos el segundo decimal
        jmp point                 ;Salta a la etiqueta point 
    
    
                                       
interger_get:                     ;inicia la etiqueta interger_get 
        
        getchar                   ;Llama a la macro getchar
                         
        cmp al,0Dh                ;Compara al con 0Dh
        jne  ne3                  ;salta a ne3  si al no es igual 0Dh
        
        ret                       ;Retorna al proceso que lo llamo

ne3:                              ;iniciamos con la etiqueta ne3

        cmp al,08h                ;Compreuba al con  "08h" (la tecla de retroseso)
        
        je  interger_return       ;Salta a interger_return Si al es igual a "08h" 
   
   
        cmp al,'.'                ;Comprueba AL con '.' 
        je  point                 ;salta a point si al es igual a '.' 
        
        
        ;Comprobacion del caracter ingresado, si es un decimal del 0 al 9
        ;Si al < 30 y al > 39 el caracter no es valido  
        
        cmp al,'0'                ;Compara AL con '0' 
        jl  interger_get          ;Salta a interger_get si al es mayor a '0'.
        cmp al,'9'                ;Compara AL con '9'
        jg  interger_get          ;Salta a interger_get si al es menor a '9'.
                                  
                                  
        jmp interger              ;salta a interger (guarda el digito).                                                   
                                                         

interger_return:                  ;iniciamos la etiqueta integer_return

        backspace                 ;Elimina el caracter de la consola
       
        shr ch,4                  ;mueve 4 bits a la derecha
  
        ;DEBE DE REGRESAR A UN ESTADO DEPENDIENDO DE LAS SIGUIENTES CONDICIONES
       
        
        test ch,00Fh              ;realiza la operacion test de ch con 00Fh 
        jnz interger_get          ;Salta a interger_get Si ch no es cero
             
        test bl,1                 ;Comprueba bl con 1 por medio de test (si hay marca de numero negativo)     
        
        jnz negative_get          ;Salta a negative_get si bl no es igual a cero
        
        jmp initial_state         ;Salta a initial_state
        
point_jump:                       ;Iniciamos la etiqueta point_jump 
        MOV AH, 02h               ; Funcion 2 de la int 21 
        MOV DL, '0'               ; Asigna 0 ASCII a DL
        INT 21h                   ; Con la int 21h imprime el caracter


        jmp point                 ;salta a la etiqueta point

negative:                         ;Iniciamos la etiqueta negative    (marcar un numero como negativo)  
        mov dl,al                 ;Mueve al a dl 
        printchar                 ;Invocamos macro printchat
   
        mov bl,1                  ;Asigna 1 en bl
        
negative_get:                     ;Iniciamos la etiqueta negative_get
                    
        getchar                   ;Invocamos macro getchar                                                             
        
;-----------------------------------------------------------------------------------------------------------------------
        
        cmp al,0Dh                ;Comparar al con 0Dh(retorno de carro) 
        jne  ne2                  ;Salta a ne2 al no es igual a 0DH
        ret                       ;Regresa a el procedimiento que le llamo
ne2:                              ;iniciamos la etiqueta ne2
        cmp al,08h                ;Comprueba al  con 08h (tecla return)
        je  negative_return       ;salta a negative_return si al es igual a 08h
   
        cmp al,'.'                ;Compara al con '.', 
        je point                  ;Salta a point si al es igual '.'

        ;Comprobacion del caracter ingresado, si es un decimal del 1 al 9
        ;Si al < 31 y al > 39 el caracter no es valido  
        
        cmp al,'0'                ;Compara al con '1'
        jl  negative_get          ;Salta a negative_get si al en menor que '1'
        cmp al,'9'                ;Compara al con '9' 
        jg  negative_get          ;salta a negative_get si al es mayor que '9'
                                  
        jmp interger              ;Salta a interger (Guardar el digito)

negative_return:                  ;Iniciamos la etiqueta negative_return

        backspace                 ;llama a macro backspace
        mov bl,0                  ;asigna 0 a bl
        jmp initial_state         ;Salta a initial_state 

point:                            ;iniciamos la etiqueta point
        mov dl,'.'                ;Mueve '.' en dl
        printchar                 ;llamamos la macro printchar 

point_get:                        ;Iniciamos la etiqueta point_get
        getchar                   ;llama la macro getchar

        cmp al,0Dh                ;Compara al con 0Dh 
        jne  ne4                  ;Salta a ne4 si al  si no es igual a 0Dh
        ret                       ;Retorna al procedimiento que le llamo
ne4:
        cmp al,08h                ;Comprueba al con 08h 
        je  point_return          ;Salta a point_return si al es igual a 08h
       
        ;Comprobacion del caracter ingresado, si es un decimal del 0 al 9
        ;Si al < 30  y al > 39 el caracter no es valido  
        
        cmp al,'0'                ;Compara al con '0' 
        jl  point_get             ;Salta a point_get si al es menor que '0' 
        cmp al,'9'                ;Compara al con '9' 
        jg  point_get             ;Salta a point_get si al es mayor que '9'
                                  
        jmp decimal               ;Salta a decimal (Guardar el primer decimal)

point_return:                     ;Iniciamos la etiqueta point_return
       
        backspace                 ;Llamamos a la macro Backs?ce
       
        test ch,0FFh              ;Compara ch con FF mediante la operacion test
        jnz to_interger           ;Salta a to_integer Si ch es 0,
        test bl,1                 ;Compara bl con 1  mediante la operacion test
        jnz negative_get          ;salta a negative_get si bl no es 0 
        jmp initial_state         ;salta inicial_state


to_interger:                      ;iniciamos la etiqueta to_interger  
        jmp interger_return       ;salta a interger_return


decimal:                          ;iniciamos la etiqueta decimal
       
       ;Imprime el digito que se va a guardar
        
        mov dl,al                 ;Mueve al a dl 
        printchar                 ;Llama a la macro printchar (imprime el digito)

        ;----Decimal 1-------
        sub al,30h                ;resta 30h a al (convierte a bcd desempaquetado)
        add cl,al                 ;suma al a cl   (Mueve decimal a ch)
        shl cl,4                  ;Mueve los bits de dl 4 a la izquierda
        add bh,1                  ;suma 1 a bh
        ;----------------------------

decimal_get:                      ;Iniciamo la etiqueta decimal_get
   
        getchar                   ;llama la macro getchar       

        cmp al,0Dh                ;Compara al con 0Dh
        jne  ne5                  ;salta ne5 Si AL no es igual0Dh,
        ret                       ;Retorna a el procedimiento que le llamo

ne5:                              ;Iniciamos la etiqueta ne5
        cmp al,08h                ;Compara al con 08h
        je  decimal_return        ;Salta a decimal_return si al es igual 08h
   
        ;Comprobacion del caracter ingresado, si es un decimal del 0 al 9
        ;Si al < 30  y al > 39 el caracter no es valido  
        cmp al,'0'                ;Compara al con '0' 
        jl  decimal_get           ;Salta a decimal_get si al en menor que '0'.
        cmp al,'9'                ;Compara al con '9' 
        jg  decimal_get           ;Salta a decimal_get si al en mayor que '9'
                                  
        jmp decimal_2             ;salta a decimal_2 (Guardar el decimal 2)

decimal_return:                   ;iniciamos la etiqueta decimal_return

        backspace                 ;llamamos a la macro backspace
        
        ;-----UNSTORE DIGIT-----
        shl cl,4                  ;mueve los bits de cl 4 a la izquierda
        sub bh,1                  ;resta 1 a bh
       
        jmp point_get             ; salta a point_get

decimal_2:                        ;iniciamos la etiqueta decimal_2

        mov dl,al                 ;Mueve al a dl 
        printchar                 ;llama a la macro printchar 

        ;----STORE Cl Decimal 2-------
        sub al,30h                ;Resta 30h a al (convierte a bcd desempaquetado)
        add cl,al                 ;Suma al a cl 
        add bh,1                  ;Suma 1 a bh 
        ;----------------------------

decimal_2_get:                    ;Iniciamos la etiqueta decimal_2_get  
        getchar                   ;llama la macro getchar

        cmp al,0Dh                ;Compara al con 0Dh 
        jne  ne6                  ;Salta a ne6 SI Al no es igual a 0Dh
        ret                       ;retorna 
ne6:                              ;iniciamos la etiqueta ne6
        cmp al,08h                ;Comprueba al con 08h 
        je  decimal_2_return      ;salta a decimal_2_return si al es igual a 08h
       
        jmp decimal_2_get         ;salta a decimal_2_get
        
decimal_2_return:                 ;iniciamos la etiqueta decimal_2_return

        backspace                 ;llamamos a la macro backspace
       
        ;-----UNSTORE DECIMAL 2-----
        shr cl,4                  ;mueve los bits de cl 4 a la derecha
        shl cl,4                  ;mueve los bits de cl 4 a la izquiera
        sub bh,1                  ;resta 1 a bh
        ;-----------------------------
   
        jmp decimal_get           ;Salta a decimal_get

getdigit endp                     ; terminamos el proceso de getdigit