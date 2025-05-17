		addi s0,zero,32
		addi s1,zero,-1
		addi s2,zero,31
		blt s1,zero,LZero
			ble s2, s0, LEThird1
				addi s3,zero,1
				b Fim
LEThird1:		bne s2, s0, LThird1
				addi s3,zero,2
				b Fim
LThird1:			addi s3,zero,3
				b Fim
LZero:			ble s2, s0, LEThird2
				addi s3,zero,4
				b Fim
LEThird2:		bne s2, s0, LThird2
				addi s3,zero,5
				b Fim
LThird2:			addi s3,zero,6
				b Fim
Fim:		