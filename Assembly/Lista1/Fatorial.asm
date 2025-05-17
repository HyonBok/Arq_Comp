		addi s0,zero,8				# fatorial de 8
		add s1,zero,s0
		addi s4,zero,2				# vai servir de ponto de parada para s0
desvio1:		addi s0,s0,-1			# s0 equivalente a i
			add s2,zero,s1
			addi s3,zero,1
desvio2:			addi s3,s3,1		# s3 equivalente a j
				add s1,s1,s2
				bne s3,s0,desvio2
			bne s0,s4,desvio1		# para em 2 pois não precisa continuar para 1
