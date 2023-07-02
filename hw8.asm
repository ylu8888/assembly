.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Output messages
straight_str: .asciiz "STRAIGHT_HAND"
four_str: .asciiz "FOUR_OF_A_KIND_HAND"
pair_str: .asciiz "TWO_PAIR_HAND"
unknown_hand_str: .asciiz "UNKNOWN_HAND"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION"
invalid_args_error: .asciiz "INVALID_ARGS"

# Put your additional .data declarations here, if any.


# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory  
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    # Start the assignment by writing your code here

#load the char from first command line arg
lw $t1, addr_arg0
lb $s0, 0($t1)

#checks if theres no null term after EDP
lb $s6, 1($t1)
li $s7, 0 #null term
bne $s6, $s7, print_error # print the error
move $t2, $a0
# checks if equal to EDP
li $s1, 69 #E
beq $s0, $s1, check_eargs # proceed to check E
li $s2, 68 #D
beq $s0, $s2, check_dargs # proceed to check D
li $s3, 80 #P
beq $s0, $s3, check_pargs # proceed to check P


# else, print error
la $a0, invalid_operation_error 
li $v0, 4 
syscall 
j exit

print_error: #print error func
la $a0, invalid_operation_error 
li $v0, 4 
syscall
j exit

#if EDP is valid, check if args are valid


check_eargs:
li $s4, 5
beq $t2, $s4, valid_eoperation #check if t2 is equal to 5
la $a0, invalid_args_error #else, send an error msg
li $v0, 4
syscall
j exit

     
check_dargs:
li $s5, 2
beq $t2, $s5, valid_doperation #check if t2 is equal to 2
la $a0, invalid_args_error #else, send error msg
li $v0, 4
syscall
j exit

check_pargs:
li $s5, 2
beq $t2, $s5, valid_poperation #check if t2 is equal to 2
la $a0, invalid_args_error #else, send error msg
li $v0, 4
syscall
j exit

valid_eoperation: 
#this is just intializing my variables
li $t2, 0  #initialize Ts
li $t3, 0  
li $t4 ,0
li $t5, 0
li $t6, 10  #times 10 to shift left by one
li $t7, 64
li $t8, 0 #bounds checker true or false
li $t9, 0 #just cheek if equal to 0

li $s2, 0  #opcode
li $s3, 0  #rs
li $s4, 0  #rt
li $s5, 0  #intermediate

li $s6, 0  #next 3 digits of the intermediate
li $s7, 0

#opcode
lw $t1, addr_arg1
lb $s0, 0($t1)   #get first decimal
lb $s1, 1($t1)	 #get second decimal
addi $t2, $s0, -48  #convert first dec char to int w/ ascii
addi $t3, $s1, -48  #convert second dec char to int w/ ascii
mul $t4, $t2, $t6   #multiply first dec by 10
add $t5, $t4, $t3  #add 1st dec * 10 with 2nd dec to convert to int
li $t7, 64 #checking bounds if less than 64
slt $t8, $t5, $t7   #if $t5 is less than 64 then store 1 in $t8, otherwise store 0
beq $t8, $t9, print_invalid #if $t8 is equal to 0, print invalid args
andi $s2, $t5, 0x3F  #convert dec to 6 bit binary

#rs
lw $t1, addr_arg2
lb $s0, 0($t1)   #get first decimal
lb $s1, 1($t1)	 #get second decimal
addi $t2, $s0, -48  #convert first dec char to int w/ ascii
addi $t3, $s1, -48  #convert second dec char to int w/ ascii
mul $t4, $t2, $t6   #multiply first dec by 10
add $t5, $t4, $t3  #add 1st dec * 10 with 2nd dec to convert to int
li $t7, 32 #checking bounds if less than 32
slt $t8, $t5, $t7   #if $t5 is less than 32 then store 1 in $t8, otherwise store 0
beq $t8, $t9, print_invalid  #if $t8 is equal to 0, print invalid args
andi $s3, $t5, 0x1F #convert dec to 5 bit binary

#rt
lw $t1, addr_arg3
lb $s0, 0($t1)   #get first decimal
lb $s1, 1($t1)	 #get second decimal
addi $t2, $s0, -48  #convert first dec char to int w/ ascii
addi $t3, $s1, -48  #convert second dec char to int w/ ascii
mul $t4, $t2, $t6   #multiply first dec by 10
add $t5, $t4, $t3  #add 1st dec * 10 with 2nd dec to convert to int
li $t7, 32 #checking bounds if less than 32
slt $t8, $t5, $t7  #if $t5 is less than 32 then store 1 in $t8, otherwise store 0
beq $t8, $t9, print_invalid #if $t8 is equal to 0, print invalid args
andi $s4, $t5, 0x1F #convert dec to 5 bit binary

#intermediate
lw $t1, addr_arg4
lb $t2, 0($t1)   #get first decimal
lb $t3, 1($t1)	 #get second decimal
lb $t4, 2($t1)   #get third dec
lb $t5, 3($t1)   #get fourth dec
lb $t6, 4($t1)   #get fifth dec
addi $t2, $t2, -48  #convert first dec char to int w/ ascii
addi $t3, $t3, -48  #convert second dec char to int w/ ascii
addi $t4, $t4, -48  #convert third dec char to int w/ ascii
addi $t5, $t5, -48  #convert fourth dec char to int w/ ascii
addi $t6, $t6, -48  #convert fifth dec char to int w/ ascii
li $s6, 10000  #times 10000 to shift left by four
mul $t2, $t2, $s6  #store 5 digit num in $t2
li $s6, 1000  #times 1000 to shift left by three
mul $t3, $t3, $s6  #store 4 digit num in $t3
li $s6, 100  #times 100 to shift left by two
mul $t4, $t4, $s6  #store 3 digit num in $t4
li $s6, 10  #times 10 to shift left by one
mul $t5, $t5, $s6  #store 2 digit num in $t5
add $s7, $t2, $t3  # sum of 5 digit num and 4 digit num
add $s7, $s7, $t4  #add sum with 3 digit num
add $s7, $s7, $t5  #add sum with 2 digit num
add $s7, $s7, $t6  #add sum with last digit
li $t7, 65536 #checking bounds if less than 65536
slt $t8, $s7, $t7 #if $s7 is less than 65536 then store 1 in $t8, otherwise store 0
beq $t8, $t9, print_invalid # $if $t8 equal to 0, print invalid args
andi $s5, $s7, 0xFFFF #convert dec to 16 bit binary

# concatenate the bits
li $s6, 0  #hex number initialization
sll $s6, $s2, 5   #shift opcode 5 to the left
or $s6, $s6, $s3   #add the rs 
sll $s6, $s6, 5	  #shift hex num 5 to the left
or $s6, $s6, $s4   #add the rt
sll $s6, $s6, 16  #shift hex num 16 to the left
or $s6, $s6, $s5  #add the intermediate

move $a0, $s6    #store hex num to $a0
li $v0, 34      #print $a0 for output
syscall
j exit  #exit code after done

print_invalid:  
la $a0, invalid_args_error #else, send an error msg
li $v0, 4
syscall
j exit

valid_doperation:
lw $t0, addr_arg1 #store hex number in $t0
li $s1, 48    #ascii for '0' 
li $s2, 120   #ascii for 'x'

#checking if '0x' is present
lb $t1, 0($t0) #store first char
lb $t2, 1($t0) #store second char

bne $t1, $s1, print_inv  #if first char is not 0, print invalid args
bne $t2, $s2, print_inv  #if second char is not x, print invalid args

#checking if 8 chars after the 0x
lb $t1, 10($t0)	#gets 10th char, should be a null term
li $s1, 0  #ascii for null term
bne $t1, $s1, print_inv #print error if not a null term

#check if 8 chars are valid hex values
#FIRST CHAR
lb $t1, 2($t0)  #get second char
li $s0, 48 #ascii for '0'   
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 58 #ascii for ':' which is after '9'
blt $t1, $s0, second_char #if second char is between 0-9 is valid hex value
li $s0, 97 #ascii for 'a'
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 103 #ascii for 'f'
blt $t1, $s0, second_char #if second char is between a-f is valid hex value
li $s0, 128 #the last ascii 'DEL'
blt $t1, $s0, print_inv  #if second char is less than 'DEL' print invalid
second_char:
lb $t1, 3($t0)  #get third char
li $s0, 48 #ascii for '0'   
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 58 #ascii for ':' which is after '9'
blt $t1, $s0, third_char #if second char is between 0-9 is valid hex value
li $s0, 97 #ascii for 'a'
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 103 #ascii for 'f'
blt $t1, $s0, third_char #if second char is between a-f is valid hex value
li $s0, 128 #the last ascii 'DEL'
blt $t1, $s0, print_inv  #if second char is less than 'DEL' print invalid
third_char:
lb $t1, 4($t0)  #get fourth char
li $s0, 48 #ascii for '0'   
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 58 #ascii for ':' which is after '9'
blt $t1, $s0, fourth_char #if second char is between 0-9 is valid hex value
li $s0, 97 #ascii for 'a'
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 103 #ascii for 'f'
blt $t1, $s0, fourth_char #if second char is between a-f is valid hex value
li $s0, 128 #the last ascii 'DEL'
blt $t1, $s0, print_inv  #if second char is less than 'DEL' print invalid
fourth_char: #FOURTH CHAR
lb $t1, 5($t0)  #get fifth char
li $s0, 48 #ascii for '0'   
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 58 #ascii for ':' which is after '9'
blt $t1, $s0, fifth_char #if second char is between 0-9 is valid hex value
li $s0, 97 #ascii for 'a'
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 103 #ascii for 'f'
blt $t1, $s0, fifth_char #if second char is between a-f is valid hex value
li $s0, 128 #the last ascii 'DEL'
blt $t1, $s0, print_inv  #if second char is less than 'DEL' print invalid
fifth_char: #FIFTH CHAR
lb $t1, 6($t0)  #get sixth char
li $s0, 48 #ascii for '0'   
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 58 #ascii for ':' which is after '9'
blt $t1, $s0, sixth_char #if second char is between 0-9 is valid hex value
li $s0, 97 #ascii for 'a'
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 103 #ascii for 'f'
blt $t1, $s0, sixth_char #if second char is between a-f is valid hex value
li $s0, 128 #the last ascii 'DEL'
blt $t1, $s0, print_inv  #if second char is less than 'DEL' print invalid
sixth_char: #SIXTH CHAR
lb $t1, 7($t0)  #get seventh char
li $s0, 48 #ascii for '0'   
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 58 #ascii for ':' which is after '9'
blt $t1, $s0, seventh_char #if second char is between 0-9 is valid hex value
li $s0, 97 #ascii for 'a'
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 103 #ascii for 'f'
blt $t1, $s0, seventh_char #if second char is between a-f is valid hex value
li $s0, 128 #the last ascii 'DEL'
blt $t1, $s0, print_inv  #if second char is less than 'DEL' print invalid
seventh_char:#SEVENTH CHAR
lb $t1, 8($t0)  #get eigth char
li $s0, 48 #ascii for '0'   
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 58 #ascii for ':' which is after '9'
blt $t1, $s0, eighth_char #if second char is between 0-9 is valid hex value
li $s0, 97 #ascii for 'a'
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 103 #ascii for 'f'
blt $t1, $s0, eighth_char #if second char is between a-f is valid hex value
li $s0, 128 #the last ascii 'DEL'
blt $t1, $s0, print_inv  #if second char is less than 'DEL' print invalid
eighth_char: #EIGTH CHAR
lb $t1, 9($t0)  #get ninth char
li $s0, 48 #ascii for '0'   
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 58 #ascii for ':' which is after '9'
blt $t1, $s0, valid_hex #if second char is between 0-9 is valid hex value
li $s0, 97 #ascii for 'a'
blt $t1, $s0, print_inv  #if second char is less than '0' print invalid
li $s0, 103 #ascii for 'f'
blt $t1, $s0, valid_hex #if second char is between a-f is valid hex value
li $s0, 128 #the last ascii 'DEL'
blt $t1, $s0, print_inv  #if second char is less than 'DEL' print invalid


#the 8 char hex num is valid, begin next part
valid_hex:
lw $t0, addr_arg1 #store hex number in $t0
lb $t1, 2($t0) #store first char
lb $t2, 3($t0) #store second char
lb $t3, 4($t0) #store third char
lb $t4, 5($t0) #store fourth char
lb $t5, 6($t0) #store fifth char
lb $t6, 7($t0) #store sixth char
lb $t7, 8($t0) #store seventh char
lb $t8, 9($t0) #store eighth char

li $t0, 10
make_int1:
addi $t1, $t1, -48  #convert first dec char to int w/ ascii
bge $t1, $t0, convert_t1
make_int2:
addi $t2, $t2, -48  #convert second dec char to int w/ ascii
bge $t2, $t0, convert_t2
make_int3:
addi $t3, $t3, -48  #convert third dec char to int w/ ascii
bge $t3, $t0, convert_t3
make_int4:
addi $t4, $t4, -48  #convert fourth dec char to int w/ ascii
bge $t4, $t0, convert_t4
make_int5:
addi $t5, $t5, -48  #convert fifth dec char to int w/ ascii
bge $t5, $t0, convert_t5
make_int6:
addi $t6, $t6, -48  #convert sixth dec char to int w/ ascii
bge $t6, $t0, convert_t6
make_int7:
addi $t7, $t7, -48  #convert seventh dec char to int w/ ascii
bge $t7, $t0, convert_t7
make_int8:
addi $t8, $t8, -48  #convert eigth dec char to int w/ ascii
bge $t8, $t0, convert_t8
j binary_conversion

convert_t1:
addi $t1, $t1, -39
j make_int2
convert_t2:
addi $t2, $t2, -39
j make_int3
convert_t3:
addi $t3, $t3, -39
j make_int4
convert_t4:
addi $t4, $t4, -39
j make_int5
convert_t5:
addi $t5, $t5, -39
j make_int6
convert_t6:
addi $t6, $t6, -39
j make_int7
convert_t7:
addi $t7, $t7, -39
j make_int8
convert_t8:
addi $t8, $t8, -39

binary_conversion:
andi $t1, $t1, 0xF #convert to binary
andi $t2, $t2, 0xF 
andi $t3, $t3, 0xF 
andi $t4, $t4, 0xF 
andi $t5, $t5, 0xF 
andi $t6, $t6, 0xF 
andi $t7, $t7, 0xF 
andi $t8, $t8, 0xF 

#get the 32 bit binary num
li $s0, 0 #binary num initialization
sll $s0, $t1, 4  #shift to the left 4
or $s0, $s0, $t2 #add next bin num
sll $s0, $s0, 4 #shift to the left 4
or $s0, $s0, $t3 #add next bin num
sll $s0, $s0, 4 #shift to the left 4
or $s0, $s0, $t4 #add next bin num
sll $s0, $s0, 4 #shift to the left 4
or $s0, $s0, $t5 #add next bin num
sll $s0, $s0, 4 #shift to the left 4
or $s0, $s0, $t6 #add next bin num
sll $s0, $s0, 4 #shift to the left 4
or $s0, $s0, $t7 #add next bin num
sll $s0, $s0, 4 #shift to the left 4
or $s0, $s0, $t8 #add next bin num
#s0 stores the 32 bit binary num/8 digit hex num


srl $t0, $s0, 26  #shift 26 to the right to get opcode store in t0
andi $t1, $t0, 0x3F  #bitmask of 6 bits 
srl $s1, $s0, 21  #shift 21 to the right to get rs store in t0
andi $t2, $s1, 0x1F  #bitmask of 5 bits
srl $s2, $s0, 16  #shift 16 to the right to get rt store in t0
andi $t3, $s2, 0x1F  #bitmask of 5 bits
andi $t4, $s0, 0xFFFF  #gets the intermediate using 16 bit mask

li $t5, 10
blt $t1, $t5, print_opzero  #if less than 10, print a leading zero
print_opcode:
move $a0, $t1
li $v0, 1
syscall 
li $a0, 32
li $v0, 11
syscall

blt $t2, $t5, print_rszero  #if less than 10, print a leading zero
print_rs:
move $a0, $t2
li $v0, 1
syscall
li $a0, 32
li $v0, 11
syscall

blt $t3, $t5, print_rtzero  #if less than 10, print a leading zero
print_rt:
move $a0, $t3
li $v0, 1
syscall
li $a0, 32
li $v0, 11
syscall

blt $t4, $t5, print_four_inter #less than 10, print 4 zeroes
li $t5, 100
blt $t4, $t5, print_three_inter #less than 100, print 3 zeroes
li $t5, 1000
blt $t4, $t5, print_two_inter #less than 1000, print 2 zeroes
li $t5, 10000
blt $t4, $t5, print_one_inter #less than 10000, print 1 zero
print_inter:
move $a0, $t4
li $v0, 1
syscall

j exit

print_opzero:
li $a0, 0
li $v0, 1
syscall
j print_opcode

print_rszero:
li $a0, 0
li $v0, 1
syscall
j print_rs

print_rtzero:
li $a0, 0
li $v0, 1
syscall
j print_rt

print_four_inter:
li $a0, 0
li $v0, 1
syscall
li $a0, 0
li $v0, 1
syscall
li $a0, 0
li $v0, 1
syscall
li $a0, 0
li $v0, 1
syscall
j print_inter

print_three_inter:
li $a0, 0
li $v0, 1
syscall
li $a0, 0
li $v0, 1
syscall
li $a0, 0
li $v0, 1
syscall
j print_inter

print_two_inter:
li $a0, 0
li $v0, 1
syscall
li $a0, 0
li $v0, 1
syscall
j print_inter

print_one_inter:
li $a0, 0
li $v0, 1
syscall
j print_inter

j exit

print_inv:
la $a0, invalid_args_error #else, send an error msg
li $v0, 4
syscall
j exit



valid_poperation:
lw $t0, addr_arg1 #store the hand into $t0
lb $t1 0($t0) #store the first card
lb $t2 1($t0) #store the 2nd
lb $t3 2($t0) #store 3rd
lb $t4 3($t0)
lb $t5 4($t0)

andi $t1, $t1, 0xF #bitmask to find the ranks, ignore suits
andi $t2, $t2, 0xF
andi $t3, $t3, 0xF
andi $t4, $t4, 0xF
andi $t5, $t5, 0xF
#$t1 stores first card, $t2 stores 2nd card, $t5 stores last card, etc

#STRAIGHT CHECKER
move $s0, $t1 #store the first card into temp $s0
min_finder: #s0 stores the minimum
bgt $s0, $t2, new_min #if 1st card > 2nd, 2nd card is new min
bgt $s0, $t3, new_min2 #if 2nd card > 3rd, 3rd card is new min
bgt $s0, $t4, new_min3 #if 3rd card > 4th, 4th card is new min
bgt $s0, $t5, new_min4 #if 4th card > 5th, 5th card is new min
j incre_min

#finds the minimum
new_min:
move $s0, $t2
j min_finder

new_min2:
move $s0, $t3
j min_finder

new_min3:
move $s0, $t4
j min_finder

new_min4:
move $s0, $t5
j min_finder

incre_min:
addi $s1, $s0, 1
beq $t1, $s1, incre_min2
beq $t2, $s1, incre_min2
beq $t3, $s1, incre_min2
beq $t4, $s1, incre_min2
beq $t5, $s1, incre_min2
j four_kind_check

incre_min2:
addi $s1, $s1, 1
beq $t1, $s1, incre_min3
beq $t2, $s1, incre_min3
beq $t3, $s1, incre_min3
beq $t4, $s1, incre_min3
beq $t5, $s1, incre_min3
j four_kind_check

incre_min3:
addi $s1, $s1, 1
beq $t1, $s1, incre_min4
beq $t2, $s1, incre_min4
beq $t3, $s1, incre_min4
beq $t4, $s1, incre_min4
beq $t5, $s1, incre_min4
j four_kind_check

incre_min4:
addi $s1, $s1, 1
beq $t1, $s1, valid_straight
beq $t2, $s1, valid_straight
beq $t3, $s1, valid_straight
beq $t4, $s1, valid_straight
beq $t5, $s1, valid_straight
j four_kind_check

#FOUR KIND CHECKER
four_kind_check:
li $s1, 1 #counter for num of same cards
four_kind:
move $s0, $t1 #store first card into $s0
beq $s0, $t2, incre_counter
four_kind2:
beq $s0, $t3, incre_counter2
four_kind3:
beq $s0, $t4, incre_counter3
four_kind4:
beq $s0, $t5, incre_counter4
j four_kind_check2

incre_counter:
li $s2, 4
addi $s1, $s1, 1
beq $s1,$s2, valid_four_kind
j four_kind2

incre_counter2:
li $s2, 4
addi $s1, $s1, 1
beq $s1,$s2, valid_four_kind
j four_kind3

incre_counter3:
li $s2, 4
addi $s1, $s1, 1
beq $s1,$s2, valid_four_kind
j four_kind4

incre_counter4:
li $s2, 4
addi $s1, $s1, 1
beq $s1,$s2, valid_four_kind
j four_kind_check2


four_kind_check2:
li $s1, 1
four_kind5:
move $s0, $t2 #store second card into $s0
beq $s0, $t1, incre_counter5
four_kind6:
beq $s0, $t3, incre_counter6
four_kind7:
beq $s0, $t4, incre_counter7
four_kind8:
beq $s0, $t5, incre_counter8
j two_pair_check

incre_counter5:
li $s2, 4
addi $s1, $s1, 1
beq $s1,$s2, valid_four_kind
j four_kind6

incre_counter6:
li $s2, 4
addi $s1, $s1, 1
beq $s1,$s2, valid_four_kind
j four_kind7

incre_counter7:
li $s2, 4
addi $s1, $s1, 1
beq $s1,$s2, valid_four_kind
j four_kind8

incre_counter8:
li $s2, 4
addi $s1, $s1, 1
beq $s1,$s2, valid_four_kind
j two_pair_check

#TWO PAIR CHECKER
two_pair_check:
li $s1, 0 #counter of number of pairs, valid if == 2
move $s0, $t1 #store first card in $s0
beq $s0, $t2, incre_pair  #if a pair is found, incre # of pairs
beq $s0, $t3, incre_pair
beq $s0, $t4, incre_pair
beq $s0, $t5, incre_pair
j two_pair_check2

incre_pair:
li $s2, 2 #number of cards needed to be a pair
addi $s1, $s1, 1
beq $s1, $s2, valid_two_pair
j two_pair_check2
	
two_pair_check2:
move $s0, $t2 #store second card  
beq $s0, $t3, incre_pair2 #if a pair is found, incre # of pairs
beq $s0, $t4, incre_pair2
beq $s0, $t5, incre_pair2
j two_pair_check3

incre_pair2:
li $s2, 2
addi $s1, $s1, 1
beq $s1, $s2, valid_two_pair
j two_pair_check3

two_pair_check3:
move $s0, $t3 #store third card
beq $s0, $t4, incre_pair3
beq $s0, $t5, incre_pair3
j two_pair_check4

incre_pair3:
li $s2, 2
addi $s1, $s1, 1
beq $s1, $s2, valid_two_pair
j two_pair_check4

two_pair_check4:
move $s0, $t4 #store fourth card
beq $s0, $t5 incre_pair4
j unknown_hand

incre_pair4:
li $s2, 2
addi $s1, $s1, 1
beq $s1, $s2, valid_two_pair
j unknown_hand

j exit

valid_straight:
la $a0, straight_str
li $v0, 4
syscall
j exit

valid_four_kind:
la $a0, four_str
li $v0, 4
syscall
j exit

valid_two_pair:
la $a0, pair_str
li $v0, 4
syscall
j exit

unknown_hand:
la $a0, unknown_hand_str
li $v0, 4
syscall
j exit


exit:
    li $v0, 10
    syscall
