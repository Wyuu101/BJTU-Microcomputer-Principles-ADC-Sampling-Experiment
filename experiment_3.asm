DATA SEGMENT
    LIST1 DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH;��С��������
    LIST2 DB 0BFH,86H,0DBH,0CFH,0E6H,0EDH,0FDH,87H,0FFH;��С���������
I0 EQU 298H
I1 EQU 299H
I2 EQU 29AH
PORTA EQU 288H        ;����
PORTB EQU 289H
PORTC EQU 28AH
DATA ENDS
STACK1 SEGMENT  STACK       
    DW 100 DUP(0)  
STACK1 ENDS 
CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK1
START: MOV AX,DATA
       MOV DS,AX
       MOV DX,028BH
       MOV AL,10000000B
       OUT DX,AL
;------------------------------I0����------------------------------
L1:   MOV AL,00
      MOV DX,I0
      OUT DX,AL
      MOV CX,0FFH           
DELAY:LOOP DELAY
      MOV DX,I0
      IN AL,DX         ;����0������
      MOV DX,PORTC
      OUT DX,AL
      MOV BX,2        ;100*5/256Լ����2,5/256Լ����0.0195��ȡ������Ҫ��100��Լ����2
      MUL BL
      MOV BL,100
      DIV BL           ;�õ���������AH��ʮλ����λ������AL
      
      MOV CH,AL       ;ʮλ����λ����CH
      MOV CL,AH
;------------------------------I0��λLED��ʾ����------------------------------
    MOV DX,PORTB        ;B��λѡ,
    MOV AL,10000000B           
    OUT DX,AL
    MOV DX,PORTA            ;A�ڶ�ѡ
    MOV BX,0000H
    MOV BL,CH
    MOV BH,0
    MOV AL,LIST2[BX]              ;�����С��������֣�led��ʾ
    OUT DX,AL  
    CALL DELAY1
    MOV DX,288H  
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;------------------------------I0��λ��Ļ��ʾ����------------------------------
    MOV AL,CH
    ADD AL,30H                
    MOV DL,AL
    MOV AH,02H                   ;�������ʮλ��ʾ����Ļ��
    INT 21H
    MOV DL,46             ;���С���㣬��ʾ����Ļ��
    MOV AH,02H
    INT 21H
;------------------------------    
    MOV AL,CL
    MOV BX,10
    MUL BL
    MOV BX,100
    DIV BL
    MOV CL,AL                     ;�õ���λ��С�����֣�����
    MOV CH,AH
;------------------------------I0С����ʮ��λ��LED��ʾ����------------------------------
    MOV DX,PORTB        ;B��λѡ,
    MOV AL,01000000B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CL
    MOV BH,0
    MOV AL,LIST1[BX]              ;�����С��������֣�led��ʾ
    OUT DX,AL
    CALL DELAY1                    ;��ʱ��ʾ
    MOV DX,288H    
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;------------------------------I0С����ʮ��λ����Ļ��ʾ����------------------------------
    MOV AL,CL
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H
        
    MOV BX,10
    MOV AH,0             ;��AH����
    MOV AL,CH
    DIV BL
    MOV CL,AL            ;ȡ�ٷ�λ
        
    MOV DL,32                      ;����ո�
    MOV AH,02H
    INT 21H

      
      
;------------------------------I1����------------------------------
L2: MOV AL,00
    MOV DX,I1
    OUT DX,AL
    MOV CX,0FFH           
DELAY2:
	LOOP DELAY2
    MOV DX,I0
    IN AL,DX
    MOV BX,2
    MUL BL
    MOV BL,100
    DIV BL
    MOV CH,AL
    MOV CL,AH                     ;�����ݴ���cx   
;------------------------------
    MOV DX,PORTB
    MOV AL,00010000B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CH
    MOV BH,0
    MOV AL,LIST2[BX]
    OUT DX,AL
    CALL DELAY1
    MOV DX,288H    
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;--------------------------------  
    MOV AL,CH
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H
    MOV DL,46
    MOV AH,02H
    INT 21H      
    MOV AL,CL    
    MOV BX,10
    MUL BL
    MOV BX,100 
    DIV BL
    MOV CL,AL
;---------------------- 
    MOV DX,PORTB
    MOV AL,00001000B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CL
    MOV BH,0
    MOV AL,LIST1[BX]
    OUT DX,AL
    CALL DELAY1
    MOV DX,288H    
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;-------------------------  
    MOV AL,CL
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H

    MOV DL,32
    MOV AH,02H
    INT 21H
;------------------------------I2����------------------------------
  L3: 
  	MOV AL,00
    MOV DX,I2
    OUT DX,AL
    MOV CX,0FFH           
DELAY3:
	LOOP DELAY3
    MOV DX,I0
    IN AL,DX
    MOV BX,2
    MUL BL  
    MOV BL,100
    DIV BL  
    MOV CH,AL
    MOV CL,AH   
;------------------------------
    MOV DX,PORTB
    MOV AL,00000010B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CH
    MOV BH,0
    MOV AL,LIST2[BX]
    OUT DX,AL
    CALL DELAY1
    MOV DX,288H    
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;--------------------------------  
    MOV AL,CH
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H  
    MOV DL,46
    MOV AH,02H
    INT 21H  
    MOV AL,CL
    MOV BX,10
    MUL BL
    MOV BX,100
    DIV BL
    MOV CL,AL
;---------------------- 
    MOV DX,PORTB
    MOV AL,00000001B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CL
    MOV BH,0
    MOV AL,LIST1[BX]
    OUT DX,AL
    CALL DELAY1
    MOV DX,288H   
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;-------------------------  
    MOV AL,CL
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H
    MOV DL,32
    MOV AH,02H
    INT 21H       
    MOV DL,0DH             ;��ʾ�س�������ʵʱ��ʾ
    MOV AH,2
    INT 21H
	JMP L1              ;ѭ��

DELAY1 PROC ;��ʱ������ʱ10s
        PUSH BX
        PUSH CX
        
        MOV BX,15    
BAGAIN: MOV CX,3000  
 BWAIT: LOOP BWAIT
        DEC BX
        JNZ BAGAIN
        POP CX
        POP BX
        RET
DELAY1 ENDP

CODE ENDS
  END START

