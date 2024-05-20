class my_enviroment extends uvm_env;
	`uvm_component_utils(my_enviroment)
	
	my_agent      agnt;
	my_scoreboard scb;
	
	function new(string name = "my_enviroment", uvm_component parent);
    super.new(name, parent);
    `uvm_info("ENV_CLASS", "Inside Constructor!", UVM_MEDIUM)
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV_CLASS", "Build Phase!", UVM_MEDIUM)
    agnt = my_agent::type_id::create("agnt", this);
    scb = my_scoreboard::type_id::create("scb", this);
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV_CLASS", "Connect Phase!", UVM_MEDIUM)
    agnt.mon.monitor_port.connect(scb.scoreboard_port);
  endfunction: connect_phase
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase
endclass: my_enviroment
