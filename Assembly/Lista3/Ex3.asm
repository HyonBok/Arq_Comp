		# Exercicio 3
		addi s0,s0,10
Leitura:		li a7,5
			ecall
			add s1,s1,a0
			addi s0,s0,-1
		bnez s0, Leitura
		add a0,zero,s1
		li a7,1
		ecall