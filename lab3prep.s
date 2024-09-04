.equ JTAG_UART_BASE, 0x10001000 # address of first JTAG UART register
.equ DATA_OFFSET,    0          # offset of JTAG UARI data register
.equ STATUS_OFFSET,  4          # offset of JTAG UART status register
.equ WSPACE_MASK,    0xFFFF     # used in AND operation to check status

	.text
	.global _start
	.org 	0x0000

# ----------------------------------------------------------------------------------------------------- Main

_start:
	movia sp, 0x007FFFFC        # initialize the stack pointer
	
	movia r2, TEXT              # parameter is passed through r2
	call  PrintString           # subroutines for printing
	
	movia r2, 0x4A              # parameter is passed through r2
	call  PrintHexByte          # subroutines for printing
	
	break                       # end of the program

# ---------------------------------------------------------------------------------------------- PrintString

PrintString:
	subi sp, sp, 12            # adjust stack pointer down to reserve space
	stw  r2, 8(sp)             # save value for the string pointer
	stw  r3, 4(sp)             # save value for the string
 	stw  ra, 0(sp)             # nested call
	mov  r3, r2                # move the string to r3

ps_loop:
	ldb  r2, 0(r3)             # read byte at the string pointer address
	
ps_if:
	beq  r2, r0, ps_endif      # exit loop if the character is null (end of string)
	
ps_then:
	call PrintChar             # print the current character
	addi r3, r3, 1             # increment the address to point to the next character
	br   ps_loop               # loop again if it is not the end of the string
	
ps_endif:
	ldw  r2, 8(sp)
	ldw  r3, 4(sp)
	ldw  ra, 0(sp)
	addi sp, sp, 12
	ret

# --------------------------------------------------------------------------------------------- PrintHexByte

PrintHexByte:
	subi sp, sp, 12             # adjust stack pointer down to reserve space
	stw  r2, 8(sp)              # save value for the modified hex byte
	stw  r3, 4(sp)              # save value for the original hex byte
	stw  ra, 0(sp)              # nested call 
	mov  r3, r2                 # move the hex byte to r3
	
	srli r2, r2, 4              # shift right to isolate upper nibble
    call PrintHexDigit          # print the upper nibble
	
	andi r2, r3, 0x0F           # mask to keep only the lower 4 bits of the byte
    call PrintHexDigit          # print the lower nibble
	
	ldw  r2, 8(sp)
	ldw  r3, 4(sp)
	ldw  ra, 0(sp)
	addi sp, sp, 12

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

# ----------------------------------------------------------------------------------------------- Constance

TEXT: .ascii "This text will be"
      .asciz " printed.\n***\n"

	.end