.text
null_cipher_sf:
li $t1, 0    #store char
li $t2, 0    #counter i = 0 for indices array
li $t3, 0    #addr of indices[i]
li $t5, 0    #addr of plaintext[i]
li $t7, 32   #ascii for space
li $t8, 0	 #word counter 
li $t9, 0    #character count = 0
move $t0, $a1    #ciphertext addr
move $t5, $a0    #plaintext addr

loop: 
beq $t2, $a3, done   #repeat until i == num_indices

sll $t3, $t2, 2		 #t3 = i * 4
add $t3, $t3, $a2    #$t3 = addr of indices[i]
lb $t4, 0($t3)       #loads current index, $t4 = indices[i] 
addi $t2, $t2, 1      #increment indices array by 1

beqz $t4, skip   #if indices[i] $t4 == 0, then skip the word
li $t8, 1   #reset the word counter back to 0 every time hit new word

word_loop:
beq $t8, $t4, store_char  #if word counter is equal to index, store it
addi $t0, $t0, 1	 #increments ciphertext[i] by 1
addi $t8, $t8, 1     #increments word counter by 1
j word_loop

store_char:
lb $t1, 0($t0)       #$loads current character, $t1 = ciphertext[i]
sb $t1, 0($t5)		 #stores the char into plaintext
addi $t5, $t5, 1	 #increments plaintext by 1
addi $t9, $t9, 1     #increments char counter by 1
j skip

skip:
     skip_loop:
     lb $t1, 0($t0)
     beq $t1, $zero, done
     lb $t1, 0($t0)       #$loads current character, $t1 = ciphertext[i]
     addi $t0, $t0, 1    #move to next character
     beq $t1, $t7, loop  #if space is found, go back to loop
     j skip
     
done:
    sb $zero, 0($t5)   	 #null terminate plaintext
    move $v0, $t9  #move character count into $v0
    
    jr $ra

transposition_cipher_sf:
move $t0, $a1    #ciphertext addr i counter
move $t1, $a0	 #plaintext addr i counter

li $t2, 0 	 	 #current char at ciphertext[i]
li $t3, 0 		 #row index
li $t4, 0 		 #column index 
li $t5, 0		 #stored index
li $t6, 1		 #row tracker
li $t8, 42 		 #ascii for '*'

loop_row:
beq $t3, $a2, end  #if row index == num row, end
li $t5, 0  	   #reset num of stored chars per row back to 0
addi $t3, $t3, 1   #increment row index by 1
li $t0, 0          #reset ciphertext
move $t0, $a1      #set ciphertext[i] counter back to 0
li $t6, 1

row_incre:
beq $t6, $t3, store_row_char #if row tracker == row index, j to store
addi $t6, $t6, 1    #increment row tracker by 1
addi $t0, $t0, 1    #incre ciphertext[i] by 1
j row_incre

store_row_char:
lb $t2, 0($t0)	   #load char at ciphertext[row index] 
beq $t2, $t8, end  #if char is '*', end
beqz $t2, done	   #if current char is null term, end
sb $t2, 0($t1)	   #else, store in plaintext
addi $t1, $t1, 1   #increment plaintext by 1
addi $t5, $t5, 1   #increment stored index by 1

li $t4, 0	#reset column index every time
loop_column:
beq $t4, $a2, store_col_char
addi $t0, $t0, 1    #incre ciphertext[i] by 1
addi $t4, $t4, 1	#increment column index by 1
j loop_column

store_col_char:
lb $t2, 0($t0)	   #load char at ciphertext[i]
beq $t2, $t8, end  #if char is '*', end
sb $t2, 0($t1)	   #store in plaintext
addi $t1, $t1, 1   #increment plaintext by 1
addi $t5, $t5, 1   #increment stored index by 1
li $t4, 0 	       #reset column index to 0
beq $t5, $a3, loop_row	#if stored index == num of columns, go loop_row
j loop_column

end:
    sb $zero, 0($t1) #null terminate plaintext
    jr $ra

decrypt_sf:
move $t9, $a0       #empty $t9 temp holds initial plaintext
addi $sp, $sp, -4   #make space on stack
sw $ra 0($sp)       

mult $a2, $a3       #multiply num cols * rows
mflo $t3            #stores product into $t3
sub $sp, $sp, $t3   #allocate $t3 space onto stack
move $a0, $sp       #moves addr of new buffer in plaintext
add $sp, $sp, $t3   #deallocates space

jal transposition_cipher_sf
move $a1, $a0   #move transpo plaintxt into null ciphers ciphertxt
lw $t0, 8($sp)    #indices[i]
lw $t1, 4($sp)    #num indices

move $a2, $t0     
move $a3, $t1
  
move $a0, $t9   #move initial plaintxt register
jal null_cipher_sf

lw $ra, 0($sp)  #restore from stack
addi $sp, $sp, 4 #deallocate stack space
jr $ra