class my_sequencer extends uvm_sequencer #(my_sequence_item);
	`uvm_component_utils(my_sequencer)
	
	function new(string name="my_sequencer", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("SEQUENCER_CLASS", "Inside Constructor!", UVM_MEDIUM)
	endfunction
	
	my_sequence_item item;
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("SEQUENCER_CLASS", "Build Phase!", UVM_MEDIUM)
    item = my_sequence_item::type_id::create("item");
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("SEQUENCER_CLASS", "Connect Phase!", UVM_MEDIUM)
	endfunction
endclass: my_sequencer
