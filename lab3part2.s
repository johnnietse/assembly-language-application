.equ LAST_RAM_WORD, 	0x007FFFFC
	.equ JTAG_UART_BASE,	0x10001000
	.equ DATA_OFFSET, 	0
	.equ STATUS_OFFSET,	4
	.equ WSPACE_MASK,	0xFFFF

	.text
	.global _start
	.org 0x00000000

_start:
	movia sp,LAST_RAM_WORD
	movia r2, TEXT
	call PrintString
	
	movia r2,NUMS
	ldw r3,N(r0)
	call DisplayByteList
	call CondORByteList
	call DisplayByteList
	
_end:
	br _end

#------------------------------------------------

PrintChar:
	subi sp,sp,8
	stw r3,4(sp)
	stw r4,0(sp)
	movia r3,JTAG_UART_BASE
pc_loop:
	ldwio r4,STATUS_OFFSET(r3)
	andhi r4,r4, WSPACE_MASK
	beq r4,r0,pc_loop
	stwio r2, DATA_OFFSET(r3)
	
	ldw r3,4(sp)
	ldw r4,0(sp)
	addi sp,sp,8
	ret

#--------------------------------------------

PrintString:
	subi sp,sp,12
	stw r3,8(sp)
	stw r2,4(sp)
	stw ra,0(sp)

	mov r3,r2
ps_loop:
	ldb r2,0(r3)
	beq r2,r0,ps_end_loop
	call PrintChar
	addi r3,r3,1
	br ps_loop
ps_end_loop:
	ldw r3,8(sp)
	ldw r2,4(sp)
	ldw ra,0(sp)
	addi sp, sp, 12
	ret

#-------------------------------------------------

PrintHexDigit:
	subi sp,sp,12
	stw r2,8(sp)
	stw r3,4(sp)
	stw ra,0(sp)

	mov r3,r2
phd_if:
	movi r2,9
	ble r3,r2,phd_else
phd_then:
	subi r2,r3,10
	addi r2,r2,'A'
	br phd_end_if
phd_else:
	addi r2,r3,'0'
phd_end_if:
	call PrintChar
	ldw r2,8(sp)
	ldw r3,4(sp)
	ldw ra,0(sp)
	addi sp,sp,12
	ret

#-------------------------------------------

PrintHexByte:
	subi sp,sp,12
	stw r2,8(sp)
	stw r3,4(sp)
	stw ra,0(sp)

	mov r3,r2
	srli r2,r3,4
	andi r2,r2, 0xF
	call PrintHexDigit
	andi r2,r3,0xF
	call PrintHexDigit

	ldw r2,8(sp)
	ldw r3,4(sp)
	ldw ra,0(sp)
	addi sp,sp,12
	ret

#-----------------------------------------------------
DisplayByteList:

	subi sp,sp,24
	stw r2,20(sp)
	stw r3,16(sp)
	stw r4,12(sp)
	stw r5,8(sp)
	stw r6,4(sp)
	stw ra,0(sp)
	mov r5, r2
	
db_loop:
	ldbu r4, 0(r5)
	movi r6, 128
	
db_if:
	blt	r4, r6, db_else
db_then:
	movi r2, '['
	call PrintChar
	ldbu r2,0(r5)
	call PrintHexByte
	movi r2, ']'
	call PrintChar
	br db_end
	
db_else:
	movi r2, '_'
	call PrintChar
	ldbu r2,0(r5)
	call PrintHexByte
	movi r2, '_'
	call PrintChar
	

db_end:
	movi r2, ' '
	call PrintChar
	addi r5, r5, 1
	subi r3, r3, 1
	bgt r3, r0, db_loop
	movi r2, '\n'
	call PrintChar
	ldw r2,20(sp)
	ldw r3,16(sp)
	ldw r4,12(sp)
	ldw r5,8(sp)
	ldw r6,4(sp)
	ldw ra,0(sp)

	addi sp,sp,24
	ret

#-------------------------------------------------------
CondORByteList:
	subi sp,sp,24
	stw r2,20(sp)
	stw r3,16(sp)
	stw r4,12(sp)
	stw r5,8(sp)
	stw r6,4(sp)
	stw ra,0(sp)
	mov r5, r2

cb_loop:
	ldbu r4, 0(r5)
	movi r6, 128
	
cb_if:
	bgt	r4, r6, cb_end
	
cb_else:
	ori r4, r4, 0x80
	stb r4, 0(r5)

cb_end:
	
	addi r5, r5, 1
	subi r3, r3, 1
	bgt r3, r0, cb_loop
	ldw r2,20(sp)
	ldw r3,16(sp)
	ldw r4,12(sp)
	ldw r5,8(sp)
	ldw r6,4(sp)
	ldw ra,0(sp)

	addi sp,sp,24
	ret
	
#------------------------------------------------------
	.org 	0x00001000
	
	N: 		.word 4
	NUMS: 	.byte 0x3E, 0xF7, 0x2C, 0x9A
	.org 	0x00001100
	TEXT:	.asciz	"Lab 3\n"