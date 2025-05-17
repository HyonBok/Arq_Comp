		li s0,0x12345678 # são pseudoinstruções
		li t1,0x10010034 # (exceto a última)
		sw s3,(t1)       # <= observe o efeito na memória!
		lw t2,1(t1)      # aqui vai falhar por endereço inválido (está tentando colocar um valor na memória x10010035)