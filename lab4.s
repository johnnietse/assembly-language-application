.equ        JTAG_UART_BASE,        0x10001000
.equ        DATA_OFFSET,        0
.equ        STATUS_OFFSET,        4
.equ        WSPACE_MASK,        0xFFFF

.text
.global _start
.org 0x0000
.text

_start:
    movia sp, 0x007FFFFC

main:
    # Print header
    movia r4, TEXT
	
print_header:
    ldb r2, 0(r4)
    beq r2, r0, loop_start
    call PrintChar
    addi r4, r4, 1
    br print_header

loop_start:
    movia r3, N
    ldw r3, 0(r3)
    movia r5, LIST

loop_body:
    ldbu r2, 0(r5)        # Load byte from LIST
    call PrintHexByte    # Print hex value
    movi r2, '?'         # Print ? character
    call PrintChar
    movi r2, ' '         # Print space
    call PrintChar
    call GetChar         # Get input character
    mov r4, r2
    call PrintChar       # Echo input character
    movi r2, '\n'        # Print newline character
    call PrintChar
    movi r6, 'Z'         # Check if input is 'Z'
    bne r4, r6, loop_end
    movi r2, 0x0         # If so, write 0 to current LIST element
    stb r2, 0(r5)
	
	
loop_end:
    addi r5, r5, 1
    subi r3, r3, 1
    bne r3, r0, loop_body

    br _end

_end:
    break
    br _end

# ---------- 

# Your previous PrintChar, GetChar subroutines

# ------------------------------------------------------------------------------------------------ PrintChar
	
PrintChar:
	subi  sp, sp, 8             # adjust stack pointer down to reserve space
	stw   r3, 4(sp)             # save value of register 13 so it can be a temp
	stw   r4, 0(sp)             # save value of register 14 so it can be a temp
	movia r3, JTAG_UART_BASE    # point to first memory-mapped I/0 register

pc_loop:
	ldwio r4, STATUS_OFFSET(r3) # read bits from status register
	andhi r4, r4, WSPACE_MASK   # mask off lower bits to isolate upper bits
	beq   r4, r0, pc_loop       # if upper bits are zero, loop again
	stwio r2, DATA_OFFSET(r3)   # otherwise, write character to data register
	ldw   r3, 4(sp)             # restore value of r3 from stack
	ldw   r4, 0(sp)             # restore value of r4 from stack
	addi  sp, sp, 8             # readjust stack pointer up to deallocate space
	ret                         # return to calling routine

# ----------  

GetChar:
	subi    sp, sp, 8
    stw     r3, 4(sp)
    stw     r4, 0(sp)
	
    movia   r3, JTAG_UART_BASE
gc_loop: 
	ldwio	r4, 0(r3)
    andi 	r2, r4, 0x8000
    beq 	r2, r0, gc_loop

    andi 	r2, r4, 0xFF

    ldw     r3, 4(sp)
    ldw     r4, 0(sp)
    addi    sp, sp, 8
	ret

# ----------

# Add the PrintHexByte subroutine here

PrintHexByte:

    subi    sp, sp, 12
    stw     ra, 8(sp)
    stw     r2, 4(sp)
    stw     r3, 0(sp)
    mov     r3, r2
    srli    r2, r2, 4
    call    PrintHexDigit
    andi    r2, r3, 0xF
    call    PrintHexDigit
    ldw     ra, 8(sp)
    ldw     r2, 4(sp)
    ldw     r3, 0(sp)
    addi    sp, sp, 12
    ret
	
# -------------------------------------------------------------------------------------------- PrintHexDigit

PrintHexDigit:
	subi sp, sp, 12             # adjust stack pointer down to reserve space
	stw  r2, 8(sp)              # save value for the hex digit
	stw  r3, 4(sp)              # save value for the other local variables
	stw  ra, 0(sp)              # nested call
	mov  r3, r2                 # move the hex digit to r3
	
phd_if:
	movi r2, 9                  # assign 9 to r2
	ble  r3, r2, phd_else       # compare if the hex digit is larger than 9
	
phd_then:
	subi r2, r3, 10             # if so, subtract 10 to get the offset
	addi r2, r2, 'A'            # offset character A 
	br   phd_endif              # ready to ptint the character
	
phd_else:
	addi r2, r3, '\0'           # convert a number to a character
	
phd_endif:
	call PrintChar              # print the character
	
	ldw  r2, 8(sp)
	ldw  r3, 4(sp)
	ldw  ra, 0(sp)
	addi sp, sp, 12
	ret		
	
	
		.org 0x1000
		.data
N:      .word 4
LIST:   .byte 0x88, 0xA3, 0xF2, 0x1C
TEXT:   .asciz "Lab 4\n"