class my_sequence_item extends uvm_sequence_item;
	`uvm_object_utils(my_sequence_item)
	
	function new(string name="my_sequence_item");
		super.new(name);
		`uvm_info("SEQUENCE_ITEM_CLASS", "Inside Constructor!", UVM_MEDIUM)
	endfunction
	
	randc bit        srcCy, srcAc, bit_in;
	randc bit  [3:0] op_code;
	randc bit  [7:0] src1, src2, src3;
	bit       desCy, desAc, desOv;
	bit [7:0] des1, des2, des_acc, sub_result;
	bit clk, rst ;
	bit [15:0] inc, dec;
	bit da_tmp ;
	bit [1:0] cycle;
	
		 constraint c1 {
				src2 != 0 ;}
endclass: my_sequence_item
