class my_subscriber extends uvm_subscriber #(my_sequence_item);
  
  my_sequence_item First_Seq;
  
  covergroup grp_1();
				Op_CODE: coverpoint First_Seq.op_code {bins bin_1[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0};}
  endgroup
  
  covergroup grp_2();
				reset: coverpoint First_Seq.rst { bins bin_1 =(0=>1);}
												 
  endgroup
  
  covergroup grp_3();
				Carry_in: coverpoint First_Seq.srcCy { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_4();
				Auxillary_carry_input: coverpoint First_Seq.srcAc { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_5();
				Input_Bit: coverpoint First_Seq.bit_in { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_6();
				Overflow: coverpoint First_Seq.desOv { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_7();
				Carry_output: coverpoint First_Seq.desCy { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_8();
				Auxillary_Carry_output: coverpoint First_Seq.desAc { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_9();
				Operand1: coverpoint First_Seq.src1 { bins bin_1[] = {0};}	
				Operand3: coverpoint First_Seq.src3 { bins bin_3[] = {0};}
  endgroup

  
  
  
  // Factory Registration
  `uvm_component_utils(my_subscriber)
  
  //Factory Construction
  function new (string name = "my_subscriber" , uvm_component parent = null);
       super.new(name,parent);
	   grp_1 = new();
	   grp_2 = new();
	   grp_3 = new();
	   grp_4 = new();
	   grp_5 = new();
	   grp_6 = new();
	   grp_7 = new();
	   grp_8 = new();
	   grp_9 = new();

    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Subscriber" ,"We_Are_Now_In_Subscriber_Build_Phase",UVM_NONE)
    // Factory Creation
      First_Seq = my_sequence_item::type_id::create("First_Seq");
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Subscriber" ,"We_Are_Now_In_Subscriber_Connect_Phase",UVM_NONE)
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Subscriber" ,"We_Are_Now_In_Subscriber_Run_Phase",UVM_NONE)
    endtask
  
  	
  
    function void write(my_sequence_item t);
      First_Seq = t ;
	  grp_1.sample();
	  grp_2.sample();
	  grp_3.sample();
	  grp_4.sample();
	  grp_5.sample();
	  grp_6.sample();
	  grp_7.sample();
	  grp_8.sample();
	  grp_9.sample();

	endfunction
	
    endclass

