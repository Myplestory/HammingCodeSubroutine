.data 0x10000000
mainmenu: .asciiz "CSE 341 Hamming Code System\nSelect:\n1 – Enter a 7-bit Hamming code\n2 – Extract the 4-bit data word encoded by a 7-bit Hamming code\n3 – Determine if there is an error in a 7-bit Hamming code\n4 – Enter a 4-bit data word\n5 – Encode a 4-bit data word to a 7-bit Hamming code\n6 – Display 4-bit data word\n7 – Display 7-bit Hamming code\n8 – Quit\nEnter Choice: "
newline: .asciiz "\n"
enter_hamming: .asciiz "Enter a 7-bit Hamming code: "
hamming_code: .space 8
code_entered: .asciiz "Code saved!"
enter_data: .asciiz "Enter a 4-bit Data code: "
data_entered: .asciiz "Data saved!"
error: .asciiz "Error found! Bit location: "
encodedsuccess: .asciiz "Encoded data word! Hamming code: "
noerror: .asciiz "No Errors!"
extracted: .asciiz "Extracted the following data: "

.text
.globl main

Hamming:
    # hold in s1 and s2
    or $s1, $a0, $0
    or $s2, $a1, $0    
    j Prompted

# Main entry point
Prompted:
    # display prompt
    add $v0, $zero, 4
    lui $a0, 0x1000
    ori $a0, $a0, 0x0000
    syscall

    add $t1, $zero, 1
    add $t2, $zero, 2
    add $t3, $zero, 3
    add $t4, $zero, 4
    add $t5, $zero, 5
    add $t6, $zero, 6
    add $t7, $zero, 7
    add $s0, $zero, 8

    add $v0, $zero, 5
    syscall
    add $t0, $zero, $v0
    beq $t0, $t1, EnterHammingCode
    beq $t0, $t2, ExtractDataWord
    beq $t0, $t3, CheckError
    beq $t0, $t4, EnterDataWord
    beq $t0, $t5, EncodeHammingCode357
    beq $t0, $t6, DisplayDataWord
    beq $t0, $t7, DisplayHammingCode
    beq $t0, $s0, Quit

EnterHammingCode:
    # print enter_hamming
    add $v0, $zero, 4
    lui $a0, 0x1000
    ori $a0, $a0, 0x0174
    syscall
    # load up the saved s1 to a0
    or $a0, $s1, $0
    add $a1, $zero, 8
    add $v0, $zero, 8
    syscall
    # null term the space
    addi $t0, $a0, 7
    addi $t1, $zero, 0
    sb $t1, 0($t0)
    add $v0, $zero, 11
    # Save the new hamming back to s1
    or $s1, $a0, $0
    add $a0, $zero, 10
    syscall
    add $v0, $zero, 4
    lui $a0, 0x1000
    ori $a0, $a0, 0x0199
    syscall
    add $v0, $zero, 11
    add $a0, $zero, 10
    syscall
    j Prompted

EnterDataWord:
    # print enter_data
    add $v0, $zero, 4
    lui $a0, 0x1000
    ori $a0, $a0, 0x01a5
    syscall
    # load up the saved s2 to a0
    or $a0, $s2, $0
    add $a1, $zero, 5
    add $v0, $zero, 8
    syscall
    # null term the space
    addi $t0, $a0, 4
    addi $t1, $zero, 0
    sb $t1, 0($t0)
    add $v0, $zero, 11
    # Save the new data back to s2
    or $s2, $a0, $0
    add $a0, $zero, 10
    syscall
    add $v0, $zero, 4
    lui $a0, 0x1000
    ori $a0, $a0, 0x01bf
    syscall
    add $v0, $zero, 11
    add $a0, $zero, 10
    syscall
    j Prompted

ExtractDataWord:
# invoke checkerror and then construct the 4 bit based on the result
# T7,T8,T9 reserved for c1,c2,c3
    # CHECK FOR 7,5,3,1
    or $t0, $s1, $0
    # holder for odd/even
    add $t2, $zero, 0
    add $t3, $zero, 1
    # load the byte into t4
    lb $t4, 0($t0)
    # check if 7 is 1 with xor
    xor $t2, $t4, $t3
    add $t0, $t0, 2
    lb $t4, 0($t0)
    # check if 5 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 2
    lb $t4, 0($t0)
    # check if 3 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 2
    lb $t4, 0($t0)
    # check if 1 is 1 with xor
    xor $t2, $t4, $t2
    # Flip it
    xor $t2, $t2, $t3
    or $t7, $t2, $0

    # CHECK FOR 7,6,3,2
    or $t0, $s1, $0
    # holder for odd/even
    add $t2, $zero, 0
    add $t3, $zero, 1
    # load the byte into t4
    lb $t4, 0($t0)
    # check if 7 is 1 with xor
    xor $t2, $t4, $t3
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 6 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 3
    lb $t4, 0($t0)
    # check if 3 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 2 is 1 with xor
    xor $t2, $t4, $t2
    # Flip it
    xor $t2, $t2, $t3
    or $t8, $t2, $0

    # CHECK FOR 7,6,5,4
    or $t0, $s1, $0
    # holder for odd/even
    add $t2, $zero, 0
    add $t3, $zero, 1

    # load the byte into t4
    lb $t4, 0($t0)
    # check if 7 is 1 with xor
    xor $t2, $t4, $t3
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 6 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 5 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 4 is 1 with xor
    xor $t2, $t4, $t2
    # Flip it
    xor $t2, $t2, $t3
    or $t9, $t2, $0

    # store the binary check numb in t0
    add $t0, $zero, $zero
    add $t6, $zero, $zero
    sll $t9, $t9, 2  
    add $t0, $t0, $t9  
    sll $t8, $t8, 1  
    add $t0, $t0, $t8  
    add $t0, $t0, $t7  

    beq $t0, $t6, ExtractData
    bne $t0, $t6, FixData

FixData:
    # calc distance from left
    add $t1, $zero, 7
    sub $t2, $t1, $t0 
    or $t3, $s1, $0
    add $t3, $t3, $t2
    # flipping the bit
    lb $t4, 0($t3)
    add $t5, $zero, 1
    xor $t4, $t4, $t5
    sb $t4, 0($t3)
    # proceed with extraction
    j ExtractData

ExtractData:
    # load 7 bit into t0
    or $t0, $s1, $0
    lb $t4, 0($t0)
    sb $t4, 0($s2)
    add $t0, $t0, 1
    lb $t4, 0($t0)
    sb $t4, 1($s2)
    add $t0, $t0, 1
    lb $t4, 0($t0)
    sb $t4, 2($s2)
    add $t0, $t0, 2
    lb $t4, 0($t0)
    sb $t4, 3($s2)
    
    add $v0, $zero, 4
    lui $a0, 0x1000
    ori $a0, $a0, 0x0214
    syscall
    add $v0, $zero, 4
    or $a0, $s2, $0
    syscall
    add $v0, $zero, 11
    add $a0, $zero, 10
    syscall
    j Prompted



CheckError:
# T7,T8,T9 reserved for c1,c2,c3
    # CHECK FOR 7,5,3,1
    or $t0, $s1, $0
    # holder for odd/even
    add $t2, $zero, 0
    add $t3, $zero, 1
    # load the byte into t4
    lb $t4, 0($t0)
    # check if 7 is 1 with xor
    xor $t2, $t4, $t3
    add $t0, $t0, 2
    lb $t4, 0($t0)
    # check if 5 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 2
    lb $t4, 0($t0)
    # check if 3 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 2
    lb $t4, 0($t0)
    # check if 1 is 1 with xor
    xor $t2, $t4, $t2
    # Flip it
    xor $t2, $t2, $t3
    or $t7, $t2, $0

    # CHECK FOR 7,6,3,2
    or $t0, $s1, $0
    # holder for odd/even
    add $t2, $zero, 0
    add $t3, $zero, 1
    # load the byte into t4
    lb $t4, 0($t0)
    # check if 7 is 1 with xor
    xor $t2, $t4, $t3
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 6 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 3
    lb $t4, 0($t0)
    # check if 3 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 2 is 1 with xor
    xor $t2, $t4, $t2
    # Flip it
    xor $t2, $t2, $t3
    or $t8, $t2, $0

    # CHECK FOR 7,6,5,4
    or $t0, $s1, $0
    # holder for odd/even
    add $t2, $zero, 0
    add $t3, $zero, 1

    # load the byte into t4
    lb $t4, 0($t0)
    # check if 7 is 1 with xor
    xor $t2, $t4, $t3
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 6 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 5 is 1 with xor
    xor $t2, $t4, $t2
    add $t0, $t0, 1
    lb $t4, 0($t0)
    # check if 4 is 1 with xor
    xor $t2, $t4, $t2
    # Flip it
    xor $t2, $t2, $t3
    or $t9, $t2, $0

    # store the binary check numb in t0
    add $t0, $zero, $zero
    add $t6, $zero, $zero
    sll $t9, $t9, 2  
    add $t0, $t0, $t9  
    sll $t8, $t8, 1  
    add $t0, $t0, $t8  
    add $t0, $t0, $t7  

    beq $t0, $t6, NoErr
    bne $t0, $t6, Err

NoErr:
    add $v0, $zero, 4
    lui $a0, 0x1000
    ori $a0, $a0, 0x0209
    syscall
    add $v0, $zero, 11
    add $a0, $zero, 10
    syscall
    j Prompted

Err:
    add $v0, $zero, 4
    lui $a0, 0x1000
    ori $a0, $a0, 0x01cb
    syscall
    add $v0, $zero, 1
    or $a0, $t0, $zero
    syscall
    add $v0, $zero, 11
    add $a0, $zero, 10
    syscall
    j Prompted


EncodeHammingCode357:
# T7,T8,T9 reserved for p1,p2,p3
    # PARITY FOR 7,5,3
    or $t0, $s1, $0
    # load $4bit address to t1
    or $t1, $s2, $0
    # holder for odd/even
    add $t2, $zero, 0
    add $t3, $zero, 1

    # load the byte into t4
    lb $t4, 0($t1)
    # check if 7 is 1 with xor
    xor $t2, $t4, $t3
    # load the third byte into t4
    add $t1, $t1, 2
    lb $t4, 0($t1)
    # check if 5 is 1 with xor
    xor $t2, $t4, $t2
    add $t1, $t1, 1
    lb $t4, 0($t1)
    # check if 3 is 1 with xor
    xor $t2, $t4, $t2
    # Flip it
    xor $t2, $t2, $t3
    sb $t2, 6($s1)

    # PARITY FOR 7,6,3,2
    or $t0, $s1, $0
    # load $4bit address to t1
    or $t1, $s2, $0
    # holder for odd/even
    add $t2, $zero, 0
    add $t3, $zero, 1
    # load the byte into t4
    lb $t4, 0($t1)
    # check if 7 is 1 with xor
    xor $t2, $t4, $t3
    add $t1, $t1, 1
    lb $t4, 0($t1)
    # check if 6 is 1 with xor
    xor $t2, $t4, $t2
    # check if 3 is 1 with xor    
    add $t1, $t1, 2
    lb $t4, 0($t1)
    # check if 2 is 1 with xor
    xor $t2, $t4, $t2
    # Flip it
    xor $t2, $t2, $t3
    sb $t2, 5($s1)

    # PARITY FOR 7,6,5,4
    or $t0, $s1, $0
    # load $4bit address to t1
    or $t1, $s2, $0
    # holder for odd/even
    add $t2, $zero, 0
    add $t3, $zero, 1
    # load the byte into t4
    lb $t4, 0($t1)
    # check if 7 is 1 with xor
    xor $t2, $t4, $t3
    add $t1, $t1, 1
    lb $t4, 0($t1)
    # check if 6 is 1 with xor
    xor $t2, $t4, $t2
    # check if 5 is 1 with xor    
    add $t1, $t1, 1
    lb $t4, 0($t1)
    # check if 4 is 1 with xor
    xor $t2, $t4, $t2
    # Flip it
    xor $t2, $t2, $t3
    sb $t2, 3($s1)

    # Build the data bits in the hamming code now that we calculated parity
    add $t0, $t0, 3
    or $t0, $s1, $0
    # load $4bit address to t1
    or $t1, $s2, $0
    #grab the byte
    lb $t4, 0($t1)
    # place pos 7
    sb $t4, 0($s1)

    # place pos 6
    add $t1, $t1, 1
    lb $t4, 0($t1)
    sb $t4, 1($s1)

    # place pos 5
    add $t1, $t1, 1
    lb $t4, 0($t1)
    sb $t4, 2($s1)
    # place pos 3
    add $t1, $t1, 1
    lb $t4, 0($t1)
    sb $t4, 4($s1)

    add $v0, $zero, 4
    lui $a0, 0x1000
    ori $a0, $a0, 0x01e7
    syscall

    add $v0, $zero, 4
    or $a0, $s1, $0
    syscall
    add $v0, $zero, 11
    add $a0, $zero, 10
    syscall

    j Prompted
    

DisplayDataWord:
    add $v0, $zero, 4
    or $a0, $s2, $0
    syscall
    or $s2, $a0, $0
    add $v0, $zero, 11
    add $a0, $zero, 10
    syscall
    j Prompted

DisplayHammingCode:
    add $v0, $zero, 4
    or $a0, $s1, $0
    syscall
    or $s1, $a0, $0
    add $v0, $zero, 11
    add $a0, $zero, 10
    syscall
    j Prompted

Quit:
    jr $ra
