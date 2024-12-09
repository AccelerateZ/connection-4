# Author: AccelerateZ
# Description: This is a MIPS assembly language program that implements a 2-player Connect-4 game.
# Date: December 2nd, 2024
# Features: It can check the horizontal, vertical, principal diagonal, and auxiliary diagonal to determine if a player wins.
#           It can also check if the board is full and declare a draw.
#           It can display the board and prompt the players to enter a column to place a token.
# Notice: The program is not perfect, it may have some bugs. Please let me know if you find any bugs.
# Notice: The program is originally written on my own, no copy from neither the internet nor other students. 

# -------------------------------------------------------------------------

.data
board:
	.word 0, 0, 0, 0, 0, 0, 0 # Row1
	.word 0, 0, 0, 0, 0, 0, 0 # Row2
	.word 0, 0, 0, 0, 0, 0, 0 # Row3
	.word 0, 0, 0, 0, 0, 0, 0 # Row4
	.word 0, 0, 0, 0, 0, 0, 0 # Row5
	.word 0, 0, 0, 0, 0, 0, 0 # Row6
	
top:
	.word 5, 5, 5, 5, 5, 5, 5
	
welcome: .asciiz "Welcome to Connect-4 the MIPS Version!\nThis is a 2-player game, each player will take turns placing a token.\nThe Objective is to create a line of 4 consecutive tokens.\nGood Luck!\n"
player_1_prompt: .asciiz "Player 1, it is your turn.\n"
player_2_prompt: .asciiz "Player 2, it is your turn.\n"
token_prompt: .asciiz "Select a column to play. Must be between 0 and 6.\n"
draw_prompt: .asciiz "The board is full, it's a draw!"
player_win_front_prompt: .asciiz "Congratulations, player "
player_win_end_prompt: .asciiz ", you won!\nThanks for playing!"
invalid: .asciiz "Invalid column, please try again.\n"
header_of_board: .asciiz " 0 1 2 3 4 5 6\n"
row_sep: .asciiz "|"
newline: .asciiz "\n"
empty_cell: .asciiz "_|"
player1_cell: .asciiz "*|"
player2_cell: .asciiz "+|"

.text
.globl main

main:
	li $s0, 1 # Current Player s0
	li $s1, 0 # CurrentTokens. Up to 42, if it is 42, then draw is stated.
	li $v0, 4
	la $a0, welcome #Print the welcome massage
	syscall
	jal print_board
	
# Enter of the game
game_loop:
	move $a0, $t0
	jal place_token # Place the token
	
	li $v0, 10
	syscall
	
# Function printBoard:
print_board:
	li $v0, 4
	la $a0, header_of_board # Print the header of the board
	syscall
	
	li $t0, 0 #i = 0
	li $t1, 6 # Number of Rows, 6
	li $t2, 7 # Number of Cols, 7
		
	print_outer_loop:
		bge $t0, $t1, stop_print_outer_loop
		li $t3, 0 # j = 0
		li $v0, 4
		la $a0, row_sep
		syscall
		
		print_inner_loop:
			bge $t3, $t2, stop_print_inner_loop
			
			# Calculate the address of a[i][j]
			mul $t4, $t0, $t2
			add $t4, $t4, $t3
			sll $t4, $t4, 2
			la $t5, board
			add $t5, $t5, $t4
			lw $t6, 0($t5) # This is a[i][j]
			
			# Check the value of a[i][j]
			li $v0, 4
			beqz $t6, print_empty
			li $t7, 1
			beq $t6, $t7, print_player1
			li $t7, 2
			beq $t6, $t7, print_player2
		
			print_empty:
				la $a0, empty_cell
				syscall
				j print_done
				
			print_player1:
				la $a0, player1_cell
				syscall
				j print_done
				
			print_player2:
				la $a0, player2_cell
				syscall
				j print_done

			print_done:
				nop
				
			addi $t3, $t3, 1 #j++
			j print_inner_loop

		stop_print_inner_loop:
			li $v0, 4
			la $a0, newline
			syscall
			
			addi $t0, $t0, 1
			j print_outer_loop

	stop_print_outer_loop:
		jr $ra

place_token:
	beq $s0, 1, player_1_turn
	beq $s0, 2, player_2_turn
	
	player_1_turn:
		li $v0, 4
		la $a0, player_1_prompt
		syscall
		j enter_column
		
	player_2_turn:
		li $v0, 4
		la $a0, player_2_prompt
		syscall
		j enter_column
		
	enter_column:
    	li $v0, 4
		la $a0, token_prompt
		syscall

		li $v0, 5
		syscall
		move $s2, $v0 # s2 = col
		blt $s2, 0, invaild_print
		bgt $s2, 6, invaild_print
		
		la $t1, top
		mul $t2, $s2, 4
		add $t1, $t1, $t2
		lw $t3, 0($t1)
		blt $t3, 0, invaild_print # t3 = indicator[col]
		move $s3, $t3
		mul $t5, $t3, 7
		add $t6, $t5, $s2
		
		la $t4, board
		mul $t6, $t6, 4
		add $t7, $t4, $t6
		sw $s0, 0($t7) # Write the new token to the board
		add $s1, $s1, 1 # CurrentToken++
		
		jal print_board # Display as expected......
		
		jal check_horizontal
		jal check_vertical
		jal check_principal_diagonal
		jal check_auxiliary_diagonal
		jal check_draw
		la $t1, top
		mul $t2, $s2, 4
		add $t1, $t1, $t2 # Find the top of the column
		lw $t3, 0($t1) # Take the top[col] out to execute
		sub $t3, $t3, 1 # top[col]--
		sw $t3, 0($t1) # Update the value
		
		beq $s0, 1, set_2_and_jump
		beq $s0, 2, set_1_and_jump
		
		set_1_and_jump:
			li $s0, 1
			j place_token
			
		set_2_and_jump:
			li $s0, 2
			j place_token
			
		
		li $v0, 10
		syscall
		
	invaild_print:
		li $v0, 4
		la $a0, invalid
		syscall
		
		j enter_column
		
check_draw:
	beq $s1, 42, state_draw
	jr $ra
	
	state_draw:
		li $v0, 4
		la $a0, draw_prompt
		syscall
		
		li $v0, 10
		syscall

check_horizontal:
	move $t0, $s3 # Row
	move $t1, $s2 # Column
	li $t2, 1 # ConsecutiveNumber
	li $t3, -1 # Left Offset
	li $t4, 1 # Right Offset
	
	check_horizontal_left:
		add $t5, $t1, $t3 # Column Offset
		blt $t5, 0, check_horizontal_right
		la $t7, board
		mul $t6, $t0, 7
		add $t6, $t6, $t5
		sll $t6, $t6, 2
		add $t7, $t7, $t6
		lw $t6, 0($t7)
		
		bne $t6, $s0, check_horizontal_right
		addi $t2, $t2, 1
		subi $t3, $t3, 1
		j check_horizontal_left
		
	check_horizontal_right:
		add $t5, $t1, $t4
		bgt $t5, 7, check_horizontal_done
		la $t7, board
		mul $t6, $t0, 7
		add $t6, $t6, $t5
		sll $t6, $t6, 2
		add $t7, $t7, $t6
		lw $t6, 0($t7)
		
		bne $t6, $s0, check_horizontal_done
		addi $t2, $t2, 1
		addi $t4, $t4, 1
		j check_horizontal_right
		
	check_horizontal_done:
		bge $t2, 4, state_win
		jr $ra
		
check_vertical:
	move $t0, $s3 # Row
	move $t1, $s2 # Column
	li $t2, 1 # ConsecutiveNumber
	li $t3, -1 # Up Offset
	li $t4, 1 # Down Offset

	check_vertical_up:
		add $t5, $t0, $t3 # Row Offset
		blt $t5, 0, check_vertical_down
		la $t7, board
		mul $t6, $t5, 7
		add $t6, $t6, $t1
		sll $t6, $t6, 2
		add $t7, $t7, $t6
		lw $t6, 0($t7)
		
		bne $t6, $s0, check_vertical_down
		addi $t2, $t2, 1
		subi $t3, $t3, 1
		j check_vertical_up

	check_vertical_down:
		add $t5, $t0, $t4
		bgt $t5, 6, check_vertical_done
		la $t7, board
		mul $t6, $t5, 7
		add $t6, $t6, $t1
		sll $t6, $t6, 2
		add $t7, $t7, $t6
		lw $t6, 0($t7)
		
		bne $t6, $s0, check_vertical_done
		addi $t2, $t2, 1
		addi $t4, $t4, 1
		j check_vertical_down

	check_vertical_done:
		bge $t2, 4, state_win
		jr $ra

check_principal_diagonal:
	li $t2, 1 # ConsecutiveNumber
	li $t3, -1 # Up-Left Directional Offset
	li $t4, 1 # Down-Right Directional Offset

	check_principal_diagonal_up_left:
		add $t5, $s3, $t3 # Row Offset
		add $t6, $s2, $t3 # Column Offset
		blt $t5, 0, check_principal_diagonal_down_right
		blt $t6, 0, check_principal_diagonal_down_right

		la $t7, board
		mul $t0, $t5, 7
		add $t0, $t0, $t6
		sll $t0, $t0, 2
		add $t7, $t7, $t0
		lw $t0, 0($t7)

		bne $t0, $s0, check_principal_diagonal_down_right
		addi $t2, $t2, 1
		subi $t3, $t3, 1
		j check_principal_diagonal_up_left

	check_principal_diagonal_down_right:
		add $t5, $s3, $t4 # Row Offset
		add $t6, $s2, $t4 # Column Offset
		bgt $t5, 5, check_principal_diagonal_done
		bgt $t6, 6, check_principal_diagonal_done

		la $t7, board
		mul $t0, $t5, 7
		add $t0, $t0, $t6
		sll $t0, $t0, 2
		add $t7, $t7, $t0
		lw $t0, 0($t7)

		bne $t0, $s0, check_principal_diagonal_done
		addi $t2, $t2, 1
		addi $t4, $t4, 1
		j check_principal_diagonal_down_right

	check_principal_diagonal_done:
		bge $t2, 4, state_win
		jr $ra

check_auxiliary_diagonal:
	li $t2, 1 # ConsecutiveNumber
	li $t3, 1 # Up-Right Directional Offset
	li $t4, 1 # Down-Left Directional Offset

	check_auxiliary_diagonal_up_right:
		sub $t5, $s3, $t3 # Row Offset
		add $t6, $s2, $t3 # Column Offset
		blt $t5, 0, check_auxiliary_diagonal_down_left
		bgt $t6, 6, check_auxiliary_diagonal_down_left

		la $t7, board
		mul $t0, $t5, 7
		add $t0, $t0, $t6
		sll $t0, $t0, 2
		add $t7, $t7, $t0
		lw $t0, 0($t7)

		bne $t0, $s0, check_auxiliary_diagonal_down_left
		addi $t2, $t2, 1
		addi $t3, $t3, 1
		j check_auxiliary_diagonal_up_right

	check_auxiliary_diagonal_down_left:
		add $t5, $s3, $t4 # Row Offset
		sub $t6, $s2, $t4 # Column Offset
		bgt $t5, 5, check_auxiliary_diagonal_done
		blt $t6, 0, check_auxiliary_diagonal_done

		la $t7, board
		mul $t0, $t5, 7
		add $t0, $t0, $t6
		sll $t0, $t0, 2
		add $t7, $t7, $t0
		lw $t0, 0($t7)

		bne $t0, $s0, check_auxiliary_diagonal_done
		addi $t2, $t2, 1
		addi $t4, $t4, 1
		j check_auxiliary_diagonal_down_left

	check_auxiliary_diagonal_done:
		bge $t2, 4, state_win
		jr $ra
		
state_win:
	li $v0, 4
    la $a0, player_win_front_prompt
    syscall
    
    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, player_win_end_prompt
    syscall
    
    li $v0, 10
    syscall
