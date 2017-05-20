DATA    SEGMENT
DATA    ENDS ; data segment
STACK   SEGMENT PARA STACK
        DW 128 DUP(?)
STACK   ENDS ; stack segment

CODE    SEGMENT
        ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACK
START:  MOV     AX, DATA
        MOV     DS, AX
        MOV     ES, AX
        MOV     AX, STACK
        MOV     SS, AX ; initialize
              
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
 
        MOV     AH, 4CH
        INT     21H ; end the program
CODE    ENDS
END     START
