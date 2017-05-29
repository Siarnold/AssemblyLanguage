DATA SEGMENT 
    DIVID DW 60H; Baud rate = 1200
DATA ENDS

STACK SEGMENT PARA STACK  
    DW 128 DUP(?)
STACK ENDS

CODE SEGMENT 
    ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACK

START:
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX ; initialize

    MOV AL, 80H 
    ; DLAB = 1 to visit the divid register
    MOV DX, 3FBH
    OUT DX, AL
    MOV AX, DIVID ; get dividor   
    MOV DX, 3F8H
    OUT DX, AL
    MOV AL, AH
    MOV DX, 3F9H
    OUT DX, AL
    ; set Baud rate
    
    ; set line control reg 
    MOV AL, 00001011B 
    ;DLAB = 0, odd check, 1 stop bit, 8 data bits
    MOV DX, 3FBH
    OUT DX, AL
    
    ; set MODEM control reg 
    MOV AL, 00000011B 
    ;MODEM normal
    MOV DX, 3FCH
    OUT DX, AL
    
    ; set interrupt control reg
    MOV AL, 0 ; mask all interrupts
    MOV DX, 3F9H	 
    OUT DX, AL
    
WAIT_FOR:
    MOV DX, 3FDH ;read line status reg 
    IN  AL, DX
    TEST AL, 00011110B ;if error
    JNZ ERR
    TEST AL, 00000001B ;if ready ro receive
    JNZ RECEIVE
    TEST AL, 00100000B ;if not ready to send
    JZ  WAIT_FOR

    ; get keyboard input
    MOV  AH, 1
    INT  16H         ; BIOS to read in
    JZ   WAIT_FOR   ; if no input, WAIT_FOR
    MOV  AH, 1        ; get char and echo
    INT  21H
    CMP  AL, 0DH     
    JNE  SEND_CHAR   ; if AL != '\n', SEND_CHAR
    MOV  AL, 0AH      ; else, '\r'
    MOV  AH, 0EH
    INT  10H

SEND_CHAR:   
    MOV  DX, 3F8H     ; send AL
    OUT  DX, AL
    CMP  AL, 20H      ; if AL == ' ', end
    JNZ  WAIT_FOR  ; else
    MOV  AH, 4CH
    INT  21H

; receive   
RECEIVE:  
    MOV  DX, 3F8H
    IN   AL, DX
    CMP  AL, 20H      ; if AL == ' ', end
    JNZ  SHOW       ; else show char
    MOV  AH, 4CH      
    INT  21H

SHOW:
    MOV  AH, 0EH
    INT  10H    ; show AL
    CMP  AL, 0DH      
    JNZ  WAIT_FOR   ; if AL != '\n' -> WAIT_FOR
    MOV  AL, 0AH      ; else, '\r' -> WAIT_FOR
    MOV  AH, 0EH      
    INT  10H
    JMP  WAIT_FOR
    
ERR:
    MOV  DX, 3F8H
    IN   AL, DX ; read the error char to continue
    MOV  AL, '?'
    MOV  AH, 14
    INT  10H
    JMP  WAIT_FOR
CODE    ENDS
END     START