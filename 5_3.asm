DATA  SEGMENT
    MSG DB 'Hello_this_is_Siarnold!', '$'
    DIVID DW 60H         ; Baud rate = 1200
DATA  ENDS

STACK SEGMENT PARA STACK
    DW 128 DUP(?)
STACK  ENDS

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
    
    ; MOV  DX,3F8H 
    ; OUT  DX,AL ; strange, check with datiao
    CMP  AL, 'S'      ;if not 'S', CHECK_CHAR
    JZ   SENDING

; check for '\n'    
CHECK_CHAR:  
    CMP  AL, 0DH     
    JNE  SEND_CHAR   ; if AL != '\n', SEND_CHAR
    MOV  AL, 0AH      ; else, '\r'
    MOV  AH, 0EH
    INT  10H
    JMP WAIT_FOR  
    
RECEIVE:  
    MOV  DX, 3F8H
    IN   AL, DX
    CMP  AL, 20H      ; if AL == ' ', end
    JZ   FINISH
    MOV  AH, 0EH      ;show AL
    INT  10H
    
    CMP  AL, 'R'      ;if 'R', SENDING
    JZ   SENDING
    JMP  CHECK_CHAR 

SENDING:
    PUSH AX
    PUSH DX ; protect scene 
    LEA  SI, MSG

SENDING_LOOP:
    MOV  DX, 3FDH     ;read line status reg
    IN   AL, DX
    TEST AL, 01000000B ;if send-shift-reg is not empty, SENDING_LOOP
    JZ   SENDING_LOOP
    TEST AL, 00100000B ;if send-reg is not empty, SENDING_LOOP
    JZ   SENDING_LOOP
    MOV  AL, [SI]
    CMP  AL, '$'       ;stop sending when '$'
    JZ   SENDING_FINISH
    MOV  DX, 3F8H      ;send AL
    OUT  DX, AL
    INC  SI ; send next char
    JMP  SENDING_LOOP
    
SENDING_FINISH:
    POP  DX
    POP  AX ; restore scene
    JMP  WAIT_FOR  
    
ERR:
    MOV  DX, 3F8H
    IN   AL, DX ; read the error char to continue
    MOV  AL, '?'
    MOV  AH, 14
    INT  10H
    JMP  WAIT_FOR
    
FINISH:
    MOV AH,4CH   ; end
    INT 21H
    
CODE    ENDS
END     START