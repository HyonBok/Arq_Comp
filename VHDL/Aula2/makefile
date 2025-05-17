ENTITY ?= naoexiste

$(ENTITY)_tb.ghw: $(ENTITY).vhd $(ENTITY)_tb.vhd
	ghdl -a $(ENTITY).vhd
	ghdl -e $(ENTITY)
	ghdl -a $(ENTITY)_tb.vhd
	ghdl -e $(ENTITY)_tb
	ghdl -r $(ENTITY)_tb --wave=$(ENTITY)_tb.ghw
	gtkwave $(ENTITY)_tb.ghw

clean:
	rm -f work-obj93.cf *.o *.ghw
