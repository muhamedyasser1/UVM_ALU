class my_agent extends uvm_agent;
	my_driver 		drv;
	my_monitor		mon;
	my_sequencer	sqr;
	virtual aluInterface vif;
	uvm_analysis_port #(my_sequence_item) monitor_port;	

	`uvm_component_utils(my_agent)
		
	function new(string name="my_agent", uvm_component parent);
		super.new(name, parent);
		`uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_MEDIUM)
	endfunction
	
	function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT_CLASS", "Build Phase!", UVM_MEDIUM)
    drv = my_driver::type_id::create("drv", this);
    mon = my_monitor::type_id::create("mon", this);
    sqr = my_sequencer::type_id::create("sqr", this);
    
    if(!uvm_config_db#(virtual aluInterface)::get(this, "*", "vif", vif)) begin
			`uvm_fatal(get_full_name(), "Virtual interface not set in the configuration database by the my_agent class")
		end
		uvm_config_db #(virtual aluInterface)::set(this,"my_driver","vif",vif);
    uvm_config_db #(virtual aluInterface)::set(this,"my_monitor","vif",vif);	
		
    monitor_port = new("monitor_port", this);		
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT_CLASS", "Connect Phase!", UVM_MEDIUM)
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.monitor_port.connect(monitor_port);
  endfunction: connect_phase
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase
endclass: my_agent
