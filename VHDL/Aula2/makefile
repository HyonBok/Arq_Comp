NAME ?= naoexiste

# make build NAME=nome
build:
	ghdl -a $(NAME).vhd
	ghdl -e $(NAME)

# make simulate NAME=nome
simulate: build
	ghdl -a $(NAME)_tb.vhd
	ghdl -e $(NAME)_tb
	ghdl -r $(NAME)_tb --wave=$(NAME)_tb.ghw
	gtkwave $(NAME)_tb.ghw

clean:
	rm -f work-obj93.cf *.o *.ghw
