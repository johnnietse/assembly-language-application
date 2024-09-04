.text
.global _start
.org     0x0000

_start:
    movia sp, 0x007FFFFC
    movi  r2, LIST1
    movi  r3, LIST2
    movi  r4, 3
    movi  r5, 15
    call  ListComputation
    stw   r2, Count(r0)

_end:
    break
    
ListComputation:
    subi  sp, sp, 16            # adjust stack pointer down to reserve space
    stw   r4, 12(sp)            # n
    stw   r6, 8(sp)             # a
    stw   r7, 4(sp)             # count
    stw   r8, 0(sp)
    movi  r6, 0

loop:
if:
    ldw  r7, 0(r2)
    ldw  r8, 0(r3)
    muli r8, r8, 3
    bgt  r7, r8, else
then:
    addi r6, r6, 1
    br   end_if
else:
    stw  r0, 0(r2)
    stw  r5, 0(r3)
end_if:
    addi  r2, r2, 4
    addi  r3, r3, 4
    subi  r4, r4, 1
    bgt   r4, r0, loop
    mov   r2, r6
    ldw   r4, 12(sp)
    ldw   r6, 8(sp)
    ldw   r7, 4(sp)
    ldw   r8, 0(sp)
    addi  sp, sp, 16
    ret
	
    .org 0x1000
    
LIST1: .word 8, 9, 10
LIST2: .word 3, 2, 1
Count: .skip 4

   .end
 
