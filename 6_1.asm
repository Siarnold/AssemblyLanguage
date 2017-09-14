NAME    EX6_1

DATA    SEGMENT
MSG0 DB 0DH, 0AH, '$'
MSG1 DB '1 = sawtooth' ,0DH, 0AH, '$'
MSG2 DB '2 = triangle' ,0DH, 0AH, '$'
MSG3 DB '3 = sin'      ,0DH, 0AH, '$'
MSG4 DB '4 = quit'     ,0DH, 0AH, '$'
SIN DB  128,    131,    134,    137,    140,    143,    146,    149,    152,    155,    158,    161,    164,    167,    170,    173
    DB  176,    179,    182,    185,    187,    190,    193,    195,    198,    201,    203,    206,    208,    210,    213,    215
    DB  217,    219,    222,    224,    226,    228,    230,    231,    233,    235,    236,    238,    240,    241,    242,    244
    DB  245,    246,    247,    248,    249,    250,    251,    251,    252,    253,    253,    254,    254,    254,    254,    254
    DB  255,    254,    254,    254,    254,    254,    253,    253,    252,    251,    251,    250,    249,    248,    247,    246
    DB  245,    244,    242,    241,    240,    238,    236,    235,    233,    231,    230,    228,    226,    224,    222,    219
    DB  217,    215,    213,    210,    208,    206,    203,    201,    198,    195,    193,    190,    187,    185,    182,    179
    DB  176,    173,    170,    167,    164,    161,    158,    155,    152,    149,    146,    143,    140,    137,    134,    131
    DB  128,    124,    121,    118,    115,    112,    109,    106,    103,    100,    97,     94,     91,     88,     85,     82
    DB  79,     76,     73,     70,     68,     65,     62,     60,     57,     54,     52,     49,     47,     45,     42,     40
    DB  38,     36,     33,     31,     29,     27,     25,     24,     22,     20,     19,     17,     15,     14,     13,     11
    DB  10,     9,      8,      7,      6,      5,      4,      4,      3,      2,      2,      1,      1,      1,      1,      1
    DB  1,      1,      1,      1,      1,      1,      2,      2,      3,      4,      4,      5,      6,      7,      8,      9
    DB  10,     11,     13,     14,     15,     17,     19,     20,     22,     24,     25,     27,     29,     31,     33,     36
    DB  38,     40,     42,     45,     47,     49,     52,     54,     57,     60,     62,     65,     68,     70,     73,     76
    DB  79,     82,     85,     88,     91,     94,     97,     100,    103,    106,    109,    112,    115,    118,    121,    124
DATA    ENDS
STACK    SEGMENT PARA STACK
    DB    100 DUP(?)    
STACK    ENDS

; macro print messages
PRINTMSG MACRO NUM
    PUSH AX
    PUSH DX
    MOV AH,9
	MOV DX,OFFSET MSG&NUM
	INT 21H
    POP DX
    POP AX
ENDM

CODE    SEGMENT
    ASSUME    CS:CODE,DS:DATA,ES:DATA,SS:STACK

; main
START:
    MOV AX,DATA
    MOV DS,AX        
    MOV ES,AX            
    
    PRINTMSG 1
    PRINTMSG 2
    PRINTMSG 3
    PRINTMSG 4
    PRINTMSG 0
    
    CALL CHECK_INPUT
    
; check input
CHECK_INPUT PROC NEAR
    MOV AH,0
    INT 16H
    CMP AL,'1'
    JZ SAWTOOTH
    CMP AL,'2'
    JZ TRIANGLE
    CMP AL,'3'
    JZ SINWAVE
    CMP AL,'4'
    JZ  QUIT
    RET
CHECK_INPUT ENDP

; quit 
QUIT:
    PRINTMSG 4
    MOV AH,4CH
    INT 21H

; delay for a period
DELAY  PROC    NEAR
    PUSH AX        
    MOV AX,0FFFFH
DELAY_1: DEC AX
    JNZ DELAY_1
    POP AX
    RET
DELAY ENDP 
    
; sawtooth wave
SAWTOOTH:
    PRINTMSG 1
    MOV DX,280H
    MOV BL,0
SAW_1: MOV AL,BL
    OUT DX,AL
    CALL DELAY
    INC BL;auto overflow
    
    MOV AH,1
    INT 16H;CHECK INPUT
    JZ SAW_1
    CALL CHECK_INPUT
        
; triangle wave 
TRIANGLE:
    PRINTMSG 2
    MOV DX,280H
    MOV BL,0
;//INC BL
TRI_1: MOV AL,BL
    OUT DX,AL
    CALL DELAY
    INC BL
    
    MOV AH,1
    INT 16H;CHECK INPUT
    JZ TRI_NEXT1
    CALL CHECK_INPUT
TRI_NEXT1:    
    CMP BL,0FFH
    JNZ TRI_1
;//DEC BL    
TRI_2: MOV AL,BL
    OUT DX,AL
    CALL DELAY
    DEC BL
    
    MOV AH,1
    INT 16H;CHECK INPUT
    JZ TRI_NEXT2
    CALL CHECK_INPUT
TRI_NEXT2:    
    CMP BL,0
    JNZ TRI_2
    JMP TRI_1

; sine wave
SINWAVE:
    PRINTMSG 3
    MOV DX,280H
SIN_1:
    MOV CX,256
    LEA SI,SIN
SIN_2:    
    MOV AL,[SI]
    OUT DX,AL
    CALL DELAY
    INC SI
    DEC CX
    
    MOV AH,1
    INT 16H;CHECK INPUT
    JZ SIN_NEXT2
    CALL CHECK_INPUT
SIN_NEXT2:
    CMP CX,0
    JZ SIN_1
    JMP SIN_2

CODE ENDS
END START
