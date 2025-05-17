		# Insere valores decrescentes na memoria
		addi s0,zero,20
		li s1,0x10010000
Lista:			sw s0,(s1)
			addi s0,s0,-1
			addi s1,s1,4
		bgt s0,zero,Lista
		
		# Ordenaçao estilo bubble-sort (Com o último da lista sendo o maior)
		addi s6,zero,2
		addi s0,zero,20
		lui t0,0x10010
		addi t1,t0,0x004
Loop:			addi s1,zero,1
			addi s5,zero,0
Comparacao:			add t2,t0,s5		# Variaveis auxiliares para leitura
				add t3,t1,s5
				lw s2,(t2)		# Leitura
				lw s3,(t3)
				ble s2,s3,Igual		# Caso s2 > s3 troca a posicao
				add s4,zero,s2
				sw s2,(t3)		# Salvando
				sw s3,(t2)
Igual:				addi s1,s1,1
				addi s5,s5,4
			blt s1,s0,Comparacao
			addi s0,s0,-1
		bge s0,s6,Loop
		
