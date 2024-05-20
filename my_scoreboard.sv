class my_scoreboard extends uvm_scoreboard;

	my_sequence_item First_Seq;
	uvm_analysis_export #(my_sequence_item) scoreboard_port; 
	uvm_tlm_analysis_fifo #(my_sequence_item) m_tlm_fifo;
	
   bit [7:0]add;
   bit [7:0]sub;
   bit [15:0]mul;
   bit [7:0]div;
   bit [7:0]logic_and;
   bit [7:0]op_dec;
   bit [7:0]op_pcs;
   bit [7:0]op_exc;
   
	`uvm_component_utils(my_scoreboard)
  
  function new(string name = "my_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_MEDIUM)
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_MEDIUM)
    First_Seq = my_sequence_item::type_id::create("First_Seq");
    scoreboard_port = new("scoreboard_port",this); 
    m_tlm_fifo  = new ("m_tlm_fifo",this);
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB_CLASS", "Connect Phase!", UVM_MEDIUM)
    scoreboard_port.connect(m_tlm_fifo.analysis_export); 
  endfunction: connect_phase
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("SCB_CLASS", "Run Phase!", UVM_MEDIUM)
    forever begin
      /*
      // get the packet
      // generate expected value
      // compare it with actual value
      // score the transactions accordingly
      */
      
      m_tlm_fifo.get_peek_export.get(First_Seq);
      compare(First_Seq);
    end
  endtask: run_phase
  
  task compare(my_sequence_item curr_trans);
    add = (First_Seq.src1 + First_Seq.src2 + First_Seq.srcCy) ;
	  sub = (First_Seq.src1- First_Seq.src2 - First_Seq.srcCy) ; 
	  mul = First_Seq.src1 * (First_Seq.cycle == 2'h0 ? First_Seq.src2[7:6]
                           : First_Seq.cycle == 2'h1 ? First_Seq.src2[5:4]
                           : First_Seq.cycle == 2'h2 ? First_Seq.src2[3:2]
                           : First_Seq.src2[1:0]);
	  div = First_Seq.src1 / First_Seq.src2 ;
	  logic_and = First_Seq.src1 & First_Seq.src2 ;
	  op_dec[3:0] = (First_Seq.srcAc == 1'b1 | First_Seq.src1[3:0] > 4'b1001) ? {1'b0, First_Seq.src1[3:0]} + 5'b00110 : {1'b0, First_Seq.src1[3:0]};
	  op_dec[7:4] = (First_Seq.srcCy | First_Seq.da_tmp | First_Seq.src1[7:4] > 4'b1001) ? {First_Seq.srcCy, First_Seq.src1[7:4]} + 5'b00110 + {4'b0, First_Seq.da_tmp} : {First_Seq.srcCy, First_Seq.src1[7:4]} + {4'b0, First_Seq.da_tmp};
	  First_Seq.inc = {First_Seq.src2 , First_Seq.src1} + {15'h0, 1'b1};
	  First_Seq.dec = {First_Seq.src2 , First_Seq.src1} - {15'h0, 1'b1};
	  op_pcs = First_Seq.srcCy ? First_Seq.dec[7:0] : First_Seq.inc[7:0];
	  op_exc = First_Seq.srcCy ? First_Seq.src2 : {First_Seq.src1[7:4], First_Seq.src2[3:0]};

	  
	  
	  
	if (First_Seq.rst == 1) begin

    if (First_Seq.op_code == 4'b0001) begin
        if (First_Seq.des_acc == add ) begin
			$display("-------------------------------------------");
            $display(" [%0t] Addition Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Addition Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, add );
        end
    end
	else if (First_Seq.op_code == 4'b0010)begin
			
		if (sub == First_Seq.des_acc) begin
			$display("-------------------------------------------");
            $display(" [%0t] Subtraction Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Subtraction Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, sub );
        end
	end
	else if (First_Seq.op_code == 4'b0011)begin
			
		if (mul == {First_Seq.des_acc,First_Seq.des2}) begin
			$display("-------------------------------------------");
            $display(" [%0t] Multiplication Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Multiplication Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, {First_Seq.des_acc[7:0],First_Seq.des2[7:0]});
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, mul );
        end
	end
	else if (First_Seq.op_code == 4'b0100)begin
			
		if (div == First_Seq.des2) begin
			$display("-------------------------------------------");
            $display(" [%0t] Division Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Division Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des2);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, div );
        end
	end
	else if (First_Seq.op_code == 4'b0101)begin
			
		if (op_dec == First_Seq.des_acc) begin
			$display("-------------------------------------------");
            $display(" [%0t] operation decimal adjustment Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] operation decimal adjustment Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, op_dec );
        end
	end
	else if (First_Seq.op_code == 4'b0110)begin
			
		if (~First_Seq.src1 == First_Seq.des_acc) begin
			$display("-------------------------------------------");
            $display(" [%0t] Not Logic Operation Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Not Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, ~First_Seq.src1 );
        end
	end
	else if (First_Seq.op_code == 4'b0111)begin
			
		if (First_Seq.des1 == logic_and ) begin
			$display("-------------------------------------------");
            $display(" [%0t] AND Logic Operation Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] AND Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, logic_and );
        end
	end
		else if (First_Seq.op_code == 4'b1000)begin
			
		if (First_Seq.des_acc == First_Seq.src1 ^ First_Seq.src2 ) begin
			$display("-------------------------------------------");
            $display(" [%0t] XOR Logic Operation Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] XOR Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, First_Seq.src1 ^ First_Seq.src2 );
        end
	end
	else if (First_Seq.op_code == 4'b1001)begin
			
		if (First_Seq.des_acc == First_Seq.src1 | First_Seq.src2 ) begin
			$display("-------------------------------------------");
            $display(" [%0t] OR Logic Operation Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] OR Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, First_Seq.src1 | First_Seq.src2 );
        end
	end
	else if (First_Seq.op_code == 4'b1010)begin
			
		if (First_Seq.des_acc == {First_Seq.src1[6:0], First_Seq.src1[7]}) begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Left Logic Operation Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Left Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.src1[6:0], First_Seq.src1[7]} );
        end
	end
		else if (First_Seq.op_code == 4'b1011)begin
			
		if (First_Seq.des_acc == {First_Seq.src1[6:0], First_Seq.srcCy}) begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Left with carry Logic Operation Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Left with carry Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.src1[6:0], First_Seq.srcCy} );
        end
	end
	else if (First_Seq.op_code == 4'b1100)begin
			
		if (First_Seq.des_acc == {First_Seq.src1[0], First_Seq.src1[7:1]}) begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Right Logic Operation Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Right Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.src1[0], First_Seq.src1[7:1]});
        end
	end
	else if (First_Seq.op_code == 4'b1101)begin
			
		if (First_Seq.des_acc == {First_Seq.srcCy, First_Seq.src1[7:1]}) begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Right with carry Logic Operation Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Right with carry Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.srcCy, First_Seq.src1[7:1]});
        end
	end
		else if (First_Seq.op_code == 4'b1110)begin
			
		if (First_Seq.des_acc == op_pcs) begin
			$display("-------------------------------------------");
            $display(" [%0t] Operation pcs Add Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Operation pcs Add Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, op_pcs);
        end
	end
	else if (First_Seq.op_code == 4'b1111)begin
			
		if (First_Seq.des_acc == op_exc) begin
			$display("-------------------------------------------");
            $display(" [%0t] operation exchange Pass", $time - 20);
			
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] operation exchange Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, op_exc);
        end
	end
end

  endtask: compare  
endclass: my_scoreboard
