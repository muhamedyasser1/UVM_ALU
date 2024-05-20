class my_test extends uvm_test;
	`uvm_component_utils(my_test)
	
	my_enviroment env;
	my_base_sequence reset_seq;
	
	function new(string name = "my_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_MEDIUM)
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_MEDIUM)
    env = my_enviroment::type_id::create("env", this);
    reset_seq = my_base_sequence::type_id::create("reset_seq");
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_MEDIUM)
  endfunction: connect_phase
  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_MEDIUM)
    phase.raise_objection(this);
		  //reset_seq
		  reset_seq.start(env.agnt.sqr);
		  /*#10;
		  repeat(100) begin
		    //test_seq
		    test_seq = my_test_sequence::type_id::create("test_seq");
		    test_seq.start(env.agnt.sqr);
		    #10;
		  end*/
    phase.drop_objection(this);
  endtask: run_phase
endclass: my_test
