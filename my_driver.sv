class my_driver extends uvm_driver #(my_sequence_item);
	
	virtual aluInterface vif;
	my_sequence_item item;

	`uvm_component_utils(my_driver)
	
	function new(string name = "my_driver", uvm_component parent = null);
  	super.new(name, parent);
  	`uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
  	`uvm_info("DRIVER_CLASS", "Build Phase!", UVM_MEDIUM)
  	item = my_sequence_item::type_id::create("my_sequence_item", this);
		if(!uvm_config_db#(virtual aluInterface)::get(this, "*", "vif", vif)) begin
			`uvm_fatal(get_full_name(), "Virtual interface not set in the configuration database by the my_agent class")
		end
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
  	`uvm_info("DRIVER_CLASS", "Connect Phase!", UVM_MEDIUM)
  endfunction
  
  task run_phase(uvm_phase phase);
		super.run_phase(phase);
  	`uvm_info("DRIVER_CLASS", "Run Phase!", UVM_MEDIUM)
		forever begin
			seq_item_port.get_next_item(item); // Get the next item from the sequencer
			drive(item);
			seq_item_port.item_done();
	  end
	endtask
	
	task drive(my_sequence_item item);
		@(negedge vif.clk) begin
		vif.srcCy 	<= item.srcCy;
		vif.srcAc 	<= item.srcAc;
		vif.bit_in 	<= item.bit_in;
		vif.rst 		<= item.rst;
		vif.op_code <= item.op_code;
		vif.src1 		<= item.src1;
		vif.src2 		<= item.src2;
		vif.src3 		<= item.src3;
		end
		#1;
	endtask
    
endclass: my_driver
