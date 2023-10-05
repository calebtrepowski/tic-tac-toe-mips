.data
	DISPLAY_BASE_ADDRESS: 	.word 0xFFFF0000
	BACKGROUND_COLOR:		.word 0x008d2d1f
	LINE_COLOR:				.word 0x00FFFFFF

	board:	 				.byte 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
	main:
		jal		resetScreen
		jal		renderVerticalLines
		jal		renderHorizontalLines

		la		$s0, board
		addi	$s1, $0, 0


		loop:
		# player 1 turn
			addi	$v0, $0, 5
			syscall

			# renderizar jugada
			addi	$a0, $v0, 0
			jal 	renderCross

			addi	$s1, $s1, 1

			# actualizar board
			add		$t0, $s0, $v0
			addi	$t1, $0, 1
			sb		$t1, ($t0)

			jal 	checkBoard	


		# player 2 turn
			addi	$v0, $0, 5
			syscall

			# renderizar jugada
			addi	$a0, $v0, 0
			jal 	renderCircle

			addi	$s1, $s1, 1

			# actualizar board
			add		$t0, $s0, $v0
			addi	$t1, $0, 2
			sb		$t1, ($t0)

			jal 	checkBoard

			j 		loop

		game_end:
			jal		resetBoard
			j 		main


	resetScreen:
		lw	$t0, DISPLAY_BASE_ADDRESS
		lw 	$t1, BACKGROUND_COLOR
		li 	$t2, 0 # counter
		resetScreenFor:
			bgt		$t2, 1023, resetScreenEnd # 32rows*32columns - 1
			sw		$t1, 0($t0)
			addi 	$t2, $t2, 1
			addi	$t0, $t0, 4
			j resetScreenFor
		resetScreenEnd:
			jr 		$ra

	renderVerticalLines:
		lw		$t0, DISPLAY_BASE_ADDRESS
		lw 		$t4, LINE_COLOR
		li 		$t2, 0
		renderVerticalLinesFor:
			bgt		$t2, 128, renderVerticalLinesEnd # 32 rows*4
			sw		$t4, 40($t0)
			sw		$t4, 84($t0)
			addi	$t0, $t0, 128
			addi	$t2, $t2, 4
			j renderVerticalLinesFor
		renderVerticalLinesEnd:
			jr	$ra

	renderHorizontalLines:
		lw		$t0, DISPLAY_BASE_ADDRESS
		lw 		$t4, LINE_COLOR
		li 		$t2, 0
		renderHorizontalLinesFor:
			bgt		$t2, 31, renderHorizontalLinesEnd # 32 columns
			sw		$t4, 1280($t0) # 10th row *32*4
			sw		$t4, 2688($t0) # 20th row *32*4
			addi	$t0, $t0, 4
			addi	$t2, $t2, 1
			j		renderHorizontalLinesFor

		renderHorizontalLinesEnd:
		jr		$ra

	renderCross: # (boxNumber)
		lw 		$t4, LINE_COLOR

		addi	$t0, $0, 3
		div		$a0, $t0
		mfhi	$t0
		mflo	$t1

		mul		$t0, $t0, 44	# 44 for each column, 11 columns for each box
		mflo	$t0

		mul		$t1, $t1, 1408	# 128 for each row, 11 rows for each box
		mflo	$t1

		lw		$t2, DISPLAY_BASE_ADDRESS
		add		$t0, $t0, $t1
		add		$t0, $t2, $t0 # top left pixel of box: 1408*N/3 + 44*N%3

		sw		$t4, 132($t0)
		sw		$t4, 160($t0)

		sw		$t4, 264($t0)
		sw		$t4, 284($t0)

		sw		$t4, 396($t0)
		sw		$t4, 408($t0)

		sw		$t4, 528($t0)
		sw		$t4, 532($t0)

		sw		$t4, 656($t0)
		sw		$t4, 660($t0)

		sw		$t4, 780($t0)
		sw		$t4, 792($t0)

		sw		$t4, 904($t0)
		sw		$t4, 924($t0)

		sw		$t4, 1028($t0)
		sw		$t4, 1056($t0)

		jr		$ra

	renderCircle: #(boxNumber)
		lw 		$t4, LINE_COLOR

		addi	$t0, $0, 3
		div		$a0, $t0
		mfhi	$t0
		mflo	$t1

		mul		$t0, $t0, 44	# 44 for each column, 11 columns for each box
		mflo	$t0

		mul		$t1, $t1, 1408	# 128 for each row, 11 rows for each box
		mflo	$t1

		lw		$t2, DISPLAY_BASE_ADDRESS
		add		$t0, $t0, $t1
		add		$t0, $t2, $t0 # top left pixel of box: 1408*N/3 + 44*N%3

		sw		$t4, 144($t0)
		sw		$t4, 148($t0)

		sw		$t4, 268($t0)
		sw		$t4, 280($t0)

		sw		$t4, 392($t0)
		sw		$t4, 412($t0)

		sw		$t4, 516($t0)
		sw		$t4, 544($t0)

		sw		$t4, 644($t0)
		sw		$t4, 672($t0)

		sw		$t4, 776($t0)
		sw		$t4, 796($t0)

		sw		$t4, 908($t0)
		sw		$t4, 920($t0)

		sw		$t4, 1040($t0)
		sw		$t4, 1044($t0)

		jr		$ra


	checkBoard:
		beq		$s1, 9, game_end

		lb		$t1, board
		lb		$t2, board + 1
		lb		$t3, board + 2
		and		$t0, $t1, $t2
		and		$v0, $t0, $t3

		lb		$t2, board + 4
		lb		$t3, board + 8
		and		$t0, $t1, $t2
		and		$t0, $t0, $t3
		or		$v0, $v0, $t0

		lb		$t2, board + 3
		lb		$t3, board + 6
		and		$t0, $t1, $t2
		and		$t0, $t0, $t3
		or		$v0, $v0, $t0

		lb		$t1, board + 7
		lb		$t2, board + 8
		and 	$t0, $t1, $t2
		and		$t0, $t0, $t3
		or		$v0, $v0, $t0

		lb		$t1, board + 4
		lb		$t2, board + 2
		and 	$t0, $t1, $t2
		and 	$t0, $t0, $t3
		or 		$v0, $v0, $t0

		lb 		$t1, board + 8
		lb 		$t3, board + 5
		and 	$t0, $t1, $t2
		and 	$t0, $t0, $t3
		or 		$v0, $v0, $t0

		lb 		$t1, board + 3
		lb		$t2, board + 4
		and		$t0, $t1, $t2
		and		$t0, $t0, $t3
		or		$v0, $v0, $t0

		lb		$t1, board + 7
		lb 		$t3, board + 1
		and 	$t0, $t1, $t2
		and 	$t0, $t0, $t3
		or 		$v0, $v0, $t0

		beq 	$v0, 1, game_end
		beq 	$v0, 2, game_end
		jr 		$ra

	resetBoard:
		addi	$t0, $0, 0
		sb		$t0, ($s0)
		sb		$t0, 1($s0)
		sb		$t0, 2($s0)
		sb		$t0, 3($s0)
		sb		$t0, 4($s0)
		sb		$t0, 5($s0)
		sb		$t0, 6($s0)
		sb		$t0, 7($s0)
		sb		$t0, 8($s0)
		jr		$ra

	end:
