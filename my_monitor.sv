class my_monitor extends uvm_monitor;

	
	virtual aluInterface vif;
	my_sequence_item item;
	uvm_analysis_port #(my_sequence_item) monitor_port;

	`uvm_component_utils(my_monitor)
	
	function new(string name = "my_monitor", uvm_component parent);
   super.new(name, parent);
   `uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_MEDIUM)
  endfunction: new
  
	function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_MEDIUM)
    item = my_sequence_item::type_id::create("item");
    monitor_port = new("monitor_port", this);
    if(!(uvm_config_db #(virtual aluInterface)::get(this, "*", "vif", vif))) begin
      `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!")
    end  
  endfunction: build_phase  
  
	function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_MEDIUM)  
  endfunction: connect_phase
  
	virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_MEDIUM)
    forever begin
      //sample inputs
      @(negedge vif.clk) begin
      item.srcCy 	 = vif.srcCy;
      item.srcAc   = vif.srcAc;
      item.bit_in  = vif.bit_in;
      item.rst 		 = vif.rst;
      item.op_code = vif.op_code;
      item.src1    = vif.src1;
      item.src2 	 = vif.src2;
      item.src3 	 = vif.src3;
  
      item.desCy 			= vif.desCy;      
      item.desAc 			= vif.desAc;      
      item.desOv 			= vif.desOv;      
      item.des1 			= vif.des1;      
      item.des2 			= vif.des2;      
      item.des_acc 		= vif.des_acc;      
      item.sub_result = vif.sub_result;      
      item.desCy 			= vif.desCy;      
      // send item to scoreboard
      monitor_port.write(item);
      end
    end
  endtask: run_phase  
endclass: my_monitor
