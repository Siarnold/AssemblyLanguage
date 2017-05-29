DATA SEGMENT
    DIVID DW 60H; Baud rate = 1200
    MSG1 DB ' Get: ', '$'
    MSG2 DB ' Error! ', 0DH, 0AH, '$'
    MSG3 DB ' Program terminated.', 0DH, 0AH, '$'
    MSG4 DB 0DH, 0AH, '$'
DATA ENDS ; data segment

STACK SEGMENT PARA STACK
    DB 128 DUP(?)
STACK ENDS ; stack segment

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
    MOV AL, 00010011B 
    ;MODEM self-check
    MOV DX, 3FCH
    OUT DX, AL
    
    ; set interrupt control reg
    MOV AL, 0 ; mask all interrupts
    MOV DX, 3F9H	 
    OUT DX, AL
    
; WAIT_FOR
WAIT_FOR:
    MOV DX, 3FDH ;read line status reg 
    IN  AL, DX
    TEST AL, 00011110B ;if error
    JNZ ERR
    TEST AL, 00000001B ;if ready ro receive
    JNZ RECEIVE
    TEST AL, 00100000B ;if not ready to send
    JZ  WAIT_FOR
    
    ; send character
    MOV AH, 1
    INT 21H  ;get keyboard input and echo, store in AL
    CMP AL, 20H ;if AL = SPACE -> STOP_WORK
    JE  STOP_WORK
    MOV DX, 3F8H
    OUT DX, AL  ;else send AL
    JMP WAIT_FOR

; RECEIVE
RECEIVE:
    LEA DX, MSG1
    MOV AH, 9
    INT 21H  ;show message
    MOV DX, 3F8H
    IN  AL, DX ; read char 
    MOV DL, AL ; show AL
    MOV AH, 02H 
    INT 21H
    LEA DX, MSG4 ; carriage returns and line feeds
    MOV AH, 09H
    INT 21H
    JMP WAIT_FOR

; Error
ERR: 
    MOV　DX, 3F8H
    IN AL, DX ; read the error char to continue
    LEA DX, MSG2 ; show message
    MOV AH, 9
    INT 21H
    JMP WAIT_FOR
    
; Terminate
STOP_WORK:
    LEA DX, MSG3 ; show message
    MOV AH, 9
    INT 21H
    MOV AH, 4CH ; end
    INT 21H
CODE    ENDS
END     START