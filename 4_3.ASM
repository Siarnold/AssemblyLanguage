DATA    SEGMENT               
    NUM DB 0
    ; the messages
    MEG1 DB 'One click is received.',0DH,0AH,'$'
    MEG2 DB 'Ten clicks have been received.',0DH,0AH,'$'
    KEEP_CS DW 0 ; store CS
    KEEP_IP DW 0 ; store IP
DATA    ENDS
  
STACK   SEGMENT PARA STACK       
        DW 128 DUP(?)
STACK   ENDS
  
CODE    SEGMENT               
        ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACK
    
INTR    PROC    ; interrupt procedure        
        INC     NUM
        MOV     DX, OFFSET MEG1 
        MOV     AH, 9
        INT     21H ; output MEG1
        MOV     AL, 20H
        OUT     20H, AL
        IRET
INTR    ENDP

START:  MOV     AX, DATA
        MOV     DS, AX
        MOV     ES, AX
        MOV     AX, STACK
        MOV     SS, AX ; initialize
                  
        MOV     AH, 35H      
        MOV     AL, 0BH ; the INT n number
        INT     21H
        MOV     KEEP_IP, BX
        MOV     KEEP_CS, ES ; store the original CS:IP
           
        PUSH    DS    
        MOV     DX, OFFSET INTR
        MOV     AX, SEG INTR
        MOV     DS, AX
        MOV     AH, 25H
        MOV     AL, 0BH
        INT     21H
        POP     DS ; load the new procedure into INT 0BH
           
        IN      AL, 21H      
        AND     AL, 11110111B
        OUT     21H, AL ; activate the IRQ3 from masking
       
        MOV     DX, 283H ; CS to 280H
        MOV     AL, 00110111B ; DEC count
        OUT     DX, AL ;initialize CNT0
        MOV     DX, 280H
        MOV     AL, 0
        OUT     DX, AL ; first lower byte
        MOV     AL, 10H
        OUT     DX, AL ; then higher byte
              
        MOV     DX, 283H
        MOV     AL, 01110111B
        OUT     DX, AL ; initialize CNT1
        MOV     DX, 281H
        MOV     AL, 0
        OUT     DX, AL ; lower byte 
        MOV     AL, 10H
        OUT     DX, AL ; higher byte
       
        STI ; set interrupt enable
NEXT:   CMP     NUM, 10      
        JNZ     NEXT ; count 10 times

        MOV     DX, OFFSET MEG2          
        MOV     AH,9
        INT     21H ; output message 2

        IN      AL, 21H
        OR      AL, 00001000B
        OUT     21H, AL ; shutdown the IRQ3

        PUSH    DS      
        MOV     DX, KEEP_IP
        MOV     AX, KEEP_CS
        MOV     DS, AX
        MOV     AH, 25H
        MOV     AL, 0BH
        INT     21H ; restore the original interrupt procedure
        POP     DS
               
        MOV     AH,4CH    
        INT     21H ; end the program
CODE    ENDS
END     START
