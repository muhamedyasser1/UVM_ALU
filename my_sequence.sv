class my_base_sequence extends uvm_sequence;
  
  
  my_sequence_item First_seq;
  bit STATUS;
  `uvm_object_utils(my_base_sequence)
  
  function new(string name= "my_base_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_MEDIUM)
  endfunction
  
  task pre_body ;
    First_seq = my_sequence_item :: type_id:: create("First_seq");
  endtask
  
  //Body Task
  task body;
     //First Sequence
	 start_item(First_seq);
	 First_seq.rst = 0;
	 finish_item(First_seq);
    
    //Second Sequence
	 start_item(First_seq);
	 First_seq.rst = 1;
	 finish_item(First_seq);
	

    //Third Sequence Randomized
    for(int i=0;i<20;i++)
	 begin
	 start_item(First_seq);
	 First_seq.rst = 1;
   STATUS = First_seq.randomize();
	 finish_item(First_seq);
	 end 
	 
	 //Fourth Sequence Direct case to hit cases not reached by randomization
	 start_item(First_seq);
	 First_seq.rst = 1;
	 First_seq.op_code = 4'b0010 ;
	 First_seq.srcCy = 1 ;
	 finish_item(First_seq);
	 
	 //Fifth Sequence Direct case to hit cases not reached by randomization
	 start_item(First_seq);
	 First_seq.rst = 1;
	 First_seq.op_code = 4'b1110 ;
	 First_seq.srcCy = 1 ;
	 finish_item(First_seq);
	 
	 //Sixth Sequence Direct case to test for negative inputs
	 start_item(First_seq);
	 First_seq.rst = 1;
	 First_seq.op_code = 4'b0010 ;
	 First_seq.src1 = -38 ;
	 finish_item(First_seq);
	 
	 
	 start_item(First_seq);
	 First_seq.rst = 1;
	 finish_item(First_seq);
	 
	 start_item(First_seq);
	 First_seq.rst = 1;
	 finish_item(First_seq);
	 
	 start_item(First_seq);
	 First_seq.rst = 1;
	 finish_item(First_seq);
  endtask
  
endclass: my_base_sequence


