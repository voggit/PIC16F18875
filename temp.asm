
; PIC16F18875 Configuration Bit Settings

; Assembly source line config statements

#include "p16f18875.inc"

; CONFIG1
; __config 0xFFFF
 __CONFIG _CONFIG1, _FEXTOSC_ECH & _RSTOSC_EXT1X & _CLKOUTEN_OFF & _CSWEN_ON & _FCMEN_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _MCLRE_ON & _PWRTE_OFF & _LPBOREN_OFF & _BOREN_ON & _BORV_LO & _ZCD_OFF & _PPS1WAY_ON & _STVREN_ON
; CONFIG3
; __config 0xFFFF
 __CONFIG _CONFIG3, _WDTCPS_WDTCPS_31 & _WDTE_ON & _WDTCWS_WDTCWS_7 & _WDTCCS_SC
; CONFIG4
; __config 0xFFFF
 __CONFIG _CONFIG4, _WRT_OFF & _SCANE_available & _LVP_ON
; CONFIG5
; __config 0xFFFF
 __CONFIG _CONFIG5, _CP_OFF & _CPD_OFF
    
    ;This code block configures the ADC
;for polling, VDD and VSS references, FRC
;oscillator and AN0 input.
;
;Conversion start & polling for completion
;are included.
;
R0	equ 0x20
R1	equ 0x21
R2	equ 0x22
R3	equ 0x23
R4	equ 0x24
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************

MAIN_PROG CODE                      ; let linker place main program
START
    BANKSEL ANSELB ;Bank select, analog select B. This is the bank we are using.
    CLRF ANSELB ;Clear F register, analog select A. This clears the file register of the bank we are using
    BANKSEL PORTB ; Bank select Port A. Selects Port A.
    ;CLRF PORTA ;Clears Port A register f
    CLRF PORTB ;Clears Port B register f
    CLRF TRISB ;Changes TRIS B to output
    MOVLW B'00001101'
    MOVWF PORTB
    BANKSEL ADPCH
    MOVLW B'00000001' ; Set RA1 ADPCH to input
    MOVWF ADPCH
    BANKSEL ADCON1 ;
    MOVLW B'11110000' ;Right justify,
;FRC
;oscillator
    MOVWF ADCON1 ;Vdd and Vss Vref
    BANKSEL TRISA ;
    BSF TRISA,1 ;Set RA1 to input
    BANKSEL ANSELA ;
    BSF ANSELA,1 ;Set RA1 to analog
    BANKSEL ADCON0 ;
    MOVLW B'10000101' ; ENABLE ADCON0 Register
    MOVWF ADCON0 ;Turn ADC On
    
SAMPLE
    BANKSEL ADCON0
    BSF ADCON0,ADGO ;Start conversion
    BTFSC ADCON0,ADGO ;Is conversion done?
    GOTO $-1 ;No, test again
    ;BANKSEL ADRESH ;
    ;MOVF ADRESH,W ;Read upper 2 bits
   ; MOVWF RESULTHI ;store in GPR space
    BANKSEL ADRESL ;
    MOVF ADRESL,W ;Read lower 8 bits
    SUBLW D'230'
    BTFSS STATUS,C
    GOTO TEMPHI
    MOVF ADRESL,W ;Read lower 8 bits
    SUBLW D'224'
    BTFSC STATUS,C
    GOTO TEMPLO ; 
    GOTO TEMPOK ; normal temperature
    

TEMPHI
    MOVLW B'00001000'
    BANKSEL PORTB
    MOVWF PORTB
    CALL DELAY
    GOTO SAMPLE
    
TEMPOK
    MOVLW B'00000100'
    BANKSEL PORTB
    MOVWF PORTB
    CALL DELAY
    GOTO SAMPLE
    
TEMPLO
    MOVLW B'00000001'
    BANKSEL PORTB
    MOVWF PORTB
    CALL DELAY
    GOTO SAMPLE
    
DELAY
    movlw 0xff
    movwf R4
    goto DELAY4
    
DELAY0
    decfsz R0
    goto DELAY0
    goto DELAY4
    
DELAY1
    movlw 0xff
    movwf R0
    decfsz R1
    goto DELAY0
    return
    
DELAY2
    movlw 0xff
    movwf R1
    decfsz R2
    goto DELAY1
    return
    
DELAY3
    movlw 0xff
    movwf R2
    decfsz R3
    goto DELAY2
    return
    
DELAY4
    movlw 0xff
    movwf R3
    decfsz R4
    goto DELAY3
    return
    
    END
