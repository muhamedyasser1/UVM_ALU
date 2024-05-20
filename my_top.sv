//`include "/home/vlsi/VerificationFinalProject/DUT_Files/oc8051_timescale.v"


import uvm_pkg::*;
`include "uvm_macros.svh"


//--------------------------------------------------------
//Include Files
//--------------------------------------------------------
`include "/home/vlsi/VerificationFinalProject/DUT_Files/oc8051_multiply.v"
`include "/home/vlsi/VerificationFinalProject/DUT_Files/oc8051_divide.v"
`include "/home/vlsi/VerificationFinalProject/DUT_Files/oc8051_alu.v"
`include "/home/vlsi/VerificationFinalProject/NEW_Interface/aluInterface.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_sequence_item.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_sequence.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_sequencer.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_driver.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_monitor.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_agent.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_scoreboard.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_subscriber.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_enviroment.sv"
`include "/home/vlsi/VerificationFinalProject/NEW_UVM_Files/my_test.sv"


module top;
  //--------------------------------------------------------
  //Instantiation
  //--------------------------------------------------------
  logic clk;
  
  aluInterface INTERFACE(clk);
	oc8051_alu DUT(clk,
							 INTERFACE.rst,
							 INTERFACE.op_code,
							 INTERFACE.src1,
							 INTERFACE.src2,
							 INTERFACE.src3,
							 INTERFACE.srcCy,
							 INTERFACE.srcAc,
							 INTERFACE.bit_in,
							 INTERFACE.des1,
							 INTERFACE.des2,
							 INTERFACE.des_acc,
							 INTERFACE.desCy,
							 INTERFACE.desAc,
							 INTERFACE.desOv,
							 INTERFACE.sub_result);

  
  
  //--------------------------------------------------------
  //Interface Setting
  //--------------------------------------------------------
  initial begin
    uvm_config_db #(virtual aluInterface)::set(null, "*", "vif", INTERFACE);
    //-- Refer: https://www.synopsys.com/content/dam/synopsys/services/whitepapers/hierarchical-testbench-configuration-using-uvm.pdf
  end
  
  
  
  //--------------------------------------------------------
  //Start The Test
  //--------------------------------------------------------
  initial begin
    run_test("my_test");
  end
  
  
  //--------------------------------------------------------
  //Clock Generation
  //--------------------------------------------------------
  initial begin
    clk = 0;
    #5;
    forever begin
      clk = ~clk;
      #2;
    end
  end
  
  
  //--------------------------------------------------------
  //Maximum Simulation Time
  //--------------------------------------------------------
  initial begin
    #5000;
    $display("Sorry! Ran out of clock cycles!");
    $finish();
  end
  
  
  //--------------------------------------------------------
  //Generate Waveforms
  //--------------------------------------------------------
  initial begin
    $dumpfile("d.vcd");
    $dumpvars();
  end
  
  
  
endmodule: top
