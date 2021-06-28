.data
	chain1: .word 'A', 'T', 'G', 'A', 'T', 'G', 'A', 'T', 'G', 'C'
	chain2: .word 'T', 'C', 'G', 'C', 'G', 'C', 'T', 'A', 'G', 'C'
	chain3: .word 'C', 'G', 'T', 'C', 'G', 'T', 'A', 'A', 'A', 'C'
	chain4: .word 'T', 'A', 'T', 'T', 'T', 'A', 'C', 'G', 'A', 'A'
	chain5: .word 'T', 'A', 'C', 'T', 'A', 'C', 'T', 'A', 'C', 'G'
	# A65 T84 G71 C67 A-T, T-A, G-C, C-G
	totalchainnumber: .word 5
	chainlength: .word 10
	charnewline: .asciiz "\n"
	charequal: .asciiz "=="
.text
	main:		
        	la $16, chain1
        	la $17, chain2
       		la $18, chain3
		la $19, chain4
		la $20, chain5
		li $21,16 #k=16 birinci register numaras?
		li $22,17 #l=17 ikinci register numaras?
		li $t0, 0 #i=0
		li $t1, 0 #j=0
		lw $t2, chainlength		
		lw $t3, totalchainnumber
		jal changeFirstRegister	
		jal changeSecondRegister
	loopfirstchainlength:
		lw $t4, ($t6) # dizinin dizi[i] i'ninci elaman?n? geçici alana at	
		add $t6,$t6,4 #dizinin  adresini güncelle
				
		#dizinin geçerli karakterini yazdir
		li $v0,1
		move $a0, $t4
		syscall			

		lw $t5, ($t7) # dizinin dizi[j] j'ninci elaman?n? geçici alana at	
		add $t7,$t7,4 #dizinin  adresini güncelle
				
		#Esittir isareti
		li $v0, 4
		la $a0, charequal
		syscall
				
		#dizinin geçerli karakterini yazdir
		li $v0,1
		move $a0, $t5
		syscall	
		
		#zincir e?le?melerini kontrol ediyoruz.			
		jal checkChainEqual
		checkChainEqualContinue:		
		
		#Yeni satir
		li $v0,4
		la $a0, charnewline
		syscall
						
		add $t0, $t0, 1 # i=i+1	
		
		beq $t0, $t2, setEqualPair # dizi sonu ise e?lemi?tir.
		setEqualPairContinue:
		
		blt $t0, $t2,loopfirstchainlength # i küçük chainlength oldu?u sürece loopchainlength noktas?na git

		jal changeFirstRegister
		jal loopfirstchainlength
	exit: 
		li $v0, 10
		syscall
		
	secondChainNotEqual:
		li $t0, 0 #i=0
		
		jal setFirstRegister
		
		#Yeni satir
		li $v0,4
		la $a0, charnewline
		syscall
		
		jal changeSecondRegister
		jal loopfirstchainlength
	
	#birinci zincir için de?eri ba?lang?ca al.	
	setFirstRegister:
		bne $21,17, setfirstNot17
		add $t6, $16,0 # gönderilen birinci dizinin adresini geçiçi alana at
		jr $ra
	setfirstNot17:
		bne $21,18, setfirstNot18
		add $t6, $17,0 # gönderilen birinci dizinin adresini geçiçi alana at
		jr $ra
	setfirstNot18:
		bne $21,19, setfirstNot19
		add $t6, $18,0 # gönderilen birinci dizinin adresini geçiçi alana at
		jr $ra
	setfirstNot19:
		bne $21,20, setfirstNot20
		add $t6, $19,0 # gönderilen birinci dizinin adresini geçiçi alana at
		jr $ra
	setfirstNot20:
		jr $ra

	#birinci zincir için kontrol i?lemi yap.	
	changeFirstRegister:
		bne $21,16, firstNot16
		add $t6, $16,0 # gönderilen birinci dizinin adresini geçiçi alana at
		add $21,$21,1 # d?? sayaç numaras?n? art?r
		jr $ra
	firstNot16:
		bne $21,17, firstNot17
		add $t6, $17,0 # gönderilen birinci dizinin adresini geçiçi alana at
		add $21,$21,1 # d?? sayaç numaras?n? art?r
		li $22,18
		jr $ra
	firstNot17:
		bne $21,18, firstNot18
		add $t6, $18,0 # gönderilen birinci dizinin adresini geçiçi alana at
		add $21,$21,1 # d?? sayaç numaras?n? art?r
		li $22,19
		jr $ra
	firstNot18:
		bne $21,19, exit
		add $t6, $19,0 # gönderilen birinci dizinin adresini geçiçi alana at
		add $21,$21,1 # d?? sayaç numaras?n? art?r
		li $22,20
		jr $ra

	
	#ikinci zincir için kontrol i?lemi yap.
	changeSecondRegister:
		bne $22,17, secondNot17
		add $t7, $17,0 # gönderilen ikinci dizinin adresini geçiçi alana at
		add $22,$22,1 # iç sayaç numaras?n? art?r
		jr $ra
	secondNot17:
		bne $22,18, secondNot18
		add $t7, $18,0 # gönderilen ikinci dizinin adresini geçiçi alana at
		add $22,$22,1 # iç sayaç numaras?n? art?r
		jr $ra
	secondNot18:
		bne $22,19, secondNot19
		add $t7, $19,0 # gönderilen ikinci dizinin adresini geçiçi alana at
		add $22,$22,1 # iç sayaç numaras?n? art?r
		jr $ra
	secondNot19:
		bne $22,20, secondNot20
		add $t7, $20,0 # gönderilen ikinci dizinin adresini geçiçi alana at
		add $22,$22,1 # iç sayaç numaras?n? art?r
		jr $ra
	secondNot20:
		jal changeFirstRegister
		jal loopfirstchainlength
		
	#zincir e?le?melerini kontrol ediyoruz.	
	checkChainEqual:
		# A65 T84 G71 C67 A-T, T-A, G-C, C-G
		bne $t4,65, firstChainNotEqual65
		bne $t5,84, secondChainNotEqual
		jal checkChainEqualContinue
		#jr $ra
	firstChainNotEqual65:
		bne $t4,84, firstChainNotEqual84
		bne $t5,65, secondChainNotEqual
		jal checkChainEqualContinue
		#jr $ra
	firstChainNotEqual84:
		bne $t4,71, firstChainNotEqual71
		bne $t5,67, secondChainNotEqual
		jal checkChainEqualContinue
		#jr $ra
	firstChainNotEqual71:
		bne $t4,67, secondChainNotEqual
		bne $t5,71, secondChainNotEqual
		jal checkChainEqualContinue
		#jr $ra
	#e?lemi? çiftleri t8 ve t9 alanlar?na yazaca??z		
	setEqualPair:
		bne $21,17, setEqualPairfirstNot17
		li $t8, 1		
		jal setEqualPairSecond
	setEqualPairfirstNot17:
		bne $21,18, setEqualPairfirstNot18
		li $t8, 2		
		jal setEqualPairSecond
	setEqualPairfirstNot18:
		bne $21,19, setEqualPairfirstNot19
		li $t8, 3		
		jal setEqualPairSecond
	setEqualPairfirstNot19:
		bne $21,20, setEqualPairfirstNot20
		li $t8, 4		
		jal setEqualPairSecond
	setEqualPairfirstNot20:
		bne $21,21, setEqualPairfirstNot21
		li $t8, 5		
		jal setEqualPairSecond
	setEqualPairfirstNot21:
		jal setEqualPairSecond
		
	setEqualPairSecond:
		bne $22,17, setEqualPairSecondNot17
		li $t9, 1	
		jal setEqualPairContinue
	setEqualPairSecondNot17:	
		bne $22,18, setEqualPairSecondNot18
		li $t9, 2	
		jal setEqualPairContinue
	setEqualPairSecondNot18:	
		bne $22,19, setEqualPairSecondNot19
		li $t9, 3	
		jal setEqualPairContinue
	setEqualPairSecondNot19:	
		bne $22,20, setEqualPairSecondNot20
		li $t9, 4	
		jal setEqualPairContinue
	setEqualPairSecondNot20:	
		bne $22,21, setEqualPairSecondNot21
		li $t9, 5	
		jal setEqualPairContinue
	setEqualPairSecondNot21:			
		jal setEqualPairContinue
