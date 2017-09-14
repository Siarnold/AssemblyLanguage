NAME EX7_2_2
DATA SEGMENT
    ADDRESS EQU 0280H
    KEEP_IP DW ?
    KEEP_CS DW ?
    DAT DB ?
    OUTPUT DB ' ',0DH,0AH,'$'
    KEY DW 0F00FH
    INPUT DW ?
    OK DB 'OK',0DH,0AH,'$'
DATA ENDS
STACK SEGMENT PARA STACK
      DB 100 DUP(?)
STACK ENDS
CODE SEGMENT
  ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK 
MAIN PROC FAR
START: MOV AX,DATA
       MOV DS,AX
       MOV ES,AX
; protect interrupt vector
       PUSH DS
       MOV AH,35H                  
       MOV AL,0BH             
       INT 21H                   
       MOV KEEP_IP,BX            
       MOV KEEP_CS,ES            
       POP DS                                     
; change interrupt vector IRQ3                          
       PUSH DS                    
       MOV DX,OFFSET INTR        
       MOV AX,SEG INTR           
       MOV DS,AX
       MOV AH,25H
       MOV AL,0BH                   
       INT 21H
       POP DS  
; initialize 8259
       IN AL,21H
       AND AL,0F7H
       OUT 21H,AL                          
; initialize 8255
    MOV AL,10110000B; method 1, A input
    MOV DX,ADDRESS+3    
    OUT DX,AL
    MOV AL,00001001B
    OUT DX,AL
; main 
MAIN0:
       CMP DAT,0FFH
       JNE MAIN0
ENDD:        
; restore interrupt vector   
    CLI                       
    PUSH DS                    
    MOV DX,KEEP_IP            
    MOV AX,KEEP_CS            
    MOV DS,AX
    MOV AH,25H
    MOV AL,0BH                 
    INT 21H                    
    POP DS  
    MOV AH,4CH
    INT 21H
    RET
MAIN ENDP

INTR    PROC FAR; interrupt vector
    STI
    MOV DX,ADDRESS    
    IN AL,DX
    MOV DAT,AL
    CMP DAT,0FFH
    JE NEXT
    ; display
       LEA SI,OUTPUT
       MOV [SI],AL
       LEA DX,OUTPUT
       MOV AH,9
       INT 21H
       LEA SI,INPUT
       MOV AH,[SI+1]
       MOV [SI],AH
       MOV AH,DAT
       MOV [SI+1],AH
       MOV CX,KEY
       CMP CX,INPUT
       JNE NEXT
       LEA DX,OK
       MOV AH,9
       INT 21H
NEXT:
    MOV AL,20H
    OUT 0A0H,AL
    OUT 20H,AL
    IRET
INTR ENDP
CODE ENDS
END START