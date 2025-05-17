		addi s0,zero,1000
		addi s1,zero,1
		li s2,0x10011234
Loop:			sw s1,(s2)
			addi s1,s1,1
			addi s2,s2,4
		ble s1,s0,Loop